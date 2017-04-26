%% Homework assignment
%
% This file contains the homework assignment for Matrix Computations 2013,
% Aalborg University, 6th semester, electronical enegineering.
%
% The exercise is borrowed directly from the Stanford EE263 exercise
% catalogue, exercise 6.15, available from:
% http://www.stanford.edu/class/ee263/hw/263homework.pdf
%
% The data contained in this file is further downloaded from the EE263
% course website:
% http://www.stanford.edu/class/ee263/matlab.html
%
% For visualization, the file view_layout is required.
%
% File modified by
% Morten Juelsgaard, Aalborg University
% 11/04-2013

%% Initial
close all
clear
clc


%% Problem Data
% The node incidence matrix for the graph is
A =[ 
    1  0  0  0  0  0  0  -1 0  0  0  0;
    1  0  0  0  0  0  0  -1 0  0  0  0;
    1  0  0  0  0  0  0  -1 0  0  0  0;
    0  0  1  0  0  0  0  -1 0  0  0  0;
    0  1  0  0  0  0  0  0  -1 0  0  0;
    0  1  0  0  0  0  0  0  -1 0  0  0;
    0  1  0  0  0  0  0  0  -1 0  0  0;
    0  0  0  0  0  0  1  0  -1 0  0  0;
    0  0  1  0  0  0  0  0  0  -1 0  0;
    0  0  0  1  0  0  0  0  0  -1 0  0;
    0  0  0  1  0  0  0  0  0  -1 0  0;
    0  0  0  1  0  0  0  0  0  -1 0  0;
    0  0  0  0  1  0  0  0  0  0  -1 0;
    0  0  0  0  1  0  0  0  0  0  -1 0;
    0  0  0  0  1  0  0  0  0  0  -1 0;
    0  0  0  0  1  0  0  0  0  0  -1 0;
    0  0  0  0  0  0  1  0  0  0  -1 0;
    1  0  0  0  0  0  0  0  0  0  0  -1;
    0  0  1  0  0  0  0  0  0  0  0  -1;
    -1 1  0  0  0  0  0  0  0  0  0  0;
    -1 0  0  0  1  0  0  0  0  0  0  0;
    -1 0  0  0  1  0  0  0  0  0  0  0;
    0  -1 1  0  0  0  0  0  0  0  0  0;
    0  -1 0  1  0  0  0  0  0  0  0  0;
    0  -1 0  0  1  0  0  0  0  0  0  0;
    0  -1 0  0  0  1  0  0  0  0  0  0;
    0  0  -1 0  1  0  0  0  0  0  0  0;
    0  0  0  -1 1  0  0  0  0  0  0  0;
    0  0  0  -1 1  0  0  0  0  0  0  0;
    0  0  0  -1 1  0  0  0  0  0  0  0;
    0  0  0  -1 1  0  0  0  0  0  0  0;
    0  0  0  -1 0  1  0  0  0  0  0  0;
    0  0  0  0  -1 0  1  0  0  0  0  0;
    0  0  0  0  0  -1 1  0  0  0  0  0;
    0  0  0  0  0  -1 1  0  0  0  0  0];

% the number of variable nodes
n = 7;
% the number of links
K = size(A,1);
% total number of nodes
N = 12;
% x and y coords for the fixed nodes
xfixed = [-1 0.8 -1 1 0]';
yfixed = [0.8 1 -1 -1 0.6]';

%% Trial layout for free nodes
% Random placement of free nodes
rand('seed',0)
xtrial = 2*rand(n,1) - 1;
ytrial = 2*rand(n,1) - 1;

% Visualize the location of fixed, and randonmly placed free nodes
if(exist('view_layout')==2)
    view_layout(xtrial,ytrial,xfixed,yfixed,A);
    title('Trial placement of the free nodes')
else
    fprintf(1,'\nFunction: ''view_layout'', not located - you may download it from moodle\n');
end
    
%% Optimized node location

xopt = zeros(n,1);
yopt = zeros(n,1);

%%%%%%%% Insert optimization below %%%%%%%%%

cvx_begin
    variables xopt(n) yopt(n)
    minimize( norm(A*[xopt' xfixed']')+norm(A*[yopt' yfixed']'))
    % EQ(1.3) without norm as minimizers are the same.
cvx_end

%%%%%%%% Optimization completed %%%%%%%%%%%%

% Visualize optimized layout
if(exist('view_layout')==2)
    view_layout(xopt,yopt,xfixed,yfixed,A);
    title('Optimal placement of the free nodes')
else
    fprintf(1,'\nFunction: ''view_layout'', not located - you may download it from moodle\n');
end

% Cost of trial and optimized layout
fprintf(1,'\nCost of trial layout:     %3.3f',sum(square(A*[xtrial; xfixed])) + sum(square(A*[ytrial; yfixed])));
fprintf(1,'\nCost of optimized layout: %3.3f\n',sum(square(A*[xopt; xfixed])) + sum(square(A*[yopt; yfixed])));




