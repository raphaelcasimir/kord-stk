clear all;
%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select measured DC motor output');
FullFileA = fullfile(PathA,FileA);
[t y]=textread(FullFileA,'%f,%f','headerlines',6);
[FileA,PathA]=uigetfile('*','Select measured input');
FullFileA = fullfile(PathA,FileA);
[T u]=textread(FullFileA,'%f,%f','headerlines',6);