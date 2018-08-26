function [k, kMinus, kPlus] = richness(A, f)
%RICHNESS SHORT_DESCRIPTION.
%   [K, KMINUS, KPLUS] = RICHNESS(A, F) CASE_DESCRIPTION.
%
%   Inputs:
%
%       A  A_DESCRIPTION.
%       F  F_DESCRIPTION.
%
%   Outputs:
%
%       K       K_DESCRIPTION.
%       KMINUS  KMINUS_DESCRIPTION.
%       KPLUS   KPLUS_DESCRIPTION.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%   References: 
%
%       [1] Battiston, F., Guillon, J., Chavez, M., Latora, V. & Fallani, F.
%       D. V. Multiplex core-periphery organization of the human
%       connectome. arXiv:1801.01913 [physics, q-bio] (2017).
%
%   Copyright 2018 <a href="http://guillonjeremy.co">GUILLON Jeremy</a>.


%% Parsing inputs
% 

if nargin < 2
    f = @strengths_und;
end


%% Compute richnesses
%

N = size(A,1);
k = f(A);
kMinus = zeros(size(k));
kPlus = zeros(size(k));

for i = 1:N
    lrInd = k <= k(i); % Indices of nodes with Lower Richness (LR)
    hrInd = k > k(i); % Indices of nodes with Higher Richness (HR)
    
    lrA = A; lrA(i, hrInd) = 0; lrA(hrInd, i) = 0;
    hrA = A; hrA(i, lrInd) = 0; hrA(lrInd, i) = 0;
    
    kMinusForI = f(lrA);
    kMinus(i) = kMinusForI(i);
    kPlusForI = f(hrA);
    kPlus(i) = kPlusForI(i);
end

end