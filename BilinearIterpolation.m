% author: Jingyu Ren
% Laurentian University
% Student ID: 0421763

clc;clear;

% Define the points where we want to interpolate
Xp = 101.325;  % Pressure
Yp = 274.24:0.1:322.24;  % temperature

%% Import the data
opts = delimitedTextImportOptions("NumVariables", 82);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column types
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Cwaterdensity = readtable("C:\Laurentian\Winter 2023\Research Method\Assignment6\06C water density.csv", opts);
% Convert table to Matrix
Cwaterdensity = table2array(Cwaterdensity);
% Clear temporary variables
clear opts
% extract titles
temperature = Cwaterdensity(2:end,1)';
pressure  = Cwaterdensity(1,2:end);

%% Correlation Analysis
% rearrange the format of data for correlation analysis
density = [];
for i=2:size(Cwaterdensity,1)  % Loop for temperature
    for j=2:size(Cwaterdensity,2)  % Loop for pressure
        %  data format: [temperature1 pressure1 density2; …]
        density(end+1,:) = [Cwaterdensity(i,1) Cwaterdensity(1,j) Cwaterdensity(i,j)];
    end
end
% R(1,3) = -0.9711 indicates temperature is propably negative linearly
% dependent of density, we can use linear interpolation as a predictor
% R(1,2) = 0 , indicates temperature is not linearly dependent of pressure
% correlated with density
R = corrcoef(density)

%% Property lookup at a specific pressure of 101.325 kPa
% Define the points where we want to interpolate
% Already difined on the top
% Xp = 101.325;
% Yp = 274.24:0.1:322.24;
% Prepare known data points
X = pressure;
Y = temperature;
Z = Cwaterdensity(2:end,2:end);
% Self-defined Bilinear interpolation
Zp = jy_fit(X, Y, Z, Xp, Yp);  %%% output %%%
%% Plot the interpolated values
% surf(Xp, Yp, Zp)
figure
hold on
title(sprintf("Liquid Water Density Estimation at a pressure of %.3f kPa", Xp))
xlabel("Temperature (K)")
ylabel("Density (kg/m^3)")
p = plot(Yp,Zp,"LineWidth",1);
p.Color="black";
