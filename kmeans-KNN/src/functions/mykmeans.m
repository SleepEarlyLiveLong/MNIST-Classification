function varargout = mykmeans(X,k,varargin)
%MYKMEANS - K-means clustering.
%   To divide the input data into k classes using the k-means algorithm.
%   
%   Idx = mykmeans(X,k)
%   Idx = mykmeans(X,k,DIM)
%   Idx = mykmeans(X,k,DIM,errdlt)
%   Idx = mykmeans(X,k,DIM,errdlt,replicates)
%   Idx = mykmeans(X,k,DIM,errdlt,replicates,Cin)
%   [Idx,C,sumD,D,Errlist] = mykmeans(...)
%   [...] = mykmeans(...,'Param1','Param2'...)  
% 
%   Input - 
%   X:          the input N*P matrix X with N points of P-dimension;
%   k:          the number of classes;
%   DIM:        1-the number of rows represents the number of points;
%               2-the number of columns represents the number of points;
%   errdlt:     the error between the last cluster and current cluster
%               that stops clustering;
%   replicates: the number of repeated clusters;
%   Cin:        the number of repeated clusters;
%   Param1:     distance
%   Val1:       sqEuclidean:    ŷ�Ͼ��� Euclidean distance
%               cityblock:      �����پ��� Manhattan Distance
%               cosine:         ���Ҿ���-������� Cosine distance
%               correlation:    ��ؾ��� Correlation distance
%               Hamming:        ��������-����ַ�����������(����) Hamming distance
%   Param2:     start
%   Val2:       sample:         ���ѡȡ Random selection
%               plus  :         ������Զѡȡ kmeans++ method
%               canopy:         (û��ʵ��-�������Ϊ������ֵ�ʲ��ʺ�)
%               matrix:         ֱ������ Direct input
%   Output - 
%   Idx:        a N*1 vector containing the cluster number of each point;
%   C:          a k*P matrix containing the coordinate of k cluster centers;
%   sumD:       a k*1 vector containing the sum of distances between every cluster
%               center and its within-cluster points;
%   D:          a N*k vector containing the distance between each point and each
%               cluster center;
%   Errlist:    a vector containing the clusting error after each round.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% ���Ƚ��к����ĳ�ʼ������
% ������Ŀ���
narginchk(2,8);
nargoutchk(1,5);

if ~ismatrix(X) || k<=0
    error('Input error!');
end
[N,P] = size(X);
if k>N
    error('Error! The unmber of classes must not be larger than the number of points.');
end

% ��ʼ���������ģ�Ĭ�����
start = 'sample';
startset = {'sample','plus','canopy','cluster','matrix'};
if (nargin > 2 && ischar(varargin{end})) && any(strcmpi(varargin{end},startset))
    start = varargin{end};
    varargin(end)=[];
end

% �����ȣ�Ĭ��ŷ�Ͼ���
distance = 'sqEuclidean';
startset = {'sqEuclidean','cityblock','cosine','correlation','Hamming'};
if (nargin > 2 && ischar(varargin{end})) && any(strcmpi(varargin{end},startset))
    distance = varargin{end};
    varargin(end)=[];
end

% ��ȡʣ�����������Ŀ
narg = numel(varargin);
DIM = [];
errdlt = [];
replicates = [];
Cin = [];
% DIM,errdlt,replicates,Cin
switch narg
    case 0
    case 1
        DIM = varargin{:};
    case 2
        [DIM,errdlt] = varargin{:};
    case 3
        [DIM,errdlt,replicates] = varargin{:};
    case 4
        [DIM,errdlt,replicates,Cin] = varargin{:};
    otherwise
        error('Input parameter error!');
end

% ����������������
% ����û�û�ᵽ���Ǿ�Ĭ������Ϊ����������Ϊά����
if isempty(DIM)
    DIM = 1;
elseif DIM~=1 && DIM~=2
    error('Error! The parameter "DIM" should be specified correctly.');
end
% ����������Ϊ����Ϊ�����������ݸ�Ϊ����Ϊ����������Ϊά����
if DIM==2
     X = X';
end

%--- errdlt �� replicates ���ǿ���clusterѭ����������,���ȿ���replicates
% ��ʼ�������������
% ����û�û�ᵽ���Ǿ�Ĭ��������
if isempty(replicates)
    limit_exist = 0;
elseif (replicates<=0) || (fix(replicates)~=replicates)
    error('Error! The operational limit must be a positive integer when specified.');
else
    limit_exist = 1;
end

% ��ʼ�� errdlt-��С����,��ֹͣ����ѭ�������
% ����û�û�ᵽ�����ȿ� replicates����ȷ�� errdlt
if isempty(errdlt)
    if limit_exist==0           % �������ѭ��������������С����
        errdlt = 1;
        errdlt_exist = 0;
    else
        errdlt_exist = 1;
    end
end

% ��ʼ����ʼ��������
% ����û�û�ᵽ������ʼ����ʽ
if isempty(Cin)
    if strcmpi(start,'matrix')
        errror('Error! A matrix must be put when "start" is chosen as "matrix".');
    end
else
    if ~strcmpi(start,'matrix')
        warning('Warning! A matrix is not required when "start" is not chosen as "matrix".');
    else
        if size(Cin,1)>N || size(Cin,2)~=P
            error('Error! The size of the initial clustering matrix is not correct.');
        end
    end
end

%% ȷ����ʼ������-��ʼ����
if strcmpi(start,'matrix')
    % ʹ���ض���K����
    C = Cin;
