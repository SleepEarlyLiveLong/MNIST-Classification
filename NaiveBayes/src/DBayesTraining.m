% DBayesTraining: Convert picture to matrix as discrete data, so called
% 'Training' process in machine learning.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;

% �����趨
train_num = 50;
lPiece = 7;         % ÿСƬ�� lPiece^2 �����ص�
nPiece = 4;        % ÿ��ͼƬ�� nPiece^2 ��СƬ
nthres = 12;

% Ϊ�ṹ������Ԥ�����ڴ� (ѵ����<=5000)
Pattern = repmat(struct('digital',0,'num',train_num,'feature',...
    zeros(nPiece^2,train_num)),10,1);
for i=1:10
    Pattern(i).digital = i-1;
end

% ����Ԫ�����飬ÿ��Ԫ�ؾ���һ���ṹ�壬ע����ȷʹ��()��{}
img_list = cell(10,1);
prefix=('train-images\');
for i=1:10
    img_list{i}=dir([prefix,'train',num2str(i-1),'_*.png']);
end

% ����0-9��10������
for A1=1:10
    % ÿ�������ж��ٸ�����
    len = length(img_list{A1,1});
    % ȷ������ѵ����ѧϰ��������Ŀ
    for A2=1:min(len,train_num)
        img_name = img_list{A1,1}(A2).name;
        im = imread([prefix,img_name]);
%         figure;imshow(im);
        % ���磺��ֳ�7*7=49��С��(Piece)��ÿ��С����4*4=16��Ԫ��
        Piece = 1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp = im(A3:A3+lPiece-1,A4:A4+lPiece-1);
                % ���磺ֻҪ16�����г���3���ǰ�ɫ,�ͱ��Ϊ1(255*4=1020)
                if sum(sum(temp))>= 255*nthres
                    Pattern(A1).feature(Piece,A2) = 1;
                end
                Piece = Piece+1;
            end
        end
    end
    fprintf('Calss %1d:%5d images are written to mat.\n',A1-1,train_num);
end
% ---------���ˣ��ṹ������Patternд����ϣ������ݼ�ģ���ѽ���-------------

% ��Pattern����ֵ�洢�ڵ�ǰĿ¼�����ݰ� Pattern2000.mat ��
% ע�⣺�������ֻ���Pattern
preaddr = 'models\';
save([preaddr,'Patternlabanother.mat'],'Pattern');
