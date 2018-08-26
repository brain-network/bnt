function bntlog(message, varargin)
%BNTLOG Log message function of the Brain Network Toolbox.
%   BNTLOG(MESSAGE, VARARGIN) CASE_DESCRIPTION.
%
%   Inputs:
%
%       MESSAGE   MESSAGE_DESCRIPTION.
%       VARARGIN  VARARGIN_DESCRIPTION.
%
%   Examples:
%
%       % EXAMPLE1_DESCRIPTION:
%       EXAMPLE1_CODE
%
%       % EXAMPLE2_DESCRIPTION:
%       EXAMPLE2_CODE
%
%   See also FPRINTF, SPRINTF, FOPEN, FCLOSE.
%
%   Copyright 2017 <a href="http://guillonjeremy.co">GUILLON Jeremy</a>

%% Parse arguments and options

opt.level = 'INFO';
opt = jg.util.args2opt(varargin, opt);

if ~ismember(opt.level, {'DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'})
    message = sprintf('Invalid logging level: %s', opt.level);
    opt.level = 'ERROR';
end

if ~ischar(message) && ~isstr(message) && isnumeric(message)
    message = num2str(message);
end

%% Format the message

ST = dbstack('-completenames');

if usejava('desktop')
    hyperlink2file = sprintf('<a href="matlab: opentoline(''%s'', %d)">%s</a> ',...
        ST(end).file, ST(end).line, ST(end).name);
else
    hyperlink2file = sprintf('%s ', ST(end).name);
end
formatedmessage = sprintf('[%s] %s: %s\n',...
    datestr(datetime,'yyyy-mm-dd HH:MM:SS.FFF'),...
    opt.level, message);

%% Write the message

if strcmpi(opt.level, 'ERROR')
    fprintf('BNT >> '); 
    cprintf('Errors', hyperlink2file);
    cprintf('Errors', formatedmessage);
elseif strcmpi(opt.level, 'WARNING')
    fprintf('BNT >> '); 
    cprintf('SystemCommands', hyperlink2file); 
    cprintf('SystemCommands', formatedmessage);
elseif strcmpi(opt.level, 'DEBUG')
    fprintf('BNT >> '); 
    cprintf('Comments', hyperlink2file); 
    cprintf('Comments', formatedmessage);
else
    fprintf('BNT >> '); 
    cprintf('Text', hyperlink2file); 
    fprintf(formatedmessage);
end

end