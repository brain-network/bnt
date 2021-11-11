function threshT = threshold(T, t0, method)
%THRESHOLD Apply a threshold on a single- or multilayer network.
%   THRESHT = THRESHOLD(T, T0, METHOD) CASE_DESCRIPTION.
%
%   Inputs:
%
%       T       Tensor representation of a network.
%       T0      Threshold value. According to the method, could either be a
%               proportion in [0,1] or an absolute threshold.
%       METHOD  String taking value between ['absolute'] or 'proportional'.
%
%   Output:
%
%       THRESHT  Thresholded network represented with a tensor.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%   See also JG.CONN.BINARIZE, JG.CONN.SUPRAADJMAT2TENSOR.
%
%   Copyright (c) 2016 <a href="http://jeremyguillon.me">GUILLON Jeremy</a>


if nargin < 3, method = 'proportional'; end

L = length(T);
threshT = cell(size(T));

for l = 1:L
    if strcmpi(method, 'proportional')
        threshT{l} = threshold_proportional(T{l}, t0);
    elseif strcmpi(method, 'absolute')
        threshT{l} = threshold_absolute(T{l}, t0);
    else
        error('JG:binarize:UnknownThresholdingMethod', 'Unknown thresholding method: ''%s''. Please choose between ''proportional'' or ''absolute''. See ''help jg.conn.binarize'' for more details.', method);
    end
end

end