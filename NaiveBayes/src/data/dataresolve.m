% 功能：将文件t10k-images-idx3-ubyte、t10k-labels-idx1-ubyte、
% train-images-idx3-ubyte、train-labels-idx1-ubyte中的数据转存成.mat数据包

close all;clear;clc;

image_train_file = 'rawdatra\train-images-idx3-ubyte';
label_train_file = 'rawdatra\train-labels-idx1-ubyte';
image_test_file = 'rawdatra\t10k-images-idx3-ubyte';
label_test_file = 'rawdatra\t10k-labels-idx1-ubyte';

tr1=fopen(image_train_file,'rb');       % 'rb':以二进制读出
assert(tr1 >= 3, '文件 %s 打开失败',image_train_file);
tr2=fopen(label_train_file,'rb');
assert(tr2 >= 3, '文件 %s 打开失败',label_train_file);
te1=fopen(image_test_file,'rb');
assert(te1 >= 3, '文件 %s 打开失败',image_test_file);
te2=fopen(label_test_file,'rb');
assert(te2 >= 3, '文件 %s 打开失败',label_test_file);

% 在真正的 label 数据或图像像素信息开始之前会有一些表头信息，
% 对于 label 文件是 2 个 32位整型，对于 image 文件是 4 个 32位整型，
% 所以我们需要对这两个文件分别移动文件指针，以指向正确的位置。
p1 = fread(tr1,4,'int32');
p2 = fread(tr2,2,'int32');
p3 = fread(te1,4,'int32');
p4 = fread(te2,2,'int32');

% 首先创建这些 .ascii 文件
% 'w':写入，文件若不存在，自动创建
% fids：文件句柄数组,前10个为训练集句柄，后10个为测试集句柄
fids = zeros(1,20);
for i=0:9
    fids(i+1) = fopen(['train',num2str(i),'.ascii'],'w');  
    fids(i+11) = fopen(['test',num2str(i),'.ascii'],'w');  
end

% 因为文件内容比较大，出于内存的考虑，最好不要一次全部读入内存，
% 而是逐块逐块地读取，比如一次读 1000 个图像信息
% 训练集train-60,000个，测试集test-10,000个
n = 1000;
times_train = 60;         % 60*1000 = 60,000
times_test = 10;          % 10*1000 = 10,000

% ---------------------------- 训练集 ----------------------------
% 分 60 次读取，每次读取 1000 个图像，而每个图像是 28*28 像素的
for i = 1:times_train
    rawimages = fread(tr1, [28*28,n], 'uchar');
    rawlabels = fread(tr2, n, 'uchar');
    % 在每次读取的 1000 个图像块中
    for j = 1:n
        % 写入图像数据, '%3d'：3位十进制有符号整数
        fprintf(fids(rawlabels(j)+1),'%4d',rawimages(:,j)); 
        fprintf(fids(rawlabels(j)+1),'\n');        % 换行
    end
end
% 最后再将 .ascii 格式文件保存为 .mat 文件
for i = 0:9
    % load(filename,'-ascii') treats filename as an ASCII file, 
    % regardless of the file extension.
    Data_train = load(['train' num2str(i) '.ascii'], '-ascii');
    fprintf('DATA OF Train:%5d digits of class %1d HAS BEEN EXTRACTED TO .MAT FILE\n', size(Data_train, 1), i);
    save(['matdata\train' num2str(i) '.mat'], 'Data_train', '-mat');
    fclose(fids(i+1));
end

% ---------------------------- 测试集 ----------------------------
% 分 10 次读取，每次读取 1000 个图像，而每个图像是 28*28 像素的
for i = 1:times_test
    rawimages = fread(te1, [28*28,n], 'uchar');
    rawlabels = fread(te2, n, 'uchar');
    % 在每次读取的 1000 个图像块中
    for j = 1:n
        % 写入图像数据, '%3d'：3位十进制有符号整数
        fprintf(fids(rawlabels(j)+11),'%4d',rawimages(:,j));
        fprintf(fids(rawlabels(j)+11),'\n');        % 换行
    end
end
for i = 0:9
    % load(filename,'-ascii') treats filename as an ASCII file, 
    % regardless of the file extension.
    Data_test = load(['test' num2str(i) '.ascii'], '-ascii');
    fprintf('DATA OF Test:%5d digits of class %1d HAS BEEN EXTRACTED TO .MAT FILE\n', size(Data_test, 1), i);
    save(['matdata\test' num2str(i) '.mat'], 'Data_test', '-mat');
    fclose(fids(i+11));
end

% 别忘了删除 .ascii 格式文件
dos('del *.ascii');         % Windows 平台下dos 命令