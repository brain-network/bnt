function [mu, muMinus, muPlus] = richness(A, L, N, f, c)
%RICHNESS SHORT_DESCRIPTION.
%   [MU, MUPLUS] = RICHNESS(A, L, N, C) CASE_DESCRIPTION.
%
%   Inputs:
%
%       A  Supra-adjacency matrix.
%       L  Number of layers.
%       N  Number of nodes per layer.
%       F  Single-layer richness function. If not defined, strength is
%           used.
%       C  `c` coefficients vector such as defined in [1].
%
%   Outputs:
%
%       MU      Multiplex richness.
%       MUPLUS  Multiplex richness toward richer nodes.
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

if nargin < 5
    c = ones(L,1) / L; % Richness coefficients default values
end
if nargin < 4
    f = @jg.conn.index.mono.richness;
end


%% Compute richnesses
%

M = L; % Reference's notation
T = jg.conn.supraadjmat2tensor(A,L,N); % Tensor reprensation of the network
mu = zeros(N, 1); % Multiplex richness
muPlus = zeros(N, 1); % Multiplex richness towards higher richness nodes
muMinus = zeros(N, 1); % Multiplex richness towards higher richness nodes
k = cell(1,M); % Single-layer richnesses
kMinus = cell(1,M); % Single-layer richnesses towards lower richness nodes
kPlus = cell(1,M); % Single-layer richnesses towards higher richness nodes

for alpha = 1:M
    T{alpha}(isnan(T{alpha})) = 0;
    [k{alpha}, kMinus{alpha}, kPlus{alpha}] = f(T{alpha});
    mu = mu + c(alpha) .* k{alpha}';
    muMinus = muMinus + c(alpha) .* kMinus{alpha}';
    muPlus = muPlus + c(alpha) .* kPlus{alpha}';
end

end