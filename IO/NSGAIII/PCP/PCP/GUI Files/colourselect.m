% --- Function called by csgroup_callback
% Summary: Select group's colour
% Description:
%%%% -Changes and stores colour for group a
function colourselect(hObject, eventdata, a)                                %%Get and set group colour
col=uisetcolor;
h.csgroup=findobj('-regexp','tag',[num2str(a) 'csgroup']);
set(h.csgroup,'BackgroundColor',col);
