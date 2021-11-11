function [ T ] = supraadjmat2tensor( A, L, N )
%SUPRAADJMAT2TENSOR SHORT_DESCRIPTION.
%
%   T = SUPRAADJMAT2TENSOR(INPUT1,INPUT2) CASE_DESCRIPTION_3.
%
%   T = SUPRAADJMAT2TENSOR(INPUT1,INPUT2,INPUT3) CASE_DESCRIPTION_4.
%
%   Inputs:
%
%       A A_DESCRIPTION.
%
%       L L_DESCRIPTION.
%
%       N N_DESCRIPTION.
%
%   Output:
%
%       T T_DESCRIPTION.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%   Copyright (c) 2015-2016 <a href="http://jeremyguillon.me">GUILLON Jeremy</a>.
%

if nargin < 3, N = size(A,1) / L; end

T = cell(1,L);

for i = 1:L
    T{i} = A(1+(i-1)*N : i*N, 1+(i-1)*N : i*N);
end

end