elseif strcmpi(start,'sample')
    % ���ѡ��K����-default
    Idx = randperm(N);
    Idx = Idx(1:k);
    C = X(Idx,:);
elseif strcmpi(start,'plus')
    % ѡ��˴˾��뾡����Զ��K����
    C = mycluster_plus(X,k);
elseif strcmpi(start,'canopy')
    % canopy�㷨��ʼ��
    error('Error! Change another method.');        % emmm ���������ʱû����
end

%% ȷ����ʼ���࣬�����ʼ���
% ��X�������1�У���һ�γ�����ֻ��������1��
if size(X,2)==P
    X = [X,zeros(N,1)];
else
    error('Error! X alreadly has %d columns.',P);
end
% ȷ����ʼ����
for i=1:N
    temp = repmat(X(i,1:P),k,1);            % ��չ��k�з������
    dists = mydist(distance,temp,C);
    [~,X(i,P+1)] = min(dists);            % ȡ������С��,dists:k*1
end
% ���ʼ���
err_init = myerrcal(distance,X,C);
fprintf('��ʼ�������Ϊ%d.\n',err_init);

%% ����"����-����-�����"ѭ��
err = err_init;
T=1;
if limit_exist==0
    while(1)
        % ��֪������������C-��������
        C = zeros(k,P);
        n = zeros(k,1);
        for i=1:N
            g_num = X(i,P+1);
            C(g_num,:)=( C(g_num,:)*n(g_num)+X(i,1:P) ) / (n(g_num)+1);
            n(g_num) = n(g_num)+1;
        end
        % ��֪����ȷ������
        for i=1:N
            % ��չ��k�з������
            temp = repmat(X(i,1:P),k,1);          
            % ������
            dists = mydist(distance,temp,C);
            % ȡ������С��
            [~,X(i,P+1)] = min(dists);            
        end
        
        % ȷ�������������
        err_temp = myerrcal(distance,X,C);
        fprintf('��%d�־������Ϊ%d.\n',T,err_temp);
        T=T+1;
        
        % ����ͼ��-�����ڵ��ԣ�ʵ��ʹ��ʱΪ�����ٶȼ�Ӧע��
        mydrawkmeans(X,C);
        % ����б�����һ��
        err = [err;err_temp];
        % �����˳�����
        if ( abs(err(end-1)-err(end))<errdlt )
            fprintf('������ɣ�һ��������%d��.\n',T-1);
            break;
        end
        % ��ͣ-�����ڵ��ԣ�ʵ��ʹ��ʱӦע��
%         pause;
    end
else    % limit_exist==1
    isfinish = 0;
    while(T~=replicates && isfinish==0)
        % ��֪������������C-��������
        C = zeros(k,P);
        n = zeros(k,1);
        for i=1:N
            g_num = X(i,P+1);
            C(g_num,:)=( C(g_num,:)*n(g_num)+X(i,1:P) ) / (n(g_num)+1);
            n(g_num) = n(g_num)+1;
        end
        % ��֪����ȷ������
        for i=1:N
            % ��չ��k�з������
            temp = repmat(X(i,1:P),k,1);          
            % ������
            dists = mydist(distance,temp,C);
            % ȡ������С��
            [~,X(i,P+1)] = min(dists);            
        end
        
        % ȷ����������
        err_temp = myerrcal(distance,X,C);
        fprintf('��%d�־������Ϊ%d.\n',T,err_temp);
        T=T+1;
        
        % ����ͼ��-�����ڵ��ԣ�ʵ��ʹ��ʱΪ�����ٶȼ�Ӧע��
        mydrawkmeans(X,C);
        % ����б�����һ��
        err = [err;err_temp];
        % ��ͬʱ��errdlt-��С����,Ҳ��Ҫ�����˳�����;
        while(errdlt_exist)
            if ( abs(err(end-1)-err(end))<errdlt )
                fprintf('������ɣ�һ��������%d��.\n',T-1);
                isfinish = 1;       % ֻҪ���仯��С����ֵ��������������ֱ�ӽ���
            end
        end
        % ��ʹͬʱû������errdlt-��С����,�����Ϊ0ʱҲ�˳�;
        if ( abs(err(end-1)-err(end))==0 )
            fprintf('������ɣ�һ��������%d��.\n',T-1);
            isfinish = 1;           % ֻҪ���仯������0��������������ֱ�ӽ���
        end
        % ��ͣ-�����ڵ��ԣ�ʵ��ʹ��ʱӦע��
%         pause;
    end
end

%% �����������
% ÿ�������
Idx = X(:,P+1);
% ����ÿ���㵽�������ĵ�ľ���
D = zeros(N,k);
for i=1:N
    for j=1:k
        D(i,j) = sqrt(sum( (X(i,1:P)-C(j,:)).^2 ));
    end
end
% ����ÿ����Χ�ڵ����(����)��
sumD = zeros(k,1);
for i=1:N
    sumD(X(i,P+1),1) = sumD(X(i,P+1),1)+sqrt(sum( (X(i,1:P)-C(X(i,P+1),:)).^2 ));
end
% ����б�
Errlist = err;

%% ���
switch(nargout)
    case 1
        varargout = {Idx};
    case 2
        varargout = {Idx,C};
    case 3
        varargout = {Idx,C,sumD};
    case 4
        varargout = {Idx,C,sumD,D};
    case 5
        varargout = {Idx,C,sumD,D,Errlist};
end

end
%% 