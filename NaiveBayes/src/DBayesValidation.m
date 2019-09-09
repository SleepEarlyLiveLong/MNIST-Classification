% DBayesValidation: This file is to view the probability of each bit of image-vector
%            as discrete where p=0 or p=1.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
close all;clear;clc;
load('models\Patternlabanother.mat');

% 参数设定
lPiece = 7;        % 每小片有16个像素点
nPiece = 4;        % 每张图片有49小片
nthres = 12;

prefix = ('test-images\');
% 创建元胞数组，元素是测试集的0-9的文件路径
img_list = cell(10,1);
for A1=1:10
    img_list{A1} = dir([prefix,'test',num2str(A1-1),'_*.png']);
end

% 用贝叶斯分类器判断
% 先得到一组概率表（二维数组），即0-9每一个数字的每一位取值为1的概率
probtable = zeros(nPiece^2,10);
for col=1:10
    for raw=1:nPiece^2
        probtable(raw,col) = sum(Pattern(col).feature(raw,:))/length(Pattern(1).feature);
    end
end

%% 
% 创建元胞数组，存放训练集数据
% 实际上的核心就是 im=imread(xxx);只是需要读到合适的位置
% 然后依次进行：分片(帧)—分别计算后验概率—概率最大的即识别结果—
%               对比label判断识别正确与否—计算识别正确率

% 对于每一个数字
correct_num_all = 0;
for A1=1:10
    % 每个数字的测试样本数
    len = length(img_list{A1});
    % 对0-9每一个数字设置一个正确判断量
    correct_num = 0;
    % 对于一个数字的每一个测试样本
    for A2=1:len
        img_name=img_list{A1}(A2).name;
        im=imread([prefix,img_name]);
%         figure;imshow(im);
        % 对每一个im分割处理
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
        % 至此，得到了一个测试样本的特征序列fe，接下来识别该样本
        % 用 Bayes 分类器的方法
        % 计算10个条件概率，即P(X|wi),i=0,1,...,9
        % 而 P(X|wi)=∏(k=1,49)P(xk|wi)
        % 可以理解为下面的 P(A2|A1)
        cond_prob = ones(10,1);
        % 对于10个数字
        for A5=1:10
            % 对于待确定数字的每一位
            for A6=1:nPiece^2
                if fe(A6)==1
                    cond_prob(A5)=cond_prob(A5)*probtable(A6,A5);
                else
                    cond_prob(A5)=cond_prob(A5)*(1-probtable(A6,A5));
                end
            end
        end
        % 取概率最大的
        [~,I]=max(cond_prob);
        % 数字 I-1 就是识别结果，需要和真实数字 A1-1 进行对比
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