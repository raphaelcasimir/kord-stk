clear all;
%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select measured frequency response file');
FullFileA = fullfile(PathA,FileA);
[u t y]=textread(FullFileA,'%f,%f,%f','headerlines',2);