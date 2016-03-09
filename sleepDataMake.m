clear all; clc
%%
% This script does a Fourier Transform on eeg recordings of patients from
% the Chahine Parkinson study, using pwelch by calling the function
% f_sleep_powerbands.

% List of patients RB number
% RB = [4, 9, 11:13, 18,19, 23,24, 26, 31:36, 38:43, 46: 53,  57, 59, 61:63, 68, 70:72,74, 76:80, 85, 88:92, 95,96, 98:106, 110:113];
RB = [43, 46: 53,  57, 59, 61:63, 68, 70:72,74, 76:80, 85, 88:92, 95,96, 98:106, 110:113];
%%
% Establish iEEG session with the portal
if ~exist('session','var')  % load session if it does not exist
    dataName = sprintf('RB%03d01',RB(1));
    session = IEEGSession(dataName,'gogglehead','gog_ieeglogin.bin');
    for r = 2 : length(RB)
        dataSet = sprintf('RB%03d01',RB(r));
        session.openDataSet(dataSet);
    end
else    % clear and throw exception if session doesn't have the right datasets
    if (~strcmp(session.data(1).snapName, dataSet) || ...
            (length(session.data) ~= length(RB)))
        clear all;
        throw('Need to clear session data.  Re-run the script.');
    end
end

%%
% Get all the annotations time and duration for NREM, Wake, and REM.
% NOTE: Bad data-annotated periods are removed. Arousal-annotated periods
% are shortened to 5 sec before removal. Also, NREM 1-3 are combined into
% just NREM.

% NOTE: Time are all in microseconds.

% Annots for data that will be kept.
annotLayerKeep = {'NREM1';'NREM2';'NREM3';'REM';'Wake'};
% Annot for data that will be removed later
annotLayerRemove = {'Bad Data';'Arousal'};
for d = 1 : length(RB)
    fprintf('Processising RB%03d01\n',RB(d));
    labels = []; startTime = []; endTime = [];
    EventTimesKeep = []; EventTimesRemove = [];
    
    % Get the duration of the recording,
    
    % Get the start and end time for NREM, REM and wake
    for annot = 1: length(annotLayerKeep)
        try
            [Event, EventTimesKeep, Chan] = getAllAnnots(session.data(d),annotLayerKeep{annot});
            labels = [labels; repmat(annot,length(Event),1)];
            startTime = [startTime; EventTimesKeep(:,1)];
            endTime = [endTime; EventTimesKeep(:,2)];
        end
    end
    
    % Sort by start time
    [sortStartKeep, Id] = sort(startTime);
    labelsKeep = labels(Id);
    sortEndKeep = endTime(Id);
    
    labelsRemove = []; startTime = []; endTime = []; Event = [];
    % Get the start and end time for bad data and arousal
    for ann = 1:length(annotLayerRemove)
        try
            [Event, EventTimesRemove, Chan] = getAllAnnots(session.data(d),annotLayerRemove{ann});
            labelsRemove = [labelsRemove; repmat(ann,length(Event),1)];
            startTime = [startTime; EventTimesRemove(:,1)];
            if ann == 1
                endTime = [endTime; EventTimesRemove(:,2)];
            else
                % if Arousal, set end time as start time + 5 sec
                endTime = [endTime; startTime(end-length(Event)+1:end) + 5e6];
            end
        end
    end
    
    % Sort by start time
    [sortStartRemove, Id] = sort(startTime);
