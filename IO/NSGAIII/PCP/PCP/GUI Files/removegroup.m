% --- Function called by rgroup_callback
% Summary: Remove a group
% Description:
%%%% -Gets and removes group a's uicontrols
%%%% -Gets and moves all higher groups into correct position
%%%% -Changes the groupspecs to the correct position
%%%% -Removes group a's (or the extra) groupspecs
%%%% -Sets new groupspecs and other appdata
function removegroup(hObject, eventdata, a)                                 %%Delete group buttons and decrease number of groups
h.gnamem=findobj('-regexp','tag',[num2str(a) 'ngroup']);
h.gedit=findobj('-regexp','tag',[num2str(a) 'egroup']);
h.ghide=findobj('-regexp','tag',[num2str(a) 'hgroup']);
h.gcolset=findobj('-regexp','tag',[num2str(a) 'csgroup']);
h.gtrans=findobj('-regexp','tag',[num2str(a) 'tsgroup']);
h.gremove=findobj('-regexp','tag',[num2str(a) 'rgroup']);
h.glinew=findobj('-regexp','tag',[num2str(a) 'lwgroup']);
h.glines=findobj('-regexp','tag',[num2str(a) 'lsgroup']);
delete(h.gnamem,h.gedit,h.ghide,h.gcolset,h.gtrans,h.gremove,h.glinew,h.glines);
numgrps=getappdata(pcpnew,'numgrps');
groupspec_str=getappdata(pcpnew,'groupspec_str');                           %Get group's data
groupspec_num=getappdata(pcpnew,'groupspec_num');
groupspec_rank=getappdata(pcpnew,'groupspec_rank');
rangerank=getappdata(pcpnew,'rangerank');
if numgrps ~= a
    for i = (a+1):numgrps                                                   %%Move controls
        h.gnamem=findobj('-regexp','tag',[num2str(i) 'ngroup']);
        set(h.gnamem,'position',[454,400-(i-2)*23,52,15],'tag',[num2str(i-1) 'ngroup']);
        h.gedit=findobj('-regexp','tag',[num2str(i) 'egroup']);
        set(h.gedit,'position',[535,400-(i-2)*23,22,22],'tag',[num2str(i-1) 'egroup'],'callback',{@editgroup,(i-1)});
        h.ghide=findobj('-regexp','tag',[num2str(i) 'hgroup']);
        set(h.ghide,'position',[579,400-(i-2)*23,22,22],'tag',[num2str(i-1) 'hgroup']);
        h.gcolset=findobj('-regexp','tag',[num2str(i) 'csgroup']);
        set(h.gcolset,'position',[639,400-(i-2)*23,22,22],'tag',[num2str(i-1) 'csgroup'],'callback',{@colourselect,(i-1)});
        h.gtrans=findobj('-regexp','tag',[num2str(i) 'tsgroup']);
        set(h.gtrans,'position',[710,400-(i-2)*23,110,17],'tag',[num2str(i-1) 'tsgroup']);
        h.gremove=findobj('-regexp','tag',[num2str(i) 'rgroup']);
        set(h.gremove,'position',[852,400-(i-2)*23,22,22],'tag',[num2str(i-1) 'rgroup'],'callback',{@removegroup,(i-1)});
        h.glines=findobj('-regexp','tag',[num2str(i) 'lsgroup']);
        set(h.glines,'position',[892,400-(i-2)*23,70,22],'tag',[num2str(i-1) 'lsgroup']);
        h.glinew=findobj('-regexp','tag',[num2str(i) 'lwgroup']);
        set(h.glinew,'position',[967,400-(i-2)*23,40,22],'tag',[num2str(i-1) 'lwgroup']);
        groupspec_str(:,:,i-1)=groupspec_str(:,:,i);
        groupspec_num(:,:,i-1)=groupspec_num(:,:,i);
        groupspec_rank(:,i-1)=groupspec_rank(:,i);
        rangerank(i-1)=rangerank(i);
    end
end
if a == numgrps && numgrps ==1                                              %%If all groups deleted, reset grouspecs to default                                                
    data_scaled=getappdata(pcpnew,'data_scaled');
    [mlength,dimnum]=size(data_scaled);
    groupspec_str(:,:,numgrps)=cell(dimnum,2);
    groupspec_str(:,:,numgrps)={'Not Specified'};
    groupspec_rank(:,numgrps)=nan(mlength,1);
    setappdata(pcpnew,'groupspec_rank',groupspec_rank);
    setappdata(pcpnew,'groupspec_str',groupspec_str);
    rangerank(numgrps)=0;
    setappdata(pcpnew,'rangerank',rangerank);
    groupspec_num(:,:,numgrps)=zeros(mlength,(dimnum*2));
    setappdata(pcpnew,'groupspec_num',groupspec_num);
else
    groupspec_rank(:,numgrps)=[];                                           %%Delete un-needed grouspecs
    groupspec_str(:,:,numgrps)=[];
    groupspec_num(:,:,numgrps)=[];
    rangerank(numgrps)=[];
    setappdata(pcpnew,'rangerank',rangerank);                               
    setappdata(pcpnew,'groupspec_str',groupspec_str);
    setappdata(pcpnew,'groupspec_num',groupspec_num);
    setappdata(pcpnew,'groupspec_rank',groupspec_rank);
end
numgrps=numgrps-1;                                                          %%Reduce number of groups
setappdata(pcpnew,'numgrps',numgrps);