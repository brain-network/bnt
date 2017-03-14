function [ Np, Rs, Rv, Rm ] = redundancy(A, Lmax, Norm, varargin)
%REDUNDANCY Compute all the possible paths between node pairs.
%   [Np, Rs, Rv, Rm] = REDUNDANCY(A, LMAX, NORM) The algorithm considers
%   only paths containing nodes visited once and only once (self-avoiding
%   loops).
%
%   [Np, Rs, Rv, Rm] = REDUNDANCY(..., '-isdir')
%
%   Input:
%        -   A        unweighted adjacency matrix (N nodes); A (NxN) must
%        be symmetric for undirected graphs and asymetric for directed
%        graphs.
%
%        -   Lmax      max path length must be less than number of nodes
%
%        -   Norm      0/1 for standard/normalized redundancy index.
%
%        -   '-isdir'  if A is a complete graph that has to be treated as a
%        directed graph (default: undirected).
%
%   Output:
%        -   Np  3D matrix [NxNxLmax] containing the number of all the
%        possible paths of length 1:Lmax between nodes
%
%        -   Rs  (global redundancy for all path lengths: sum of elements
%        in Rv (normalized by total number of all possible paths of each
%        length in a complete graph of the same size); takes single paths
%        numbers up until paths length Lmax into account) scalar
%        redundancy, global redundancy = sum of the elements in Np
%
%        -   Rv  (global redundancy for a path lenght: vector of number of
%        paths of length 1...Lmax (normalized by total number of all
%        possible paths of each length in a complete graph of the same
%        size)) vector redundancy index [1xLmax], redundancy for each
%        length = sum of the elements in Np along the two first dimensions
%        of Np
%
%        -   Rm  (number of paths (of any length) between all pairs of
%        vertices) matrix redundancy index [NxN], redundancy for each node
%        pair = sum of the elements in Np along the third dimension of Np
%
%   Note: 
%       This function is based on a recursive algorithm optimized to work
%       with very sparse networks where the number of links L is
%       approximately equal to the number of nodes N (i.e. L<=N). For N>>L
%       iterative algorithms are preferable.
%
%   Reference:
%       De Vico Fallani et al., Redundancy in functional brain connectivity
%       from eeg recordings, Int. J. Bifurcation Chaos 22, 1250158 (2012).
%
%	Dr.Jlenia Toppi, Dr.Claudia Di Lanzo and Fabrizio De Vico Fallani 
%   University of Rome "Sapienza", IRCCS Fondazione Santa Lucia, CRICM

% Original Date: 11/07/2010 
% Revision Date: 06/03/2013 
% Revision Date: 19/12/2013 --> Contributor Christoph Schmidt, F. Schiller
% University, Jena, Germany.

%% Checking input

if unique(A) ~= [0; 1]
    error('myApp:argChk','The adjacency matrix must be unweighted !!!');
end

%number of nodes in the graph
N=size(A,1);



