function [C, isCore] = coreness(A, L, N, f, c)
%CORENESS SHORT_DESCRIPTION.
%   CORENESS(A, L, N) CASE_DESCRIPTION.
%
%   Inputs:
%
%       A  A_DESCRIPTION.
%       L  L_DESCRIPTION.
%       N  N_DESCRIPTION.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%   See also JG.CONN.INDEX.MULTI.COREPERIPHERY, JG.CONN.THRESHOLD.
%
%   Copyright 2018 <a href="http://guillonjeremy.co">GUILLON Jeremy</a>.

%% Parsing inputs
% 

if nargin < 5
    c = ones(L,1) / L; % Richness coefficients default values
end
if nargin < 4
    f = @bnt.richness;
end

%%
%

jg.util.l('I modified the thresholds manually', 'Level', 'WARNING');
THRESHOLDS = (1:N)./(N-1); % TODO: Change to 1:N
isCore = nan(N, length(THRESHOLDS));

for iThresh = 1:length(THRESHOLDS)
    T = jg.conn.supraadjmat2tensor(A, L, N);
    T = jg.conn.threshold(T, THRESHOLDS(iThresh),'proportional');
    T = jg.conn.normalize(T, 'separated');
    A2 = jg.conn.tensor2supraadjmat(T);
%     figure(2); imagesc(A2); waitforbuttonpress;
    isCore(:,iThresh) = bnt.coreperiphery(A2, L, N, f, c);
end

C = mean(isCore, 2);

end