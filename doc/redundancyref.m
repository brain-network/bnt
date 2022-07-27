%% redundancy

%%
% <html><h2>Syntax</h2></html>
%
%   [Np, Rs, Rv, Rm] = redundancy(A, lmax, norm)
%   [Np, Rs, Rv, Rm] = redundancy( __ , '-isdir')
%

%% 
% <html><h2>Description</h2></html>
%
% |[ <#outputs Np>, <#outputs Rs>, <#outputs Rv>, <#outputs Rm> ] = redundancy(<#inputs A>, <#inputs lmax>, <#inputs norm>)| computes all the possible paths between node pairs.
%
% <html><h2></h2></html>
%
% |[ <#outputs Np>, <#outputs Rs>, <#outputs Rv>, <#outputs Rm> ] = redundancy(_, '-isdir')| computes all the possible paths between node pairs.

%% 
% <html><h2>Examples</h2></html>

for x = 1:10
  x = x + x^2;
end

%% 
% <html><h2 id="inputs">Input Arguments</h2></html>
%
% * *|A|* |-| unweighted adjacency matrix ($N$ nodes); $A$ ($N \times N$) must
%        be symmetric for undirected graphs and asymetric for directed
%        graphs.
%
% * *|Lmax|* |-| max path length must be less than number of nodes.
%
% * *|Norm|* |-| 0/1 for standard/normalized redundancy index.

%% 
% <html><h2 id="outputs">Output Arguments</h2></html>
%
% * *|Np|* |-| 3D matrix $[N \times N \times L_{max}]$ containing the number of all the
%        possible paths of length |1:Lmax| between nodes
%
% * *|Rs|* |-| (global redundancy for all path lengths: sum of elements
%        in |Rv| (normalized by total number of all possible paths of each
%        length in a complete graph of the same size); takes single paths
%        numbers up until paths length Lmax into account) scalar
%        redundancy, global redundancy $=$ sum of the elements in |Np|.
%
% * *|Rv|* |-| (global redundancy for a path lenght: vector of number of
%        paths of length |1...Lmax| (normalized by total number of all
%        possible paths of each length in a complete graph of the same
%        size)) vector redundancy index |[1xLmax]|, redundancy for each
%        length $=$ sum of the elements in Np along the two first dimensions
%        of |Np|.
%
% * *|Rm|* |-| (number of paths (of any length) between all pairs of
%        vertices) matrix redundancy index $[N \times N]$, redundancy for each node
%        pair $=$ sum of the elements in |Np| along the third dimension of
%        |Np|.

%%
% <html><h2>More About</h2></html>
%
% This function is based on a recursive algorithm optimized to work with
% very sparse networks where the number of links $L$ is approximately equal
% to the number of nodes $N$ (i.e. $L<=N$). For $N>>L$ iterative algorithms
% are preferable.

%%
% <html><h2>References</h2></html>
%
% [1] De Vico Fallani et al., "Redundancy in functional brain connectivity
%     from EEG recordings", _Int. J. Bifurcation Chaos 22_, 1250158 (2012).

%% 
% <html><h2>See Also</h2></html>
%
% <matlab:doc('filter') filter> | <matlab:doc('filter') filter2>