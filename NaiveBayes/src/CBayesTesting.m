% CBayesTesting: This file is to view the probability of each bit of image-vector
%            as continuous, not discrete where p=0 or p=1.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
tic;
close all;clear;clc;
% 载入已经训练好的模型(数据集)
preaddr = 'models\';
load([preaddr,'CPattern28x28smaller.mat']);

% 参数设定
lPiece = 1;         % 每小片有 lPiece^2 个像素点
nPiece = 28;        % 每张图片有 nPiece^2 个小片

% 注意这里图像要浮点化、二值化
prefix = ('test-images\');
img_name='test6_700.png';
% prefix = ('E:\My Matlab Files\dip\handwriting\othertestpic\');
% img_name='0.jpg';
im=imread([prefix,img_name]);
im=im_pre_here(im,'bw');
figure;imshow(im);

% 对每一个im分割处理
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
% 至此，得到了一个测试样本的特征序列fe，接下来识别该样本
% 条件概率
cond_prob = 2*ones(10,1);
% 后验概率
post_prob = zeros(10,1);
% 对于10个数字
for A1=1:10
    % 对于待确定数字的每一位 1:49
    for A2=1:nPiece^2
        cond_prob(A1)=cond_prob(A1)*CPattern(A1).feature_prob(A2,fe(A2)+1)*sqrt(10);
    end
    % 后验概率
    post_prob(A1) = cond_prob(A1)*CPattern(A1).prob;
end
% 取概率最大的
[~,I]=max(post_prob);
% 数字 I-1 就是识别结果
fprintf('This is digital %1d.\n',I-1);
toc

%%