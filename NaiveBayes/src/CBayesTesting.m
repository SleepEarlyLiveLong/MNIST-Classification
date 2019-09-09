% CBayesTesting: This file is to view the probability of each bit of image-vector
%            as continuous, not discrete where p=0 or p=1.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
tic;
close all;clear;clc;
% �����Ѿ�ѵ���õ�ģ��(���ݼ�)
preaddr = 'models\';
load([preaddr,'CPattern28x28smaller.mat']);

% �����趨
lPiece = 1;         % ÿСƬ�� lPiece^2 �����ص�
nPiece = 28;        % ÿ��ͼƬ�� nPiece^2 ��СƬ

% ע������ͼ��Ҫ���㻯����ֵ��
prefix = ('test-images\');
img_name='test6_700.png';
% prefix = ('E:\My Matlab Files\dip\handwriting\othertestpic\');
% img_name='0.jpg';
im=imread([prefix,img_name]);
im=im_pre_here(im,'bw');
figure;imshow(im);

% ��ÿһ��im�ָ��
fe = zeros(nPiece^2,1);
piece=1;
for A1=1:lPiece:29-lPiece
    for A2=1:lPiece:29-lPiece
        temp=im(A1:A1+lPiece-1,A2:A2+lPiece-1);
        fe(piece)=sum(sum(temp));
        piece = piece+1;
    end
end
        
%%
% ���ˣ��õ���һ��������������������fe��������ʶ�������
% ��������
cond_prob = 2*ones(10,1);
% �������
post_prob = zeros(10,1);
% ����10������
for A1=1:10
    % ���ڴ�ȷ�����ֵ�ÿһλ 1:49
    for A2=1:nPiece^2
        cond_prob(A1)=cond_prob(A1)*CPattern(A1).feature_prob(A2,fe(A2)+1)*sqrt(10);
    end
    % �������
    post_prob(A1) = cond_prob(A1)*CPattern(A1).prob;
end
% ȡ��������
[~,I]=max(post_prob);
% ���� I-1 ����ʶ����
fprintf('This is digital %1d.\n',I-1);
toc

%%