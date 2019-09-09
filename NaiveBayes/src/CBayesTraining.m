% CBayesTraining: Convert picture to matrix as continuous data, so called
% 'Training' process in machine learning.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;

% 参数设定
lPiece = 7;         % 每小片有 lPiece^2 个像素点
nPiece = 4;        % 每张图片有 nPiece^2 个小片

% 创建元胞数组，每个元素就是一个结构体，注意正确使用()和{}
img_list = cell(10,1);
prefix=('train-images-smaller\');
for i=1:10
    img_list{i}=dir([prefix,'train',num2str(i-1),'_*.png']);
end

% 训练集0-9每个数字的个数存在数组testlen_vec中
testlen_vec = zeros(10,1);
for i=1:10
    testlen_vec(i) = length(img_list{i});
end

% 为结构体数组预分配内存 (训练集)
CPattern = repmat(struct('digital',0,'num',0,'feature',...
    zeros(nPiece^2,max(testlen_vec)),...
    'feature_prob',zeros(nPiece^2,lPiece^2+1),'mean',zeros(nPiece^2,1),...
    'var',zeros(nPiece^2,1),'prob',0),10,1);
for i=1:10
    CPattern(i).digital = i-1;
    CPattern(i).num = testlen_vec(i);
    CPattern(i).feature = zeros(nPiece^2,testlen_vec(i));
end

% 对于0-9共10个数字
for A1=1:10
    % 每个数字有多少个样本
    len = length(img_list{A1,1});
    % 确定样本训练（学习）样本数目
    for A2=1:len
        img_name = img_list{A1,1}(A2).name;
        % 注意！这里转变成double是为了减小数据，0-1比0-255小多了
        % 转 bw 是为了确保使用 lPiece^2 分法 
        im = imbinarize(im2double(imread([prefix,img_name])));
%         figure;imshow(im);
        % 例如：拆分成7*7=49个小块(Piece)，每个小块有4*4=16个元素
        Piece = 1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp = im(A3:A3+lPiece-1,A4:A4+lPiece-1);
                % 例如：不用标记，直接将数值赋给特征向量
                CPattern(A1).feature(Piece,A2) = sum(sum(temp));
                Piece = Piece+1;
            end
        end
    end
    
    % 现在是为了得到特征向量每一维的取值是0,1,...,17的概率
    % 每一行，如 7x7=49 行
    for A2=1:nPiece^2
        % 每一列，训练样本数
        for A3=1:testlen_vec(A1)
            % account 是帧(如 4x4 大小)内白色像素点个数，取值范围是0,1,...,17
            account = CPattern(A1).feature(A2,A3);
            CPattern(A1).feature_prob(A2,account+1)=CPattern(A1).feature_prob(A2,account+1)+1;
        end
        % 分子分母各+1 是为了避免0概率
        CPattern(A1).feature_prob(A2,:)=(CPattern(A1).feature_prob(A2,:)+1)/(testlen_vec(A1)+1);
    end
        
    % 现在是为了得到特征向量每一维的取值的均值和方差，虽然我认为这没什么用
    for A2=1:nPiece^2
        CPattern(A1).mean(A2,1) = mean(CPattern(A1).feature(A2,:));
        CPattern(A1).var(A2,1) = var(CPattern(A1).feature(A2,:));
    end
    CPattern(A1).prob = testlen_vec(A1)/sum(testlen_vec);
    fprintf('Calss %1d:%5d images are written to mat.\n',A1-1,testlen_vec(A1));
end
% ---------至此，结构体数组Pattern写入完毕，即数据集模板已建立-------------

% 将Pattern的数值存储在当前目录的数据包 Pattern2000.mat 下
% 注意：它的名字还是Pattern
preaddr = 'models\';
save([preaddr,'CPatternsmaller.mat'],'CPattern');
