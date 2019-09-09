% DBayesTesting: This file is to view the probability of each bit of image-vector
%               as discrete where p=0 or p=1.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
clear;close all;clc;
tic;
% �����Ѿ�ѵ���õ�ģ��(���ݼ�)
preaddr = 'models\';
load([preaddr,'Patternlabanother.mat']);

% �����趨
lPiece = 7;        % ÿСƬ��16�����ص�
nPiece = 4;        % ÿ��ͼƬ��49СƬ
nthres = 4;

% �ñ�Ҷ˹�������ж�
% �ȵõ�һ����ʱ���ά���飩����0-9ÿһ�����ֵ�ÿһλȡֵΪ1�ĸ���
probtable = zeros(nPiece^2,10);
for col=1:10
    for raw=1:nPiece^2
        probtable(raw,col) = sum(Pattern(col).feature(raw,:))/length(Pattern(1).feature);
    end
end

% prefix = ('E:test-images\');
% img_name='test8_800.png';
prefix = ('othertestpic\');
img_name='0.jpg';
im=imread([prefix,img_name]);
im=im_pre_here(im,'gray');
figure;imshow(im);

fe = zeros(nPiece^2,1);
piece=1;
for A1=1:lPiece:29-lPiece
    for A2=1:lPiece:29-lPiece
        temp=im(A1:A1+lPiece-1,A2:A2+lPiece-1);
        if sum(sum(temp))>=255*nthres
            fe(piece) = 1;
        end
        piece = piece+1;
    end
end

% ����10���������ʣ���P(X|wi),i=0,1,...,9
% �� P(X|wi)=��(k=1,49)P(xk|wi)
% �������Ϊ����� P(A2|A1)
cond_prob = ones(10,1);
% ����10������
for A1=1:10
    for A2=1:nPiece^2
        if fe(A2)==1
            cond_prob(A1)=cond_prob(A1)*probtable(A2,A1);
        else
            cond_prob(A1)=cond_prob(A1)*(1-probtable(A2,A1));
        end
    end
end
[~,I]=max(cond_prob);
fprintf('This is digital %1d.\n',I-1);
toc

%%