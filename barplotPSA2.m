function barplotPSA2(RBnumber,periodNum)
% Thing function creates box plot for the 5 different stages NREM1-3, Wake,
% and REM using slow:fast ratio
% load data
dataName = sprintf('RB%03d01',RBnumber);
% Folder path
fileName = sprintf('F:/Grad School/GitHub/ParkinsonPowerband3015/RB%03d01.mat',RBnumber);
% Load file
load(fileName);

% For every stage find the non-zero values and then concatenate
annotStage = {'NREM';'REM';'Wake'};

% Get scored period
stage = study.AnalyzedScoredStage(periodNum)

% channel = {'C3A2', 'C4A1', 'F3A2', 'F4A1', 'O1A2', 'O2A1'};
channel = {'F3A2', 'C3A2', 'O1A2', 'F4A1', 'C4A1', 'O2A1'};

% Get the index of the non-zero windows bc the calculated period psd is
% zero padded to fit into a matrix
non0Id = length(find(study.PSD{1}.Alpha(periodNum,:)));

figure
% Each bar plot contains 3 groups of bars in order: frontal, central and
% occipital, each bar represents the mean of a frequency band
subplot(2,1,1)
%Frontal
mat1 = zeros(3,1);
chId1 = [3,1,5];
for row = 1 : 3
    mat1(row,1) = (mean(study.PSD{periodNum}.Delta(:,chId1)));
    mat1(row,2) = (mean(study.PSD{periodNum}.Theta(:,chId1)));
    mat1(row,3) = (mean(study.PSD{periodNum}.Alpha(:,chId1)));
    mat1(row,4) = (mean(study.PSD{periodNum}.Sigma(:,chId1)));
    mat1(row,5) = (mean(study.PSD{periodNum}.Beta1(:,chId1)));
    mat1(row,6) = (mean(study.PSD{periodNum}.Beta2(:,chId1)));
    mat1(row,7) = (mean(study.PSD{periodNum}.Gamma(:,chId1)));
end 
bar(mat1)
set(gca,'XTickLabel',{'F3A2', 'C3A2', 'O1A2'})
grid on
grid minor
title(sprintf('Period: %s',stage{1}))

subplot(2,1,2)
mat2 = zeros(3,7);
chId2 = [4,2,6];
for row = 1 : 3
    mat1(row,1) = (mean(study.PSD{periodNum}.Delta(:,chId2)));
    mat1(row,2) = (mean(study.PSD{periodNum}.Theta(:,chId2)));
    mat1(row,3) = (mean(study.PSD{periodNum}.Alpha(:,chId2)));
    mat1(row,4) = (mean(study.PSD{periodNum}.Sigma(:,chId2)));
    mat1(row,5) = (mean(study.PSD{periodNum}.Beta1(:,chId2)));
    mat1(row,6) = (mean(study.PSD{periodNum}.Beta2(:,chId2)));
    mat1(row,7) = (mean(study.PSD{periodNum}.Gamma(:,chId2)));
end 
bar(mat2)
set(gca,'XTickLabel',{'F4A1', 'C4A1', 'O2A1'})
grid on
grid minor 
legend('Delta', 'Theta', 'Alpha', 'Sigma', 'Beta1', 'Beta2','Gamma','Location','east','Orientation','Vertical');
end 