if ~isequal(A,A.') %unsymmetric A
    Directed=1;
    
else %symmetric A
    
    if nargin<=3
        Directed=0;    
    elseif isequal(nargin,4) && isequal(varargin{1},'-isdir') && isequal(nnz(A),N*(N-1)) %it's a complete graph
        Directed=1;
    else
        error('myApp:argChk','Wrong input argument #4 !!!');
    end
end



if nargin<2 %only A as input 
    
    %consider all the path lengths
    Lmax=N-1;
    
    %the default mode is non-normalized
    Norm=0;
    
else
    
    if Lmax==1
        error('myApp:argChk','The max path length should be greater than 1 !!!');
    end
    
    if Lmax>=N
        error('myApp:argChk','The maximum path length cannot exceed the number of nodes. Cycles are not allowed !!!');
    end
    
end

if nargin<3 %only A and Lmax as input
    %the default mode is non-normalized
    Norm=0;
end

%% Algorithm start

% %start computing
% tic
% 
% % initialize waitbar
% h=waitbar(0,'Computing...');

%initialize the 3d matrix of the Number of Paths
Np=single(zeros(N,N,Lmax));

%assign the first matrix of the thrid dimension of Np equal to A (all paths of length = 1)
Np(:,:,1)=A;

%find Source and Destination nodes of each link
[S D]=find(A);

%count the total Number of Connections
Nc=size(S,1);

%compute the number of all the possible paths starting from each node of S
for i=1:Nc
    
    %initialize the Trace of the visited nodes with the pair of nodes of each link
    T=[S(i) D(i)];
    
    %Find all the nodes connected to the destination node D
    F=find(A(T(2),:));
    
    %remove nodes that have been already visited (self-avoiding loops)
    F(F==T(1))=[];
    
    %continue if there are nodes in the path
    if ~isempty(F)
        
        %update Np with the number of paths of length = 2
        Np(T(1),F,2)=Np(T(1),F,2)+1;
        
        %continue only if the path length is greater than 2
        if Lmax>2
            
            %continue up to the last node in F
            for j=1:size(F,2)
                
                %Length recursive index
                Lr=1;
                
                %compute the number of paths of length 2<L<Lmax
                Np=recursion(A,F,T,Lmax,Np,Lr,j);
                
            end
            
        end
        
    end
    
%     %update the waitbar
%     waitbar(i/Nc);
    
end

% %close waitbar
% close(h);

% %end computing
% toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%GENERATING OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Directed
    
    %compute vector redundancy index for each path length (a vector)
    Rv=squeeze(sum(sum(Np,1)));
    
    %compute scalar redundancy index
    Rs=sum(Rv(1:Lmax));
    
    %compute matrix redundancy index of multiple paths between nodes
    Rm=sum(Np,3);
    
else
    
    % need to divide by 2 for undirected graphs
    Rv=squeeze(sum(sum(Np,1))/2);
    
    Rs=sum(Rv(1:Lmax));
    
    Rm=sum(Np,3);
end



if Norm
    
    %for computing number of Paths for fully-connected reference graph
    NpN=zeros(N,N,Lmax);
    
    for k=1:Lmax
        factnorm=factorial(N-2)/factorial(N-1-k);
        NpN(:,:,k)=factnorm*ones(N,N); %stores for each path length k the number of paths from vertex i to vertex j
    end
   
    NpN(cumsum([1:N+1:N^2; N^2.*ones(Lmax-1,N)]))=0; %setting main diagonal of NpN to zero
    
    
    if Directed   
        %compute vector redundancy index for each path length (a vector)
        RvN=squeeze(sum(sum(NpN,1))); %for each path length 1 ... Lmax: contains max possible number of paths with given length in a complete graph of the same size
        
        %compute scalar redundancy index
        RsN=sum(RvN(1:Lmax)); %sum of number of paths of each length in a complete graph
        
        %compute matrix redundancy index of multiple paths between nodes
        RmN=sum(NpN,3); %for every vertex pair and every path length k the sum of the number of all paths
        
        %normalized parameters       
        Rv=Rv./RvN;      
        Rs=Rs/RsN;     
        Rm=Rm./RmN;
        Rm(logical(eye(size(Rm))))=0; %set NaN values on main diagonal to 0
        
    else
        
        %compute vector redundancy index for each path length (a vector)
        RvN=squeeze(sum(sum(NpN,1)))/2;
        
        %compute scalar redundancy index
        RsN=sum(RvN(1:Lmax));
        
        %compute matrix redundancy index of multiple paths between nodes
        RmN=sum(NpN,3);
        
        %normalized parameters
        Rv=Rv./RvN; 
        Rs=Rs/RsN;
        Rm=Rm./RmN;
    end
    
end


%% RECURSION SUB-FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Np=recursion(A,F,T,Lmax,Np,Lr,j)

%increase Lr
Lr=Lr+1;

%update the visited nodes in T
T(Lr+1)=F(j);

%find the new nodes linked to the last visited node in T
F=find(A(T(Lr+1),:));

for l=1:size(T,2)
    
    %remove nodes that have been already visited (self-avoiding loops)
    F(F==T(l))=[];
    
end

%update Np with the paths having length = Lr+1
Np(T(1),F,Lr+1)=Np(T(1),F,Lr+1)+1;

% continue if the visited path has length < Lmax and if there are more
% nodes to visit
if Lr<Lmax-1 && ~isempty(F)
    
    for m=1:size(F,2)
        
        %evaluate the remaining number of paths
        Np=recursion(A,F,T,Lmax,Np,Lr,m);
        
    end
    
end
