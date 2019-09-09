% CBayesTraining: Convert picture to matrix as continuous data, so called
% 'Training' process in machine learning.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;

% �����趨
lPiece = 7;         % ÿСƬ�� lPiece^2 �����ص�
nPiece = 4;        % ÿ��ͼƬ�� nPiece^2 ��СƬ

% ����Ԫ�����飬ÿ��Ԫ�ؾ���һ���ṹ�壬ע����ȷʹ��()��{}
img_list = cell(10,1);
prefix=('train-images-smaller\');
for i=1:10
    img_list{i}=dir([prefix,'train',num2str(i-1),'_*.png']);
end

% ѵ����0-9ÿ�����ֵĸ�����������testlen_vec��
testlen_vec = zeros(10,1);
for i=1:10
    testlen_vec(i) = length(img_list{i});
end

% Ϊ�ṹ������Ԥ�����ڴ� (ѵ����)
CPattern = repmat(struct('digital',0,'num',0,'feature',...
    zeros(nPiece^2,max(testlen_vec)),...
    'feature_prob',zeros(nPiece^2,lPiece^2+1),'mean',zeros(nPiece^2,1),...
    'var',zeros(nPiece^2,1),'prob',0),10,1);
for i=1:10
    CPattern(i).digital = i-1;
    CPattern(i).num = testlen_vec(i);
    CPattern(i).feature = zeros(nPiece^2,testlen_vec(i));
end

% ����0-9��10������
for A1=1:10
    % ÿ�������ж��ٸ�����
    len = length(img_list{A1,1});
    % ȷ������ѵ����ѧϰ��������Ŀ
    for A2=1:len
        img_name = img_list{A1,1}(A2).name;
        % ע�⣡����ת���double��Ϊ�˼�С���ݣ�0-1��0-255С����
        % ת bw ��Ϊ��ȷ��ʹ�� lPiece^2 �ַ� 
        im = imbinarize(im2double(imread([prefix,img_name])));
%         figure;imshow(im);
        % ���磺��ֳ�7*7=49��С��(Piece)��ÿ��С����4*4=16��Ԫ��
        Piece = 1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp = im(A3:A3+lPiece-1,A4:A4+lPiece-1);
                % ���磺���ñ�ǣ�ֱ�ӽ���ֵ������������
                CPattern(A1).feature(Piece,A2) = sum(sum(temp));
                Piece = Piece+1;
            end
        end
    end
    
    % ������Ϊ�˵õ���������ÿһά��ȡֵ��0,1,...,17�ĸ���
    % ÿһ�У��� 7x7=49 ��
    for A2=1:nPiece^2
        % ÿһ�У�ѵ��������
        for A3=1:testlen_vec(A1)
            % account ��֡(�� 4x4 ��С)�ڰ�ɫ���ص������ȡֵ��Χ��0,1,...,17
            account = CPattern(A1).feature(A2,A3);
            CPattern(A1).feature_prob(A2,account+1)=CPattern(A1).feature_prob(A2,account+1)+1;
        end
        % ���ӷ�ĸ��+1 ��Ϊ�˱���0����
        CPattern(A1).feature_prob(A2,:)=(CPattern(A1).feature_prob(A2,:)+1)/(testlen_vec(A1)+1);
    end
        
    % ������Ϊ�˵õ���������ÿһά��ȡֵ�ľ�ֵ�ͷ����Ȼ����Ϊ��ûʲô��
    for A2=1:nPiece^2
        CPattern(A1).mean(A2,1) = mean(CPattern(A1).feature(A2,:));
        CPattern(A1).var(A2,1) = var(CPattern(A1).feature(A2,:));
    end
    CPattern(A1).prob = testlen_vec(A1)/sum(testlen_vec);
    fprintf('Calss %1d:%5d images are written to mat.\n',A1-1,testlen_vec(A1));
end
% ---------���ˣ��ṹ������Patternд����ϣ������ݼ�ģ���ѽ���-------------

% ��Pattern����ֵ�洢�ڵ�ǰĿ¼�����ݰ� Pattern2000.mat ��
% ע�⣺�������ֻ���Pattern
preaddr = 'models\';
save([preaddr,'CPatternsmaller.mat'],'CPattern');
