% ���ܣ����ļ�t10k-images-idx3-ubyte��t10k-labels-idx1-ubyte��
% train-images-idx3-ubyte��train-labels-idx1-ubyte�е�����ת���.mat���ݰ�

close all;clear;clc;

image_train_file = 'rawdatra\train-images-idx3-ubyte';
label_train_file = 'rawdatra\train-labels-idx1-ubyte';
image_test_file = 'rawdatra\t10k-images-idx3-ubyte';
label_test_file = 'rawdatra\t10k-labels-idx1-ubyte';

tr1=fopen(image_train_file,'rb');       % 'rb':�Զ����ƶ���
assert(tr1 >= 3, '�ļ� %s ��ʧ��',image_train_file);
tr2=fopen(label_train_file,'rb');
assert(tr2 >= 3, '�ļ� %s ��ʧ��',label_train_file);
te1=fopen(image_test_file,'rb');
assert(te1 >= 3, '�ļ� %s ��ʧ��',image_test_file);
te2=fopen(label_test_file,'rb');
assert(te2 >= 3, '�ļ� %s ��ʧ��',label_test_file);

% �������� label ���ݻ�ͼ��������Ϣ��ʼ֮ǰ����һЩ��ͷ��Ϣ��
% ���� label �ļ��� 2 �� 32λ���ͣ����� image �ļ��� 4 �� 32λ���ͣ�
% ����������Ҫ���������ļ��ֱ��ƶ��ļ�ָ�룬��ָ����ȷ��λ�á�
p1 = fread(tr1,4,'int32');
p2 = fread(tr2,2,'int32');
p3 = fread(te1,4,'int32');
p4 = fread(te2,2,'int32');

% ���ȴ�����Щ .ascii �ļ�
% 'w':д�룬�ļ��������ڣ��Զ�����
% fids���ļ��������,ǰ10��Ϊѵ�����������10��Ϊ���Լ����
fids = zeros(1,20);
for i=0:9
    fids(i+1) = fopen(['train',num2str(i),'.ascii'],'w');  
    fids(i+11) = fopen(['test',num2str(i),'.ascii'],'w');  
end

% ��Ϊ�ļ����ݱȽϴ󣬳����ڴ�Ŀ��ǣ���ò�Ҫһ��ȫ�������ڴ棬
% ����������ض�ȡ������һ�ζ� 1000 ��ͼ����Ϣ
% ѵ����train-60,000�������Լ�test-10,000��
n = 1000;
times_train = 60;         % 60*1000 = 60,000
times_test = 10;          % 10*1000 = 10,000

% ---------------------------- ѵ���� ----------------------------
% �� 60 �ζ�ȡ��ÿ�ζ�ȡ 1000 ��ͼ�񣬶�ÿ��ͼ���� 28*28 ���ص�
for i = 1:times_train
    rawimages = fread(tr1, [28*28,n], 'uchar');
    rawlabels = fread(tr2, n, 'uchar');
    % ��ÿ�ζ�ȡ�� 1000 ��ͼ�����
    for j = 1:n
        % д��ͼ������, '%3d'��3λʮ�����з�������
        fprintf(fids(rawlabels(j)+1),'%4d',rawimages(:,j)); 
        fprintf(fids(rawlabels(j)+1),'\n');        % ����
    end
end
% ����ٽ� .ascii ��ʽ�ļ�����Ϊ .mat �ļ�
for i = 0:9
    % load(filename,'-ascii') treats filename as an ASCII file, 
    % regardless of the file extension.
    Data_train = load(['train' num2str(i) '.ascii'], '-ascii');
    fprintf('DATA OF Train:%5d digits of class %1d HAS BEEN EXTRACTED TO .MAT FILE\n', size(Data_train, 1), i);
    save(['matdata\train' num2str(i) '.mat'], 'Data_train', '-mat');
    fclose(fids(i+1));
end

% ---------------------------- ���Լ� ----------------------------
% �� 10 �ζ�ȡ��ÿ�ζ�ȡ 1000 ��ͼ�񣬶�ÿ��ͼ���� 28*28 ���ص�
for i = 1:times_test
    rawimages = fread(te1, [28*28,n], 'uchar');
    rawlabels = fread(te2, n, 'uchar');
    % ��ÿ�ζ�ȡ�� 1000 ��ͼ�����
    for j = 1:n
        % д��ͼ������, '%3d'��3λʮ�����з�������
        fprintf(fids(rawlabels(j)+11),'%4d',rawimages(:,j));
        fprintf(fids(rawlabels(j)+11),'\n');        % ����
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

% ������ɾ�� .ascii ��ʽ�ļ�
dos('del *.ascii');         % Windows ƽ̨��dos ����