%     labelsRemove = labelsRemove(Id);
    sortEndRemove = endTime(Id);
    
    %%
    % Get data from each NREM, REM and Wake period
    
    % Get the id of channels C3-A2, C4-A1, F3-A2, F4-A1, O1-A2, O2-A1
    % NOTE: need to work on a finder function to get channel id. Right now
    % hard code as C3-A2(4), C4-A1(5), F3-A2(13), F4-A1(14), O1-A2(21),
    % O2-A1(22)
    chId = [4; 5; 13; 14; 21; 22];
    
    % Set up parameters for calling f_sleep_powerbands later
    params.windowLength = 30;         % sec, duration of sliding window
    params.windowDisplacement = 15;
    params.smoothDur = 0;
    params.channels = chId;
    fs = 128;
    
    % Choose periods that are longer than the window length
    durationAnnot = (sortEndKeep - sortStartKeep)./1e6;
    idAnnotPassed = [];
    idAnnotPassed = find(durationAnnot > params.windowLength);
    annotChosen = [];
    annotChosen = labelsKeep(idAnnotPassed);
    sortStartChosen = sortStartKeep(idAnnotPassed);
    sortEndChosen = sortEndKeep(idAnnotPassed);
    Power = [];
    for period = 1 : length(annotChosen)
        
        data = cell(length(annotChosen),1);
        tic
        fprintf('Period %d out of %d\n',period, length(annotChosen))
        annotLayerKeep(annotChosen(period))
        % Get values from the portal for each period and exclude Nan
        periodValue = [];
        periodValue = session.data(d).getvalues(sortStartChosen(period)/1e6*fs : sortEndChosen(period)/1e6*fs, chId);
        idNan = find(isnan(periodValue(:,1)),1);
        periodValue(idNan:end,:) = [];
        
        % Find all the Bad data and Arousal periods within this period and
        % exclude them
        % Get the indexes of the bad data and arousal
        idRemove = find(sortStartRemove > sortStartChosen(period) & sortEndRemove < sortEndChosen(period));
        % Set the period value of the bad data and arousal to 0
        for remov = 1 : length(idRemove)
            periodValue(ceil((sortStartRemove(idRemove(remov))-sortStartChosen(period))/1e6*fs):floor((sortEndRemove(idRemove(remov))-sortStartChosen(period))/1e6*fs),:) = 0;
        end
        
        % Call f_sleep_powerbands to calculate power spectrum
        
        NumWins = @(xLen, fs, winLen, winDisp)  round((xLen/fs -winLen) /winDisp);
        nw = int64(NumWins(length(periodValue), fs, params.windowLength, params.windowDisplacement));
        tic
        Total = []; Delta = []; Theta = []; Alpha = [];
        Sigma = []; Beta1 = []; Beta2 = []; Gamma = [];
        pxx = []; f =[]; SFR = [];
        for chan = 1 : length(chId)
            for w = 1 : nw
                
                winBeg = params.windowDisplacement * fs * (w-1) +1;
                winEnd = min([winBeg+params.windowLength*fs-1 length(periodValue)]);
                winData = periodValue(winBeg : winEnd,chan);
                
                [pxx,f] = pwelch(winData,[],[],[0.5:1/64:48],fs);
                
                Total(w,chan) = sum(pxx);
                
                IdDelta = find(f >= 0.5 & f <3.5);
                Delta(w,chan) = sum(pxx(IdDelta));
                
                IdTheta = find(f >= 3.5 & f <8);
                Theta(w,chan) = sum(pxx(IdTheta));
                
                IdAlpha = find(f >= 8 & f <12.5);
                Alpha(w,chan) = sum(pxx(IdAlpha));
                
                IdSigma = find(f >= 12.5 & f <16);
                Sigma(w,chan) = sum(pxx(IdSigma));
                
                IdBeta1 = find(f >= 16 & f <24);
                Beta1(w,chan) = sum(pxx(IdBeta1));
                
                IdBeta2 = find(f >= 24 & f <32);
                Beta2(w,chan) = sum(pxx(IdBeta2));
                
                IdGamma = find(f >= 32 & f <48);
                Gamma(w,chan) = sum(pxx(IdGamma));
                
                SFR(w,chan) = (Delta(w,chan) + Theta(w,chan)) ./ (Alpha(w,chan) + Sigma(w,chan) + Beta1(w,chan) + Beta2(w,chan) + Gamma(w,chan));
            end
        end
        Power(period).Total = Total;
        Power(period).Delta = Delta;
        Power(period).Theta = Theta;
        Power(period).Alpha = Alpha;
        Power(period).Sigma = Sigma;
        Power(period).Beta1 = Beta1;
        Power(period).Beta2 = Beta2;
        Power(period).Gamma = Gamma;
        Power(period).SFR   = SFR;
    end
    
    study.RB = sprintf('RB%03d01',RB(d));
    study.PSD = Power;
    study.ScoredStage = annotLayerKeep(labelsKeep);
    study.AnalyzedScoredStageInd = idAnnotPassed;
    study.AnalyzedScoredStage = annotLayerKeep(annotChosen);
    study.StartTimeUSec = sortStartKeep;
    study.EndTimeUSec = sortEndKeep;
    fileNameSave = sprintf('F:/Grad School/GitHub/ParPow3015/RB%03d01.mat',RB(d));
    save(fileNameSave, 'study');
    toc
end

