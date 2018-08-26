function isCore = coreperiphery(A, L, N, f, c)
%COREPERIPHERY SHORT_DESCRIPTION.
%   ISCORE = COREPERIPHERY(A, L, N, C, F) CASE_DESCRIPTION.
%
%   Inputs:
%
%       A  A_DESCRIPTION.
%       L  L_DESCRIPTION.
%       N  N_DESCRIPTION.
%       C  C_DESCRIPTION.
%       F  F_DESCRIPTION.
%
%   Output:
%
%       ISCORE  ISCORE_DESCRIPTION.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%   See also JG.CONN.INDEX.MULTI.RICHNESS, JG.CONN.INDEX.MONO.RICHNESS.
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

%% Compute Multiplex Core-Periphery
%

[mu, muMinus, muPlus] = bnt.multirichness(A, L, N, f, c);

[rankedMu, rankingInd] = sort(mu, 'descend');

[maxMuPlus, rankOfMaxMuPlus] = max(muPlus(rankingInd));

isCore = zeros(N,1);
isCore(rankingInd(1:rankOfMaxMuPlus)) = 1;
isCore = logical(isCore);

%% Plotting

% figure(99); clf; hold on;
% 
% RED = [0.7882    0.3529    0.1490];
% BLUE = [0.3686    0.5490    0.6588];
% 
% hBar = bar(1:rankOfMaxMuPlus, [muPlus(rankingInd(1:rankOfMaxMuPlus)), muMinus(rankingInd(1:rankOfMaxMuPlus))] ./ max(muPlus), 'stacked');
% hBar(1).EdgeColor = 'none';
% hBar(1).BarWidth = 1;
% hBar(1).FaceColor = RED;
% hBar(2).FaceColor = RED;
% hBar(2).EdgeColor = 'none';
% hBar(1).FaceAlpha = .7;
% hBar(2).FaceAlpha = .3;
% 
% hBar = bar(rankOfMaxMuPlus+1:N, [muPlus(rankingInd(rankOfMaxMuPlus+1:N)), muMinus(rankingInd(rankOfMaxMuPlus+1:N))] ./ max(muPlus), 'stacked');
% hBar(1).EdgeColor = 'none';
% hBar(1).BarWidth = 1;
% hBar(1).FaceColor = BLUE;
% hBar(2).FaceColor = BLUE;
% hBar(2).EdgeColor = 'none';
% hBar(1).FaceAlpha = .7;
% hBar(2).FaceAlpha = .3;
% 
% plot(1:rankOfMaxMuPlus, muPlus(rankingInd(1:rankOfMaxMuPlus)) ./ max(muPlus), 'Color', RED);
% plot(rankOfMaxMuPlus:N, muPlus(rankingInd(rankOfMaxMuPlus:end)) ./ max(muPlus), 'Color', BLUE);
% 
% drawnow;

end








