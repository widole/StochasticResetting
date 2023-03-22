%% Formulate input for neural network
clear all; close all; clc

load("Test.mat")

%% Divide the saved arrays into 4 separate parts

inp1_pose = self.pose_arr(:, 1:25);
inp2_pose = self.pose_arr(:, 26:50);
inp3_pose = self.pose_arr(:, 51:75);
inp4_pose = self.pose_arr(:, 76:100);

inp1 = sum(inp1_pose(3, :));
inp2 = sum(inp2_pose(3, :));
inp3 = sum(inp3_pose(3, :));
inp4 = sum(inp4_pose(3, :));