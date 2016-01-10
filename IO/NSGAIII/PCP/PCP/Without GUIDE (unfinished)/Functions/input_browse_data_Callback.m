function input_browse_data_Callback (~,~,~)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0
else
    h=evalin('base','h');
    set(h.input_datadisplay,'String',fileName);
    data_raw=load (fullfile(pathname,fileName));                            %%Load selected file
    data_raw=cell2mat(struct2cell(data_raw));                               %%Ensure matrix is array
    h.data_raw=data_raw;                                                    %%Set data_raw (used later for sradio/scale)
    [mlength,dimnum]=size(data_raw);                                        %%Set dimensions
    h.dimnum=dimnum;
    numgrps=0;                                                              %%Default number of groups
    num_clus=0;
    h.num_clus=num_clus;                                                    %%Default number of clusters
    h.numgrps=numgrps;          
    names = num2cell(1:mlength);                                            %%Default numeric data names
    names = cellfun(@num2str,names,'UniformOutput',false);                    %%(Used if 'datanames' are not browsed for
    h.names=names;
    groupspec_str=cell(dimnum,2);
    groupspec_str(:,:,1)={'Not Specified'};
    groupspec_rank=nan(mlength,1);                                          %%Default group specifications
    groupspec_num(:,:,1)=zeros(mlength,(dimnum*2));
    h.groupspec_num=groupspec_num;                                          %%_num stores 'within range' group data
    h.groupspec_rank=groupspec_rank;                                        %%_rank stores 'rank similarity' group data
    h.groupspec_str=groupspec_str;                                          %%_str stores strings for group tables
    rangerank=0;                                                            %%rangerank stores data about whether the group is range/rank
    h.rangerank=rangerank;
    colmat=[1,1,0;1,0,1;0,1,1;1,0,0;0,1,0;0,0,0];                           %%EDITNOTE: If more clusters wish to be added, colmat must be increased
    h.colmat=colmat;
    data_scaled=scaletominmax(data_raw);                                    %%Use scaletominmax to scale data as described in manual
    h.data_scaled=data_scaled;
    for i = 1 : dimnum                                                      %%Create axes controls and callbacks
        h.ledit(i)=uicontrol('style','edit','units','pixels','position',[19,(470-(i-1)*23),97,22],'string',num2str(i));
        h.uedit(i)=uicontrol('style','edit','units','pixels','position',[123,(470-(i-1)*23),51,22],'string','');
        h.ostring(i)=uicontrol('style','text','units','pixels','position',[202,(468-(i-1)*23),18,22],'string',num2str(i));
        h.o1but(i)=uicontrol('style','pushbutton','units','pixels','position',[182,(470-(i-1)*23),18,22],'string','+');
        h.o2but(i)=uicontrol('style','pushbutton','units','pixels','position',[222,(470-(i-1)*23),18,22],'string','-');
        h.fcheck(i)=uicontrol('style','check','units','pixels','position',[270,(470-(i-1)*23),18,22]);
        h.sradio(i)=uicontrol('style','radiobutton','units','pixels','position',[350,(468-(i-1)*23),18,22]);
        set(h.o1but(i),'callback',{@o1but_Callback,h,i});
        set(h.o2but(i),'callback',{@o2but_Callback,h,i});
        set(h.sradio(i),'callback',{@sradio_Callback,h,i});
    end
    set(h.groups_panel,'visible','on');
    set(h.clusters_panel,'visible','on');
    set(h.output_panel,'visible','on');
    set(h.filter_panel,'visible','on');
    set(h.density_panel,'visible','on');
    set(h.input_browse_labels,'visible','on');
    set(h.input_browse_units,'visible','on');
    set(h.input_browse_names,'visible','on');
    set(h.input_optorder,'visible','on');
    set(h.input_datadisplay,'visible','on');
    set(h.input_plotrawdata,'visible','on');
    assignin('base','h',h);
end