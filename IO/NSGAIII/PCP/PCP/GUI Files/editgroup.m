% --- Function called by egroup_callback
% Summary: Edit a group's information
% Description:
%%%% -Get specs and rangerank appdata and uicontrol information for group a
%%%% -Start 'groupeditnew.m' and create tables with that group's specs
function editgroup(hObject, eventdata,a)
data=getappdata(pcpnew,'groupspec_str');
rangerank=getappdata(pcpnew,'rangerank');
if rangerank (a) == 0
    groupspec_rank=getappdata(pcpnew,'groupspec_rank');
    groupspec_rank=groupspec_rank(:,a);
    groupspec_rank(groupspec_rank==0)=[];
    numpol=length(groupspec_rank(:));                                          %%Find the number of polylines in a group
    values=[1,2,3,4,5,6,7,8,9,10,20,30,40,50,100,200,300,400,500,1000];
    numpol=find(values==numpol);
    if exist('numpol','var')                                                %%If numpol was not set, select 1
    else
        numpol =1;
    end
end
setappdata(pcpnew,'ea',a);                                                  %%Set the group being worked with
dimnum=getappdata(pcpnew,'dimnum');
labels=cell(dimnum,1);
for i = 1 : dimnum                                                          %%Find labels
    h.ledit=findobj('Tag',[num2str(i) 'ledit']);
    labels(i,:)={get(h.ledit,'string')};
end
Figg=groupeditnew;                                                          %%Run edit
h.epollabel=findobj('tag','epollabel');                                     %%Find/set groupedit controls
h.enumpol=findobj('tag','enumpol');
M=cell(length(data(:,:,1)),2);
M(:,:)={'Not Specified'};
if rangerank(a)==1
    h.gtable=uitable(Figg,'data',data(:,:,a),'ColumnEditable',[true, true],'ColumnName',{'Less than %','Greater than %'},'Tag','Gespec','rowname',labels,'units','pixels','position',[27,25,500,313],'visible','on');
    h.grtable=uitable(Figg,'data',M(:,1),'ColumnEditable',true,'ColumnName',{'Nearest to %'},'Tag','Gerspec','rowname',labels,'units','pixels','position',[27,25,400,313],'visible','off');
    set(h.enumpol,'visible','off');
    set(h.epollabel,'visible','off');
elseif rangerank(a)==0
    h.grtable=uitable(Figg,'data',data(:,1,a),'ColumnEditable',true,'ColumnName',{'Nearest to %'},'Tag','Gerspec','rowname',labels,'units','pixels','position',[27,25,400,313],'visible','on');
    h.gtable=uitable(Figg,'data',M,'ColumnEditable',[true, true],'ColumnName',{'Less than %','Greater than %'},'Tag','Gespec','rowname',labels,'units','pixels','position',[27,25,500,313],'visible','off');
    set(h.enumpol,'visible','on','value',numpol);
    set(h.epollabel,'visible','on');
end
h.gename=findobj('-regexp','Tag','gename');                                 %%Get/and set groupname
h.name=findobj('-regexp','Tag',[num2str(a) 'ngroup']);
name=get(h.name,'string');
set(h.gename,'string',name);