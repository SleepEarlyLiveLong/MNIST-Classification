function y = mynormpdf(x,mu,sigma2)
%MYNORMPDF - The normal probability density function.
%   To calculate the probability density of x under the 
%   Gaussian distribution.
%   
%   y = mynormpdf(x,mu,sigma2)
% 
%   Input - 
%   x: the input value;
%   mu: mean of the current Gaussian distribution;
%   sigma2: variance of the current Gaussian distribution.
%   Output - 
%   y: probability density of input x.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% 
if sigma2>=0
    y = exp((-0.5 * (x - mu).^2)./(sigma2+eps)) ./ (sqrt(2*pi.*(sigma2+eps)));
else
    error('Error! Variance must not be a negative value.');
end

end
%%