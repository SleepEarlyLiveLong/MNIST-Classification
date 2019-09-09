function centers = mycluster_plus(X,k)
%MYCLUSTER_PLUS - K-means clustering initialization: kmeans++.
%   To initialize the cluster centers using kmeans++.
%   
%   centers = mycluster_plus(X,k)
% 
%   Input - 
%   X: the input N*P matrix X with N points of P-dimension;
%   k: the number of cluster centers;
%   Output - 
%   centers: the initialized cluster centers.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
if ~ismatrix(X) || ~isreal(k)
    error('Input parameter error! ');
end
[m,~] = size(X);
if k>m
    error('Error! Too many clustering classes.');
end
% specify the first center
C = [];
% choose the first point randomly
idx = mod(round(rand()*m),m)+1;
C = cat(1,C,X(idx,:));          % �������� X(idx,:) ƴ����B�����·�
X(idx,:) = [];                  % ��X��ɾ�� ������ X(idx,:)
%% 
while ~isempty(X)               %ѭ������ֱ��XΪ��
    % ����X��ʣ��㵽B�����е�ľ����
    m = size(X,1);
    bn = size(C,1);
    dists = zeros(m,1);
    for i=1:m
        Point = X(i,:); %ȡ����i����
        Mat = repmat(Point,bn,1); %��չΪbn�У�����������
        diff = Mat-C;
        dist = sqrt(sum(diff.^2,2)); %�ص�2ά��ƽ���ͣ��ٿ����ţ�dist����ΪPoint��B���еľ���
        dists(i) = sum(dist); %��Point��B�����е�ľ���֮��
    end
    [~,idx] = max(dists);       %�����ֵ
    C = cat(1,C,X(idx,:));      %����B��
    X(idx,:) = [];              %��X��ɾ��
end
centers = C(1:k,:);

end
%%