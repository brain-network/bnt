function [ opt ] = args2opt( args, defaultopt, allowCustomFields )
%ARGS2OPT Create option structure from 'varargin' inputs.
%   opt = ARGS2OPT(args, defaultopt) will return the default
%   option structure modified by args inputs. The output
%   field names are lowercase in order to be case
%   insensitive. The 'defaultopt' field names should be
%   lowercase too.
%
%   Inputs:
%
%       ARGS - Input argument cell array, structure or cell
%           array where the first cell is a structure
%           (happens when a structure is passed as input of
%           a function that use 'varargin' inputs).
%       DEFAULTOPT - Default option structure.
%
%   Output:
%
%       OPT - Option structure.
%
%   Examples:
%
%       % Modifying one option, case insensitive:
%       args = {'paRAm1', 'value1bis'};
%       defaultopt = struct('param1','value1','param2','value2');
%       opt = ARGS2OPT(args, defaultopt)
%
%       % Unknown field detection:
%       args = {'unknownParam', 'value'};
%       defaultopt = struct('param1','value1','param2','value2');
%       opt = ARGS2OPT(args, defaultopt)
%
%       % Args as a structure, again, case insensitive:
%       args = struct('PAraM1', 'value1bis');
%       defaultopt = struct('param1','value1','param2','value2');
%       opt = ARGS2OPT(args, defaultopt)
%
%   Copyright (c) 2015-2016 <a href="http://jeremyguillon.me">GUILLON Jeremy</a>.
%
%   See also VARARGIN, NARGIN, STRUCT, CELL.

if nargin < 3
    allowCustomFields = false;
end

if not(isempty(args)) && isstruct(args{1})
    args = args{1};
end

if nargin < 2
    opt = struct();
else
    opt = defaultopt;
end

if iscell(args)
    if length(args) >= 2
        for pair = reshape(args,2,[])
            name = lower(pair{1});
            value = pair{2};
            opt = setfield(opt, name, value, allowCustomFields);
        end
    end
elseif isstruct(args)
    for field = fieldnames(args)'
        value = args.(char(field));
        name = lower(char(field));
        opt = setfield(opt, name, value, allowCustomFields);
    end
else
    error('JG:args2opt:InvalidInput','The ''args'' input must be either a structure or a cell array; %s received.',class(args));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    function S = setfield(S, name, value, allowCustomFields)
        optFields = fields(S);
        optFieldInd = find(strcmpi(optFields, name));
        if ~isempty(optFieldInd)
            S.(optFields{optFieldInd}) = value;
        elseif isempty(optFieldInd) && allowCustomFields
            S.(name) = value;
        else 
            error('JG:args2opt:setfield:UnknownFieldName', 'Unknown field name: ''%s''.', name);
        end
    end


end
