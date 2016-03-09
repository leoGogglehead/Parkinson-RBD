function boxplotPSA2(RBnumber)
% Thing function creates box plot for the 5 different stages NREM1-3, Wake,
% and REM using slow:fast ratio
% load data
dataName = sprintf('RB%03d01',RBnumber);
% Folder path
fileName = sprintf('F:/Grad School/GitHub/ParPow3015 - Copy/RB%03d01.mat',RBnumber);
% Load file
load(fileName);

% For every stage find the non-zero values and then concatenate
annotStage = {'NREM';'REM';'Wake'};
figure
channel = {'C3A2', 'C4A1', 'F3A2', 'F4A1', 'O1A2', 'O2A1'};
for ch = 1 : 6
    Delta = [];
    Theta = [];
    Alpha = [];
    Sigma = [];
    Beta1 = [];
    Beta2 = [];
    Gamma = [];
    TotalPower = [];
    SFRatio = [];
    for i = 1 : length(study.AnalyzedScoredStage)
        
        % Get the power value for each frequency band
%         non0Id = length(find(study.PSD{ch}.Alpha(i,:)));
        
%         Delta = [Delta study.relPowerPerChannel{ch}.Delta(i,1:non0Id)];
%         Theta = [Theta study.relPowerPerChannel{ch}.Theta(i,1:non0Id)];
        %         Alpha = [Alpha study.relPowerPerChannel{ch}.Alpha(i,1:non0Id)];
        %         Sigma = [Sigma study.relPowerPerChannel{ch}.Sigma(i,1:non0Id)];
%         Beta1 = [Beta1 study.relPowerPerChannel{ch}.Beta1(i,1:non0Id)];
%         Beta2 = [Beta2 study.relPowerPerChannel{ch}.Beta2(i,1:non0Id)];
        %         Gamma = [Gamma study.relPowerPerChannel{ch}.Gamma(i,1:non0Id)];
        % TotalPower = [TotalPower study.relPowerPerChannel{ch}.TotalPower(i,1:non0Id)];
            
        %         SFRatio(i) = sum((Delta + Theta)/(Alpha + Sigma + Beta1 + Beta2 + Gamma))/non0Id;
%         SFRatio(i) = sum((Delta + Theta) / (Beta1 + Beta2))/non0Id;
    SFRatio(i,ch) = (mean(study.PSD(i).SFR(:,ch)));
        end
        subplot(3,2,ch)
        boxplot(SFRatio(:,ch), study.AnalyzedScoredStage)
        title(channel{ch})
       ylim([0 20])
        ylabel('SFR')
        grid minor
        grid on
        end