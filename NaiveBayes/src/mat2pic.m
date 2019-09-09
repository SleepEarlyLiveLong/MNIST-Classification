% mat2pic: Convert the contents of 20 packets into images 
%           and store them separately.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc

% 很大的一个问题，路径中的.mat加载到工作空间中后，名字变了
% 发现：路径中的test0.mat到test9.mat的名字全都是Data_test；
% 而train0.mat到train9.mat的名字全都是Data_train
% 原本想把所有的.mat合到一个结构体中去的，现在退而求其次，2个吧
% 有什么解决办法呢？按理说应该是有的啊……
prefix=('data\matdata\');
d=dir([prefix,'*.mat']);
for i=1:10
    a(i)=load([prefix,d(i+10).name]);        % a-训练集
    b(i)=load([prefix,d(i).name]);           % b-测试集
end

% 训练集 0-9数字循环,size(a,2)=10,则i=1:10
for i = 1:size(a,2)
    % 行数即每种数字的个数,如有5923个0,则j=1:5923
    for j=1:size(a(i).Data_train,1)       
        pic = a(i).Data_train(j,:);       % 一行一行的读取
        Pic = reshape(pic,28,28);          % 图片大小为28*28  
        Pic = Pic';
        %命名保存
        sc_test=strcat('train-images\',sprintf('train%d_%d',i-1,j));
        Sc_test=strcat(sc_test,'.png');
        imwrite(Pic,Sc_test);
    end
    fprintf('Train: Class %1d has been converted to PNG.\n',i-1);
end

% 测试集 0-9数字循环,size(a)=10,则i=1:10
for i = 1:size(b,2)
    % 行数即每种数字的个数,如有980个0,则j=1:980
    for j=1:size(b(i).Data_test,1)       
        pic = b(i).Data_test(j,:);       % 一行一行的读取
        Pic = reshape(pic,28,28);          % 图片大小为28*28   
        Pic = Pic';
        %命名保存
        sc_train=strcat('test-images\',sprintf('test%d_%d',i-1,j));
        Sc_train=strcat(sc_train,'.png');
        imwrite(Pic,Sc_train);
    end
    fprintf('Test: Class %1d has been converted to PNG.\n',i-1);
end
%%