function barplotPSA(RBnumber,periodNum)
% Thing function creates box plot for the 5 different stages NREM1-3, Wake,
% and REM using slow:fast ratio
% load data
dataName = sprintf('RB%03d01',RBnumber);
% Folder path
fileName = sprintf('F:/Grad School/GitHub/ParkinsonPowerband3015/RB%03d01.mat',RBnumber);
% Load file
load(fileName);

% For every stage find the non-zero values and then concatenate
annotStage = {'NREM1';'NREM2';'NREM3';'REM';'Wake'};

% Get scored period
stage = study.AnalyzedScoredStage(periodNum)

% channel = {'C3A2', 'C4A1', 'F3A2', 'F4A1', 'O1A2', 'O2A1'};
channel = {'F3A2', 'C3A2', 'O1A2', 'F4A1', 'C4A1', 'O2A1'};

% Get the index of the non-zero windows bc the calculated period psd is
% zero padded to fit into a matrix
non0Id = length(find(study.relPowerPerChannel{1}.Alpha(periodNum,:)));

figure
% Each bar plot contains 3 groups of bars in order: frontal, central and
% occipital, each bar represents the mean of a frequency band
subplot(2,1,1)
%Frontal
mat1 = zeros(3,8);
chId1 = [3,1,5];
for row = 1 : 3
    mat1(row,1) = (mean(study.relPowerPerChannel{chId1(row)}.Delta(periodNum,1:non0Id)));
    mat1(row,2) = (mean(study.relPowerPerChannel{chId1(row)}.Theta(periodNum,1:non0Id)));
    mat1(row,3) = (mean(study.relPowerPerChannel{chId1(row)}.Alpha(periodNum,1:non0Id)));
    mat1(row,4) = (mean(study.relPowerPerChannel{chId1(row)}.Sigma(periodNum,1:non0Id)));
    mat1(row,5) = (mean(study.relPowerPerChannel{chId1(row)}.Beta1(periodNum,1:non0Id)));
    mat1(row,6) = (mean(study.relPowerPerChannel{chId1(row)}.Beta2(periodNum,1:non0Id)));
    mat1(row,7) = (mean(study.relPowerPerChannel{chId1(row)}.Gamma(periodNum,1:non0Id)));
    mat1(row,8) = (mean(study.relPowerPerChannel{chId1(row)}.TotalPower(periodNum,1:non0Id)));
end 
bar(mat1)
set(gca,'XTickLabel',{'F3A2', 'C3A2', 'O1A2'})
grid on
grid minor
title(sprintf('Period: %s',stage{1}))

subplot(2,1,2)
mat2 = zeros(3,8);
chId2 = [4,2,6];
for row = 1 : 3
    mat2(row,1) = mean(study.relPowerPerChannel{chId2(row)}.Delta(periodNum,1:non0Id));
    mat2(row,2) = mean(study.relPowerPerChannel{chId2(row)}.Theta(periodNum,1:non0Id));
    mat2(row,3) = mean(study.relPowerPerChannel{chId2(row)}.Alpha(periodNum,1:non0Id));
    mat2(row,4) = mean(study.relPowerPerChannel{chId2(row)}.Sigma(periodNum,1:non0Id));
    mat2(row,5) = mean(study.relPowerPerChannel{chId2(row)}.Beta1(periodNum,1:non0Id));
    mat2(row,6) = mean(study.relPowerPerChannel{chId2(row)}.Beta2(periodNum,1:non0Id));
    mat2(row,7) = mean(study.relPowerPerChannel{chId2(row)}.Gamma(periodNum,1:non0Id));
    mat2(row,8) = mean(study.relPowerPerChannel{chId2(row)}.TotalPower(periodNum,1:non0Id));
end 
bar(mat2)
set(gca,'XTickLabel',{'F4A1', 'C4A1', 'O2A1'})
grid on
grid minor 
legend('Delta', 'Theta', 'Alpha', 'Sigma', 'Beta1', 'Beta2','Gamma','Total Power','Location','east','Orientation','Vertical');
end 