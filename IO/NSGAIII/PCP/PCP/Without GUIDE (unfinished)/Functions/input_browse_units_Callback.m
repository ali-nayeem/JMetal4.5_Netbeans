function input_browse_units_Callback (~,~,~)
h=evalin('base','h');
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
L=load (fullfile(pathname,fileName));                                       %%Load selected file
fn=fieldnames(L);
x=L.(fn{1});                                                                %%Create cell array of strings
dimnum=h.dimnum;
if isequal(size(x),[1 dimnum])
    for i = 1 : dimnum
        set(h.uedit(i),'string',cell2mat(x(i)));                               %%Set labels
    end
else                           
    set(h.output_error,'string','Warning: Label matrix incorrect dimensions','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.output_error,'string','');
end