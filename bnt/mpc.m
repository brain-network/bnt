function [ P ] = mpc( A, L )
%MPC Compute the multi-participation coefficients.
%   P = MPC(A,L) computes the multiplex participation coefficient of each
%   node of a multiplex network described by its supra-adjacency (square)
%   matrix A, of L layers; according to the definition given in the paper
%   referenced below. It returns a vector of size N x 1, where N is is
%   assumed to be the size of A divided by L.
%
%   Reference:
%       Battiston, Federico, Vincenzo Nicosia, and Vito Latora. "Structural
%       Measures for Multiplex Networks". Physical Review E 89, no. 3
%       (March 12, 2014): 032804. doi:10.1103/PhysRevE.89.032804.
%
%   <a href="http://guillonjeremy.co">Jeremy Guillon</a>.

if mod(size(A,1), L) > 0
    error('bnt:mpc:BadInput', 'Supra-adjacency matrix (with size %d) cannot be divided into %d matrices.', size(A,1), L);
else
    N = size(A,1) / L;
end % if

A(isnan(A)) = 0;
O = overlapadjmat(A,L); % overlapping network adjacency matrix
o = sum(O,2); % overlaping strength vector
m = L/(L-1);
P = ones(size(o)) .* m .* (o~=0); % multi-participation coefficients vector

for l = 1:L
    
    ind = (l-1)*N+1:l*N;
    tmpA = full(A(ind,ind));
    k = sum(tmpA - diag(diag(tmpA)), 2);
    
    P(o~=0) = P(o~=0) ...
        - m * (k(o~=0)./o(o~=0)).^2;
    
end % layers

end % function

