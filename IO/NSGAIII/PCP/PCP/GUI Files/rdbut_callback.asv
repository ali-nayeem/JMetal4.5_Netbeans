function rdbut_callback(~,~,k)
data_scaled=getappdata(pcpnew,'data_scaled');
data_scaled(:,k)=[];
data_raw=getappdata(pcpnew,'data_raw');
data_raw(:,k)=[];
dimnum=getappdata(pcpnew,'dimnum');
labels=cell(1,dimnum-k);
units=labels;
for i = k : dimnum
    h.ledit=findobj('tag',[num2str(i) 'ledit']);
    labels(i)={get(h.ledit,'string')};
    h.uedit=findobj('tag',[num2str(i) 'uedit']);
    units(i)={get(h.uedit,'string')};
    h.ostring=findobj('tag',[num2str(i) 'ostring']);
    h.o1but=findobj('tag',[num2str(i) 'o1but']);
    h.o2but=findobj('tag',[num2str(i) 'o2but']);
    h.fcheck=findobj('tag',[num2str(i) 'fcheck']);
    h.sradio=findobj('tag',[num2str(i) 'sradio']);
    h.rdbut=findobj('tag',[num2str(i) 'rdbut']);
    delete(h.ledit,h.uedit,h.ostring,h.o1but,h.o2but,h.fcheck,h.sradio,h.rdbut);
end
dimnum=dimnum-1;
labels(k)=[];
units(k)=[];
setappdata(pcpnew,'dimnum',dimnum);
for i = 1 : dimnum                                                    %%Create axes controls and callbacks
    h.ostring=uicontrol('style','text','units','pixels','position',[202,(458-(i-1)*23),18,22],'string',num2str(i),'tag',[num2str(i) 'ostring']);
    h.o1but=uicontrol('style','pushbutton','units','pixels','position',[182,(460-(i-1)*23),18,22],'string','+','Callback',{'o1but_callback',i},'tag',[num2str(i) 'o1but']);
    h.o2but=uicontrol('style','pushbutton','units','pixels','position',[222,(460-(i-1)*23),18,22],'string','-','Callback',{'o2but_callback',i},'tag',[num2str(i) 'o2but']);
    set(h.o1but,'callback',{@changeorderstring1,(i)});
    set(h.o2but,'callback',{@changeorderstring2,(i)});
    if i >=k
        h.ledit=uicontrol('style','edit','units','pixels','position',[19,(460-(i-1)*23),97,22],'string',num2str(i),'tag',[num2str(i) 'ledit'],'string',labels{i});
        h.uedit=uicontrol('style','edit','units','pixels','position',[123,(460-(i-1)*23),51,22],'string','','tag',[num2str(i) 'uedit'],'string',units{i});
        h.fcheck=uicontrol('style','check','units','pixels','position',[247,(460-(i-1)*23),18,22],'tag',[num2str(i) 'fcheck']);
        h.sradio=uicontrol('style','radiobutton','units','pixels','position',[300,(458-(i-1)*23),18,22],'tag',[num2str(i) 'sradio']);
        h.rdbut=uicontrol('style','pushbutton','units','pixels','position',[375, (460-(i-1)*23),18,22],'tag',[num2str(i) 'rdbut']);
        set(h.sradio,'callback',{@sel_scaleunits,(i)});
        set(h.rdbut,'callback',{@rdbut_callback,(i)});
    end
end
[mlength,emptyvar1]=size(data_scaled);                                      %%Create dimensions and reset new defaults
groupspec_str=cell(dimnum,2);
groupspec_str(:,:,1)={'Not Specified'};
setappdata(pcpnew,'groupspec_str',groupspec_str);
groupspec_num(:,:,1)=zeros(mlength,(dimnum*2));
setappdata(pcpnew,'groupspec_num',groupspec_num);
groupspec_rank=nan(mlength,1);
setappdata(pcpnew,'groupspec_rank',groupspec_rank);
rangerank=0;
setappdata(pcpnew,'rangerank',rangerank);
ANT=scaletominmax(data_scaled);
setappdata(pcpnew,'data_scaled',ANT);
setappdata(pcpnew,'data_raw',data_raw);
colmat=[1,1,0;1,0,1;0,1,1;1,0,0;0,1,0;0,0,0];                               %%EDITNOTE: If more clusters wish to be added, colmat must be increased
setappdata(pcpnew,'colmat',colmat);
numgrps=getappdata(pcpnew,'numgrps');
for a = 1 : numgrps                                                         %%Delete all existing controls
    h.gnamem=findobj('-regexp','tag',[num2str(a) 'ngroup']);
    h.gedit=findobj('-regexp','tag',[num2str(a) 'egroup']);
    h.ghide=findobj('-regexp','tag',[num2str(a) 'hgroup']);
    h.gcolset=findobj('-regexp','tag',[num2str(a) 'csgroup']);
    h.gtrans=findobj('-regexp','tag',[num2str(a) 'tsgroup']);
    h.gremove=findobj('-regexp','tag',[num2str(a) 'rgroup']);
    h.glinew=findobj('-regexp','tag',[num2str(a) 'lwgroup']);
    h.glines=findobj('-regexp','tag',[num2str(a) 'lsgroup']);
    delete(h.gnamem,h.gedit,h.ghide,h.gcolset,h.gtrans,h.gremove,h.glinew,h.glines);
end
numgrps=0;
setappdata(pcpnew,'numgrps',numgrps);
num_clus=getappdata(pcpnew,'num_clus');
for i = 1: num_clus
    h.cnum=findobj('-regexp','tag',[num2str(i) 'nclus']);
    h.ccolset=findobj('-regexp','tag',[num2str(i) 'csclus']);
    h.chide=findobj('-regexp','tag',[num2str(i) 'hclus']);
    h.ctrans=findobj('-regexp','tag',[num2str(i) 'tsclus']);
    h.cnoise=findobj('-regexp','tag',[num2str(i) 'nrclus']);
    h.csline=findobj('-regexp','tag',[num2str(i) 'lsclus']);
    h.cwline=findobj('-regexp','tag',[num2str(i) 'lwclus']);
    delete(h.cnum,h.ccolset,h.chide,h.ctrans,h.cnoise,h.csline,h.cwline);
end
num_clus=0;
setappdata(pcpnew,'num_clus',num_clus);
h.selnum_clus=findobj('-regexp','tag','selnum_clus');
set(h.selnum_clus,'value',1);