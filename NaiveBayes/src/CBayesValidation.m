% CBayesValidation: This file is to view the probability of each bit of image-vector
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

prefix = ('test-images\');
% 创建元胞数组，元素是测试集的0-9的文件路径
% 读取验证集
img_list = cell(10,1);
for A1=1:10
    img_list{A1} = dir([prefix,'test',num2str(A1-1),'_*.png']);
end

% 此处无法得到概率表，因为我们已经假设每一个数字的特征向量的每一维数据的值
% 都符合高斯分布，所以只能根据 CPattern.mat 中给出的每一个数字的特
% 征向量的每一维数据取值的均值和方差，从而计算其概率。
% (实际上没有按照这段话的想法操作)

% 创建元胞数组，存放验证集数据
% 实际上的核心就是 im=imread(xxx);只是需要读到合适的位置
% 然后依次进行：分片(帧)—分别计算后验概率—概率最大的即识别结果—
%               对比label判断识别正确与否—计算识别正确率

% 对于每一类数字(0-9)
correct_num_all = 0;
for A1=1:10
    % 每个数字的每一个测试样本数
    len = length(img_list{A1});
    % 对0-9每一个数字设置一个正确判断量
    correct_num = 0;
    % 对于一个数字的每一个测试样本
    for A2=1:len
        img_name=img_list{A1}(A2).name;
        im=imbinarize(im2double(imread([prefix,img_name])));
%         figure;imshow(im);
        % 对每一个im分割处理
        fe = zeros(nPiece^2,1);
        piece=1;
        for A3=1:lPiece:29-lPiece
            for A4=1:lPiece:29-lPiece
                temp=im(A3:A3+lPiece-1,A4:A4+lPiece-1);
%                 % 原想再次量化，后发现大量概率连乘其实可行，就没再这样做
%                 s = sum(sum(temp));
%                 if s>=0 &&  s<= 3
%                     fe(piece)=1;
%                 elseif s>=4 &&  s<= 7
%                     fe(piece)=2;
%                 elseif s>=8 &&  s<= 11
%                     fe(piece)=3;
%                 elseif s>=12 &&  s<= 16
%                     fe(piece)=4;
%                 end
                fe(piece)=sum(sum(temp));
                piece = piece+1;
            end
        end
        
        % 至此，得到了一个测试样本的特征序列fe，接下来识别该样本
        % 用 Bayes 分类器的方法
        % 计算10个条件概率，即P(X|wi),i=0,1,...,9
        % 而 P(X|wi)=∏(k=1,49)P(xk|wi)
        % 可以理解为下面的 P(A2|A1)
        
        %     而连续的和离散的不同之处就在于，测试样本的特征向量的每一维
        %     的取值不是只可以取0/1，因此概率也不可以直接查表得出，需要
        %     临时由概率的高斯分布模型计算求得。
        
        %     经过实验，上述有关连续概率的设想不成立，仍然需要视作离散
        %     但是改二分法(0/1)为多分(0,1,...,lPiece^2+1)法
       
        % 条件概率
        cond_prob = 2*ones(10,1);
        % 后验概率
        post_prob = zeros(10,1);
        % 对于10个数字
        for A5=1:10
            % 对于待确定数字的每一位 1:49
            for A6=1:nPiece^2
                % 原本是连乘，改为对数连加，由于概率小于1，所以最好的情况
                % 是不减小。概率越小，减去的数字越多。
                % 而带入下来一轮中时，定义域为负将导致计算错误。
                % 针对此问题，进行了改进。cond_prob = 2*ones(10,1);是为了
                % 确保概率都大于1，处于单调增的阶段，且一轮轮一直大于1
                % 又经过了整整一天，最终发现了问题：
                % a.连加不能解决问题。
                % b.！！原来问题出在下标上！！下式第三个下标应当是A5，
                %   但是我之前写的都是A1，错！乘以sqrt(10)是为了避免数据过小
                cond_prob(A5)=cond_prob(A5)*CPattern(A5).feature_prob(A6,fe(A6)+1)*sqrt(2);
            end
            % 后验概率
            post_prob(A5) = cond_prob(A5)*CPattern(A5).prob;
        end
        % 取概率最大的
        [~,I]=max(post_prob);
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

% 经过仔细思考，我认为，在这里，对0-9这10个数字的特征向量(不妨假设为49维)的
% 每一维的取值(实际上就是向量各元素的取值)概率作连续分析——即认为它们的取
% 值是在一段区间内连续的——是不切实际的。一方面，识别对象即使不是BW图，
% 其取值绝大多数仍非黑即白(0/1)，故我们可以把他们当做BW图。或者，建议干脆
% 直接将其转换为BW图。所以实际上特征向量各点处的取值是取0,1,...,15,还是
% 16的问题(至于为什么是16，是因为前已假设帧尺寸为 4x4 Pixel)。这样看来，
% 即使特征向量各维的取值不是“非0即1”，那也是只能是0-16这17个数中的一个。
% 区区17个整数，恐怕不能认为它们可以近似模拟连续取值的情况吧？如果说，要是
% 大一点呢？如果帧尺寸放大，例如增大为 7x7，那么考虑到总尺寸一定，帧数就
% 变成了4x4，特征向量的维数即为16，这样可不可以呢？
% 如果仍然是之前那种处理方式，这显然是不可接受的，因为帧数过少，对识别对象
% 的考察过于粗糙，可以预料极差的效果。如果按照上文的改进方法，那么特征向量
% 每一维的取值就是0-49之间的整数，仍认为是离散分部，计算各自的概率。
% 问题来了，无论帧尺寸是 4x4 还是 7x7，若要仔细考虑帧内每个像素点，那么分帧
% 的意义何在？为什么不干脆直接在第一种方法中将帧尺寸直接设为 1x1？这样一来，
% 既然大家都考虑到每个像素点了，那么分帧和不分帧的区别在哪？
% 一言以蔽之，就是这个问题：83%的识别率是不是Bayes分类器对此问题的处理极限？

% 还有一个我不知道是不是关键的问题：近似 BW 和确实是 BW 有无较大影响。

% 巨大的问题：49个小数连乘，最后的结果极小，约为e-27，超出了 double 的范围，
% 而且比eps(e-16)还小，因此不得不变为对数运算，乘转加。而对数运算定义域
% 又不得为0，因此 0概率 的情况需要一很小的数去近似。为了避免出现极端值，将
% 概率分子分母同时加1以近似。预计最小概率对应 log2(1/6000)=-12.5507。但是
% 又要考虑分辨率的问题，所以底数不能太大，先设为1.01试一试。

% 不行，一直会滑向-lnf

% 改回来，仍然是概率连乘，但是每次都sqrt(10)补偿

% 进一步改进，对于帧尺寸小的，需要连乘的概率数量较多，补偿值可酌情增减

toc

%%