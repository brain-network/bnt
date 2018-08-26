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
%   See also JG.CONN.INDEX.MULTI.COREPERIPHERY.
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