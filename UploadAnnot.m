clear all
clc
addpath(genpath('F:\Grad School\GitHub'));
RB = [1,4, 8:9, 11:13, 16, 18:20, 23,24, 26, 31:36, 38:43, 45:53, 57,59, 61:63, 68, 70:74, 76:80, 85:86, 88:92, 95:106, 110:113];

%% Establish IEEG Sessions
% Establish IEEG Portal sessions.
% Load session if it doesn't exist.
if ~exist('session','var')  % load session if it does not exist
%   addpath(genpath('F:\Grad School\Github'));
dataName = sprintf('RB%03d01',RB(1));
session = IEEGSession(dataName,'gogglehead','gog_ieeglogin.bin');
  for r = 2 : length(RB)
    dataSet = sprintf('RB%03d01',RB(r))
    session.openDataSet(dataSet);
  end
else    % clear and throw exception if session doesn't have the right datasets
  if (~strcmp(session.data(1).snapName, dataSet) || ...
      (length(session.data) ~= length(RB)))
    clear all;
    throw('Need to clear session data.  Re-run the script.');
  end
end

%% open and read in .txt files
for r = 1 : length(session.data)
  fprintf('Loaded %s\n', session.data(r).snapName)
end  

for r = 1 : length(RB)
    subjDir = sprintf('F:/Parkinson RBD Project/PSG export/RB%03d01',RB(r))
    f_txt2portal(session.data(r), subjDir);
end 