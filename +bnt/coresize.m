function s = coresize(A, L, N, f, c)
%CORESIZE SHORT_DESCRIPTION.
%   S = CORESIZE(A, L, N) CASE_DESCRIPTION.
%
%   Inputs:
%
%       A  A_DESCRIPTION.
%       L  L_DESCRIPTION.
%       N  N_DESCRIPTION.
%
%   Output:
%
%       S  S_DESCRIPTION.
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
%   See also BNT.COREPERIPHERY.
%
%   Copyright 2018 <a href="http://guillonjeremy.co">GUILLON Jeremy</a>.

%% Parsing inputs
% 

if nargin < 5 || isempty(c)
    c = ones(L,1) / L; % Richness coefficients default values
end
if nargin < 4 || isempty(f)
    f = @bnt.richness;
end

%%
%

s = sum(bnt.coreperiphery(A, L, N, f, c));


end