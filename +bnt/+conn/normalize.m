function [ normT ] = normalize( T, mode )
%NORMALIZE SHORT_DESCRIPTION.
%   normT = NORMALIZE(T) CASE_DESCRIPTION_5.
%
%   normT = NORMALIZE(T, 'mode') CASE_DESCRIPTION_5.
%
%   Input:
%
%       T    Tensor representation of a (multi-layer) network. Note: zeros
%           in the matrices mean no-connection.
%       
%       mode Normalization mode among the following possibilities:
%           'separated' (default) normalizes each layer independantly;
%           'full'      normalizes by the min and max of the whole
%               multilayer network.
%
%   Output:
%
%       normT Normalized version of the tensor.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%       % EXAMPLE3_DESCRIPTION:
%       EXAMPLE3_CODE
%
%   Copyright (c) 2015-2016 <a href="http://jeremyguillon.me">GUILLON Jeremy</a>.
%
%   See also JG.CONN.SUPRAADJMAT2TENSOR.


if nargin < 2
    mode = 'separated';
end

if ~iscell(T)
   error('JG:conn:normalize:BadInput','Please put a tensor as input.'); 
end

normT = cell(size(T));


%% Finding extrema
%

if strcmpi(mode, 'full')
    genMin = inf; % General minimum
    genMax = 0; % General maximum
    for l = 1:length(T)
        A = full(T{l});
        A(A==0) = nan;
        genMin = min(genMin,...
            min(min( A + diag(inf(size(A,1),1)) )) );
        genMax = max(genMax,...
            max(max( A )) );
    end
end


%% Normalization
%

for l = 1:length(T)
    A = double(full(T{l}));
    A(isnan(A)) = 0;
    A(A==0) = nan;
    if strcmpi(mode, 'full')
        normT{l} = (A - genMin)...
            ./ (genMax - genMin);
    else
        normT{l} = (A - min(min(A)))...
            ./ (max(max(A)) - min(min(A)));
    end
    normT{l}(isnan(normT{l})) = 0;
    if issparse(T{l})
        normT{l} = sparse(normT{l});
    end
end


end



