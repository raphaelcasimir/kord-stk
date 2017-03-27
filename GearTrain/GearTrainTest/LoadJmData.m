clear all;
%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select measured frequency response file');
FullFileA = fullfile(PathA,FileA);
[y t]=textread(FullFileA,'%f,%f','headerlines',2);