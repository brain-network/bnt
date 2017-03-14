function [ O ] = overlapadjmat( A, L )
%OVERLAPADJMAT Compute the overlaping adjacency matrix.
%   O = OVERLAPADJMAT(A,L) returns the overlaping adjacency matrix of size
%   N x N, where N is assumed to be the size of A divided by L.
%
%   Reference:
%       Battiston, Federico, Vincenzo Nicosia, and Vito Latora. "Structural
%       Measures for Multiplex Networks". Physical Review E 89, no. 3
%       (March 12, 2014): 032804. doi:10.1103/PhysRevE.89.032804.
%
%   <a href="http://guillonjeremy.co">Jeremy Guillon</a>.

if mod(size(A,1), L) > 0
    error('bnt:overlapadjmat:BadInput', 'Supra-adjacency matrix (with size %d) cannot be divided into %d matrices.', size(A,1), L);
else
    N = size(A,1) / L;
end % if

O = zeros(N, N);

for l = 1:L
    O = O + A(1+(l-1)*N : l*N,1+(l-1)*N : l*N);
end % layers

end % function