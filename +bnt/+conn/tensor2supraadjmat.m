function [ A ] = tensor2supraadjmat( T )
%TENSOR2SUPRAADJMAT Convert a tensor to a single supra-adjacency matrix.
%   A = TENSOR2SUPRAADJMAT(T)
%
%   Input:
%
%       T Tensor representation of a (multilayer) network.
%
%   Output:
%
%       A Supra-adjacency matrix representing the (multilayer) network.
%
%   Examples:
%
%       % Convert a 3-layers network's tensor to a supra-adjacency matrix:
%       T = {rand(10,10), rand(10,10), rand(10,10)};
%       A = TENSOR2SUPRAADJMAT(T);
%
%   Copyright (c) 2015-2021 <a href="http://guillonjeremy.co">GUILLON Jeremy</a>.
%
%   See also BNT.CONN.SUPRAADJMAT2TENSOR.

L = length(T); % Number of layers
N = size(T{1},1); % Number of nodes
A = zeros(L*N, L*N);

for i = 1:L
    A(1+(i-1)*N : i*N, 1+(i-1)*N : i*N) = T{i};
end


end