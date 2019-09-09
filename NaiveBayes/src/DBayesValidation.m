% DBayesValidation: This file is to view the probability of each bit of image-vector
%            as discrete where p=0 or p=1.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;
load('models\Patternlabanother.mat');

% �����趨
lPiece = 7;        % ÿСƬ��16�����ص�
nPiece = 4;        % ÿ��ͼƬ��49СƬ
nthres = 12;

prefix = ('test-images\');
% ����Ԫ�����飬Ԫ���ǲ��Լ���0-9���ļ�·��
img_list = cell(10,1);
for A1=1:10
    img_list{A1} = dir([prefix,'test',num2str(A1-1),'_*.png']);
end

% �ñ�Ҷ˹�������ж�
% �ȵõ�һ����ʱ���ά���飩����0-9ÿһ�����ֵ�ÿһλȡֵΪ1�ĸ���
probtable = zeros(nPiece^2,10);
for col=1:10
    for raw=1:nPiece^2
        probtable(raw,col) = sum(Pattern(col).feature(raw,:))/length(Pattern(1).feature);
    end
end

%% 
% ����Ԫ�����飬���ѵ��������
% ʵ���ϵĺ��ľ��� im=imread(xxx);ֻ����Ҫ�������ʵ�λ��
% Ȼ�����ν��У���Ƭ(֡)���ֱ���������ʡ��������ļ�ʶ������
%               �Ա�label�ж�ʶ����ȷ��񡪼���ʶ����ȷ��

% ����ÿһ������
correct_num_all = 0;
for A1=1:10
    % ÿ�����ֵĲ���������
    len = length(img_list{A1});
    % ��0-9ÿһ����������һ����ȷ�ж���
    correct_num = 0;
    % ����һ�����ֵ�ÿһ����������
    for A2=1:len
        img_name=img_list{A1}(A2).name;
        im=imread([prefix,img_name]);
%         figure;imshow(im);
        % ��ÿһ��im�ָ��
        fe = zeros(nPiece^2,1);
        piece=1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp=im(A3:A3+lPiece-1,A4:A4+lPiece-1);
                if sum(sum(temp))>=255*nthres
                    fe(piece) = 1;
                end
                piece = piece+1;
            end
        end
        % ���ˣ��õ���һ��������������������fe��������ʶ�������
        % �� Bayes �������ķ���
        % ����10���������ʣ���P(X|wi),i=0,1,...,9
        % �� P(X|wi)=��(k=1,49)P(xk|wi)
        % �������Ϊ����� P(A2|A1)
        cond_prob = ones(10,1);
        % ����10������
        for A5=1:10
            % ���ڴ�ȷ�����ֵ�ÿһλ
            for A6=1:nPiece^2
                if fe(A6)==1
                    cond_prob(A5)=cond_prob(A5)*probtable(A6,A5);
                else
                    cond_prob(A5)=cond_prob(A5)*(1-probtable(A6,A5));
                end
            end
        end
        % ȡ��������
        [~,I]=max(cond_prob);
        % ���� I-1 ����ʶ��������Ҫ����ʵ���� A1-1 ���жԱ�
        if I==A1
            correct_num = correct_num+1;
        end
    end
    correct_rate = correct_num/len;
    correct_num_all = correct_num_all+correct_num;
    fprintf('Judgment rate of Class %1d is %.2f%%\n',A1-1,100*correct_rate);
end

% 100*correct_num_all/10000
fprintf('Judgment rate of all Classes is %.2f%%\n',correct_num_all/100);

%%