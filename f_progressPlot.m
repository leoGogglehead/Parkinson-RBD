function f_progressPlot(RBnumber, annot)

dataName = sprintf('RB%03d01',RBnumber);
% Folder path
fileName = sprintf('F:/Grad School/GitHub/ParPow3015 - Copy/RB%03d01.mat',RBnumber);
% Load file
load(fileName);

annotStage = {'NREM';'REM';'Wake'};

% Find the indexes of the input annot
id = find(strcmp(study.AnalyzedScoredStage, annot));
channel = {'C3A2', 'C4A1', 'F3A2', 'F4A1', 'O1A2', 'O2A1'};
% Get the mean of each scored period
    for i = 1 : length(id)
        data = study.PSD(id(i)).SFR;
        avgSFR(i,:) = mean(data);
        stdSFR(i,:) = std(data);
    end
    
    figure
    for ch = 1 : 6
        subplot(3,2,ch)
        errorbar(avgSFR(:,ch),stdSFR(:,ch))
        title(channel{ch})
        ylabel('SFR')
        xlabel('scored periods')
        grid minor
        grid on
    end 
end