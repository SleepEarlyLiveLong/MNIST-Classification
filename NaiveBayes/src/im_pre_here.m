function im_out = im_pre_here(img_in,varargin)
%IM_PRE_HERE - To do some pre-processes for the input images.
%   
%   im_out = im_pre_here(img_in)
%   im_out = im_pre_here(img_in,mode)
% 
%   Input - 
%   img_in: input image;
%   mode: process mode for the image.
%   Output - 
%   im_out: image after process.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
% parameter check
narginchk(1,2);
nargoutchk(1,1);

% choose mode: gray or bw(default:gray)
mode = 'gray';
if (nargin > 1 && ischar(varargin{end})) && any(strcmpi(varargin{end},{'gray','bw'}))
    mode = varargin{end};
    varargin(end)=[];
end
    
% number of the left parameters
narg = numel(varargin);
if narg~=0
    error('Paremeter input error!');
end

%% 
if ~ischar(mode)
    error('Error! The second parameter must be a string.');
end

tpc_row = 28;
tpc_col = 28;
[row,col,c] = size(img_in);
if c~=1
    img_in=rgb2gray(img_in);
end
if row~=tpc_row || col~=tpc_col
    img_in = imresize(img_in,[28 28]);
end
if strcmp(mode,'gray')||strcmp(mode,'GRAY')
    % % 如果原图是黑底白字的话
    % im_out=im_in;
    % 如果原图是白底黑字的话
    im_out=255-img_in;
elseif strcmp(mode,'bw')||strcmp(mode,'BW')
    % % 如果原图是黑底白字的话
    im_out=imbinarize(img_in);
    % 如果原图是白底黑字的话
%     im_out=~im2bw(im_in);
end

end
%%