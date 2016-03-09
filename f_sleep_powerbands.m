% function output = f_sleep_powerbands(data, params, fs, curTime)
function [timeOut, sleep_power] = f_sleep_powerbands(data, params, fs, curTime)

%%
% Usage: f_burst_linelength(dataset, params)
% Input:
%   'dataset'   -   [IEEGDataset]: IEEG Dataset, eg session.data(1)
%   'params'    -   Structure containing parameters for the analysis
%
% dbstop in f_sleep_powerbands at 242

%%-----------------------------------------
%%---  feature creation and data processing
% calculate number of sliding windows (overlap is ok)
%     NumWins = @(xLen, fs, winLen, winDisp) (xLen/fs)/winDisp-(winLen/winDisp-1);
NumWins = @(xLen, fs, winLen, winDisp)  round((xLen/fs -winLen) /winDisp);
nw = int64(NumWins(length(data), fs, params.windowLength, params.windowDisplacement));
timeOut = zeros(nw,1);
% featureOut = zeros(nw, length(params.channels));

filtOut = data;
% For each channel, calculate the total power and then the relative
% power of each frequency band
for ch = 1 : length(params.channels)
    winLen = params.windowLength;
    winDisp = params.windowDisplacement;
    
    %     if params.smoothDur > 0
    %         smoothLength = 1/params.windowDisplacement * params.smoothDur; % in samples of data signal
    %         smoother =  1 / smoothLength * ones(1,smoothLength);
    %
    for w = 1: nw
        ch
        w
        winBeg = params.windowDisplacement * fs * (w-1) + 1;
        winEnd = min([winBeg+params.windowLength*fs-1 length(filtOut)]);
        winData = filtOut(winBeg : winEnd, ch);
        timeOut(w) = winEnd/fs*1e6 + curTime;         % right-aligned
        
        %[pxx,f] = pwelch(winData,ones(length(winData),1),0,length(winData),fs);
        [pxx,f] = pwelch(winData, [], [],[0.5:1/256:48],fs);
        TotPowW(ch,w) = sum(pxx);
        
        IdDelta = find(f >= 0.5 & f <3.5);
        PowDeltaW(ch,w) = sum(pxx(IdDelta));
        
        IdTheta = find(f >= 3.5 & f <8);
        PowThetaW(ch,w) = sum(pxx(IdTheta));
        
        IdAlpha = find(f >= 8 & f <12.5);
        PowAlphaW(ch,w) = sum(pxx(IdAlpha));
        
        IdSigma = find(f >= 12.5 & f <16);
        PowSigmaW(ch,w) = sum(pxx(IdSigma));
        
        IdBeta1 = find(f >= 16 & f <24);
        PowBeta1W(ch,w) = sum(pxx(IdBeta1));
        
        IdBeta2 = find(f >= 24 & f <32);
        PowBeta2W(ch,w) = sum(pxx(IdBeta2));
        
        IdGamma = find(f >= 32 & f <48);
        PowGammaW(ch,w) = sum(pxx(IdGamma));
        
    end
    %         TotPowW(ch,:) = conv(TotPowW(ch,:),smoother, 'same');
    %         RelPowDeltaW(ch,:) = conv(RelPowDeltaW(ch,:),smoother, 'same');
    %         RelPowThetaW(ch,:) = conv(RelPowThetaW(ch,:),smoother, 'same');
    %         RelPowAlphaW(ch,:) = conv(RelPowAlphaW(ch,:),smoother, 'same');
    %         RelPowSigmaW(ch,:) = conv(RelPowSigmaW(ch,:),smoother, 'same');
    %         RelPowBeta1W(ch,:) = conv(RelPowBeta1W(ch,:),smoother, 'same');
    %         RelPowBeta2W(ch,:) = conv(RelPowBeta2W(ch,:),smoother, 'same');
    %         RelPowGammaW(ch,:) = conv(RelPowGammaW(ch,:),smoother, 'same');
    %
    %     end
end

sleep_power.Del = PowDeltaW';
sleep_power.The = PowThetaW';
sleep_power.Alp = PowAlphaW';
sleep_power.Sig = PowSigmaW';
sleep_power.Be1 = PowBeta1W';
sleep_power.Be2 = PowBeta2W';
sleep_power.Gam = PowGammaW';
end


