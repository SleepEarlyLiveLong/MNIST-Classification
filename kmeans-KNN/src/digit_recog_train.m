% digit_recog_train.m: 
%   This file is for data training, clustering several thousands of samples
%   of ten digits from 0 to 9 into k categories.
% 
%   Copyright (c) 2018 CHEN Tianyang 
%   more info contact: tychen@whu.edu.cn

%% 添加路径
clear;close;
addpath('functions/');

%% 提取数据
tic;
datatoload = 2;     % 1-DIGITS.mat; 2-DIGITS_dedimen.mat
if ~exist('data\DIGITS.mat','file')
    predir = 'digits';
    list = dir(predir);
    DIGITS = cell(20,1);
    for i=1:length(list)-2
        DIGITS{i} = load([predir,'\',list(i+2).name]);
    end
    save('data\DIGITS.mat','DIGITS');
else
    if datatoload == 1
        load('data\DIGITS.mat');
    elseif datatoload == 2
        load('data\DIGITS_dedimen.mat');
        DIGITS = DIGITS_dedimen;
    else
        error('Error! datatoload should be either 1 or 2.');
    end
end

%% 聚类
k=10;
errdlt = 0.5;
cluster_idx = cell(10,1);
cluster_C = cell(10,1);
for i=1:10
    [cluster_idx{i},cluster_C{i},~,~,~] = mykmeans(DIGITS{i+10}.Data_train,k,1,errdlt);
    fprintf('数字%d的训练集聚类完成.\n',i);
end
% 保存训练后的聚类中心
if datatoload == 1
    save('data\cluster_idx.mat','cluster_idx');
    save('data\cluster_C.mat','cluster_C');
elseif datatoload == 2
    save('data\cluster_idx_dedimen.mat','cluster_idx');
    save('data\cluster_C_dedimen.mat','cluster_C');
else
    error('Error! datatoload should be either 1 or 2.');
end
toc

%% 删除路径
rmpath('functions/');

%%