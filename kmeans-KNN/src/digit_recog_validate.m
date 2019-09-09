% digit_recog_validate.m: 
%   This file is for data validation, Determine which category of data in 
%   the validation set belongs to using KNN.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% ���·��
clear;close;
addpath('functions/');

%% ��ȡ����
tic;
datatoload = 2;         % 1-DIGITS.mat; 2-DIGITS_dedimen.mat
if datatoload == 1
    load('data\cluster_C.mat');
    load('data\DIGITS.mat');
    pic_size = 28;      % ��άǰ������ά����28*28
elseif datatoload == 2
    load('data\cluster_C_dedimen.mat');
    load('data\DIGITS_dedimen.mat');
    DIGITS = DIGITS_dedimen;
    pic_size = 8;       % ��ά�������ά��,����ά����28*28
else
    error('Error! datatoload should be either 1 or 2.');
end
chara_dimen = pic_size*pic_size;
%% ʶ��/����
% ���Ա�ʶ��ʵ��Ĳ�֮ͬ�����ڣ�
% �Ա�ʶ���Ƕ��������⣬������20�������Ǹ�10�������⣬��������784��.

% ��kmeans���������ĵ㼯�е�һ��������
% ÿ�θ�ֵk�У����������ָ�ֵ
k=10;
centers = zeros(10*k,chara_dimen+1);
for i=1:10
    centers((i-1)*k+1:i*k,1:chara_dimen) = cluster_C{i,1};
    centers((i-1)*k+1:i*k,chara_dimen+1) = i;
end

%-------- �������м�Ч��չʾ��ʵ��Ӧ��ʱ��ע�ͣ�datatoload=2 ʱ������ --------%
% fprintf('��ͼ��ʾ����%d���������ĵ�ͼ��.\n',10*k);
% figure;
% for n=1:100
%     pic = zeros(pic_size,pic_size);
%     for i=1:pic_size
%         for j=1:pic_size
%             pic(i,j) = centers(n,pic_size*(i-1)+j);
%         end
%     end
%     subplot(10,10,n);
%     imshow(pic/255,[]);
% end
% fprintf('��������ͼ����ʾ���.\n');
%---------- -------------------------------------------------------------%

%% KNNʶ��/����
dists = zeros(10*k,2);
for i=1:10
    dists((i-1)*k+1:i*k,2) = zeros(k,1)+i*ones(k,1);
end
RESULTS_num = zeros(10,10);
probnum = zeros(10,1);
K = 1;
% ��ÿһ������(��0-9��ʮ������)
for category=1:10
    % ÿһ�����ֵĲ�����������
    for i=1:size(DIGITS{category,1}.Data_test,1)    
        % ��ÿ������������չ��100��,�������ͱȽ���������ĵľ���
        temp = repmat(DIGITS{category,1}.Data_test(i,:),10*k,1);
        dists(:,1) = sum((temp-centers(:,1:chara_dimen)).^2,2);
        [B,ind] = sort(dists(:,1));
        ind = ind(1:K,1);
        % �ж������k���������ĸ����ֵ�����
        for j=1:K
            switch dists(ind(j,1),2)
                case 1
                    probnum(1) = probnum(1)+1;
                case 2
                    probnum(2) = probnum(2)+1;
                case 3
                    probnum(3) = probnum(3)+1;
                case 4
                    probnum(4) = probnum(4)+1;
                case 5
                    probnum(5) = probnum(5)+1;
                case 6
                    probnum(6) = probnum(6)+1;
                case 7
                    probnum(7) = probnum(7)+1;
                case 8
                    probnum(8) = probnum(8)+1;
                case 9
                    probnum(9) = probnum(9)+1;
                case 10
                    probnum(10) = probnum(10)+1;
            end
        end
        [~,test_rslt] = max(probnum);
        RESULTS_num(category,test_rslt) = RESULTS_num(category,test_rslt)+1;
        probnum = zeros(10,1);          % ǧ���������� probnum ���㣡����
    end
    fprintf('����%d�Ĳ��Լ��Ѳ������.\n',category);
end

%% �ɸ�������ʶ�����
% 0-9���Եĸ���
RESULTS_prob = zeros(10,10);
for raw=1:10
    if sum(RESULTS_num(raw,:))~=size(DIGITS{raw,1}.Data_test,1)
        fprintf('����%d��������.\n',category);
        break;
    else
        for col = 1:10
            RESULTS_prob(raw,col) = RESULTS_num(raw,col)/sum(RESULTS_num(raw,:));
        end
    end
end
% �ܵĸ���
total_num = 0;
for s=1:10
    total_num = total_num+RESULTS_num(s,s);
end
total_prob = total_num/sum(sum(RESULTS_num));
toc

%% ɾ��·��
rmpath('functions/');

%%