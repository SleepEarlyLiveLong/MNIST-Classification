% digit_recog_validate.m: 
%   This file is for data validation, Determine which category of data in 
%   the validation set belongs to using KNN.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 添加路径
clear;close;
addpath('functions/');

%% 提取数据
tic;
datatoload = 2;         % 1-DIGITS.mat; 2-DIGITS_dedimen.mat
if datatoload == 1
    load('data\cluster_C.mat');
    load('data\DIGITS.mat');
    pic_size = 28;      % 降维前，特征维数是28*28
elseif datatoload == 2
    load('data\cluster_C_dedimen.mat');
    load('data\DIGITS_dedimen.mat');
    DIGITS = DIGITS_dedimen;
    pic_size = 8;       % 降维后的特征维数,特征维数是28*28
else
    error('Error! datatoload should be either 1 or 2.');
end
chara_dimen = pic_size*pic_size;
%% 识别/测试
% 和性别识别实验的不同之处在于：
% 性别识别是二分类问题，特征有20个；这是个10分类问题，且特征有784个.

% 把kmeans聚类后的中心点集中到一个数组中
% 每次赋值k行，即整类数字赋值
k=10;
centers = zeros(10*k,chara_dimen+1);
for i=1:10
    centers((i-1)*k+1:i*k,1:chara_dimen) = cluster_C{i,1};
    centers((i-1)*k+1:i*k,chara_dimen+1) = i;
end

%-------- 下面是中间效果展示，实际应用时可注释，datatoload=2 时无意义 --------%
% fprintf('下图显示的是%d个聚类中心的图像.\n',10*k);
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
% fprintf('聚类中心图像显示完毕.\n');
%---------- -------------------------------------------------------------%

%% KNN识别/分类
dists = zeros(10*k,2);
for i=1:10
    dists((i-1)*k+1:i*k,2) = zeros(k,1)+i*ones(k,1);
end
RESULTS_num = zeros(10,10);
probnum = zeros(10,1);
K = 1;
% 对每一种数字(共0-9计十个数字)
for category=1:10
    % 每一种数字的测试样本数量
    for i=1:size(DIGITS{category,1}.Data_test,1)    
        % 将每条测试样本拓展成100行,方便计算和比较与聚类中心的距离
        temp = repmat(DIGITS{category,1}.Data_test(i,:),10*k,1);
        dists(:,1) = sum((temp-centers(:,1:chara_dimen)).^2,2);
        [B,ind] = sort(dists(:,1));
        ind = ind(1:K,1);
        % 判断最近的k个中心是哪个数字的中心
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
        probnum = zeros(10,1);          % 千万不养忘了让 probnum 归零！！！
    end
    fprintf('数字%d的测试集已测试完成.\n',category);
end

%% 由概数计算识别概率
% 0-9各自的概率
RESULTS_prob = zeros(10,10);
for raw=1:10
    if sum(RESULTS_num(raw,:))~=size(DIGITS{raw,1}.Data_test,1)
        fprintf('数字%d测试有误.\n',category);
        break;
    else
        for col = 1:10
            RESULTS_prob(raw,col) = RESULTS_num(raw,col)/sum(RESULTS_num(raw,:));
        end
    end
end
% 总的概率
total_num = 0;
for s=1:10
    total_num = total_num+RESULTS_num(s,s);
end
total_prob = total_num/sum(sum(RESULTS_num));
toc

%% 删除路径
rmpath('functions/');

%%