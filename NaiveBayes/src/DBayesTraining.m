% DBayesTraining: Convert picture to matrix as discrete data, so called
% 'Training' process in machine learning.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;

% 参数设定
train_num = 50;
lPiece = 7;         % 每小片有 lPiece^2 个像素点
nPiece = 4;        % 每张图片有 nPiece^2 个小片
nthres = 12;

% 为结构体数组预分配内存 (训练集<=5000)
Pattern = repmat(struct('digital',0,'num',train_num,'feature',...
    zeros(nPiece^2,train_num)),10,1);
for i=1:10
    Pattern(i).digital = i-1;
end

% 创建元胞数组，每个元素就是一个结构体，注意正确使用()和{}
img_list = cell(10,1);
prefix=('train-images\');
for i=1:10
    img_list{i}=dir([prefix,'train',num2str(i-1),'_*.png']);
end

% 对于0-9共10个数字
for A1=1:10
    % 每个数字有多少个样本
    len = length(img_list{A1,1});
    % 确定样本训练（学习）样本数目
    for A2=1:min(len,train_num)
        img_name = img_list{A1,1}(A2).name;
        im = imread([prefix,img_name]);
%         figure;imshow(im);
        % 例如：拆分成7*7=49个小块(Piece)，每个小块有4*4=16个元素
        Piece = 1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp = im(A3:A3+lPiece-1,A4:A4+lPiece-1);
                % 例如：只要16个中有超过3个是白色,就标记为1(255*4=1020)
                if sum(sum(temp))>= 255*nthres
                    Pattern(A1).feature(Piece,A2) = 1;
                end
                Piece = Piece+1;
            end
        end
    end
    fprintf('Calss %1d:%5d images are written to mat.\n',A1-1,train_num);
end
% ---------至此，结构体数组Pattern写入完毕，即数据集模板已建立-------------

% 将Pattern的数值存储在当前目录的数据包 Pattern2000.mat 下
% 注意：它的名字还是Pattern
preaddr = 'models\';
save([preaddr,'Patternlabanother.mat'],'Pattern');
