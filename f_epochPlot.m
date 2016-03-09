function f_epochPlot(RBnumber, stage1, stage2, epoch)
% This function plots out 2 epochs of the same type (i.e. epoch 1 and 8 of
% NREM1)
% Set Path
addpath(genpath('F:/Grad School/GitHub/Result'));
load(sprintf('RB%03d01.mat',RBnumber))

% Get type data
data1 = cell2mat(stage1.SFR(epoch));
data2 = cell2mat(stage2.SFR(epoch));
% Plot the time
% Plot
figure
subplot(6,2,1)
plot(data1(:,1))
subplot(6,2,2)
plot(data2(:,1))
subplot(6,2,3)
plot(data1(:,2))
subplot(6,2,4)
plot(data1(:,2))
subplot(6,2,1)
plot(data1(:,1))



