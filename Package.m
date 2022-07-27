bntlog('Deleting old toolbox file');
delete bnt.mltbx

%% Publish the examples

bntlog('Cleaning examples'' output folder');
delete example/html/*.html
delete example/html/*.png
bntlog('Publishing examples'' help page:');
for refFile = dir('example/*Example.m')
    bntlog(['\t' refFile.name]);
    publish(strcat('example/', refFile.name),...
        'outputDir', 'example/html');     
end

%% Publish the documentation

bntlog('Cleaning functions'' help pages output folder');
delete doc/html/ref/*.html
delete doc/html/*.html
delete doc/html/ref/*.png
delete doc/html/*.png

addpath('doc');

bntlog('Publishing main help pages:');
for refFile = dir('doc/*.mlx')'
    bntlog(['\t' refFile.name]);
    [~, filename] = fileparts(refFile.name);
    matlab.internal.liveeditor.openAndConvert(...
        which(refFile.name),...
        strcat('doc/html/', filename, '.html'));
end

bntlog('Publishing functions'' help page:');
for refFile = dir('doc/*.m')'
    bntlog(['\t' refFile.name]);
    publish(strcat('doc/', refFile.name),...
        'outputDir', 'doc/html');     
end

movefile('doc/html/*ref.html','doc/html/ref/');
movefile('doc/html/*ref_eq*.png','doc/html/ref/');

rmpath('doc');

%% Build Help Search 

bntlog('Building help search database.');
builddocsearchdb(fullfile(pwd,'doc'));

%% Package the toolbox

bntlog('Packaging BNT.');
matlab.addons.toolbox.packageToolbox('bnt.prj', 'bnt.mltbx');

bntlog('Successfully packaged the toolbox.');
clear;