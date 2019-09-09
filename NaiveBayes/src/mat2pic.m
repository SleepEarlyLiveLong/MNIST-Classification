% mat2pic: Convert the contents of 20 packets into images 
%           and store them separately.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc

% �ܴ��һ�����⣬·���е�.mat���ص������ռ��к����ֱ���
% ���֣�·���е�test0.mat��test9.mat������ȫ����Data_test��
% ��train0.mat��train9.mat������ȫ����Data_train
% ԭ��������е�.mat�ϵ�һ���ṹ����ȥ�ģ������˶�����Σ�2����
% ��ʲô����취�أ�����˵Ӧ�����еİ�����
prefix=('data\matdata\');
d=dir([prefix,'*.mat']);
for i=1:10
    a(i)=load([prefix,d(i+10).name]);        % a-ѵ����
    b(i)=load([prefix,d(i).name]);           % b-���Լ�
end

% ѵ���� 0-9����ѭ��,size(a,2)=10,��i=1:10
for i = 1:size(a,2)
    % ������ÿ�����ֵĸ���,����5923��0,��j=1:5923
    for j=1:size(a(i).Data_train,1)       
        pic = a(i).Data_train(j,:);       % һ��һ�еĶ�ȡ
        Pic = reshape(pic,28,28);          % ͼƬ��СΪ28*28  
        Pic = Pic';
        %��������
        sc_test=strcat('train-images\',sprintf('train%d_%d',i-1,j));
        Sc_test=strcat(sc_test,'.png');
        imwrite(Pic,Sc_test);
    end
    fprintf('Train: Class %1d has been converted to PNG.\n',i-1);
end

% ���Լ� 0-9����ѭ��,size(a)=10,��i=1:10
for i = 1:size(b,2)
    % ������ÿ�����ֵĸ���,����980��0,��j=1:980
    for j=1:size(b(i).Data_test,1)       
        pic = b(i).Data_test(j,:);       % һ��һ�еĶ�ȡ
        Pic = reshape(pic,28,28);          % ͼƬ��СΪ28*28   
        Pic = Pic';
        %��������
        sc_train=strcat('test-images\',sprintf('test%d_%d',i-1,j));
        Sc_train=strcat(sc_train,'.png');
        imwrite(Pic,Sc_train);
    end
    fprintf('Test: Class %1d has been converted to PNG.\n',i-1);
end
%%