%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MATLAB GUIDE startup functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = pcpnew(varargin)
my_dir=pwd;
addpath([my_dir '/GUI Files']);
% PCPNEW MATLAB code for pcpnew.fig
%      PCPNEW, by itself, creates a new PCPNEW or raises the existing
%      singleton*.
%
%      H = PCPNEW returns the handle to a new PCPNEW or the handle to
%      the existing singleton*.
%
%      PCPNEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCPNEW.M with the given input arguments.
%
%      PCPNEW('Property','Value',...) creates a new PCPNEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcpnew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcpnew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcpnew

% Last Modified by GUIDE v2.5 13-Aug-2013 10:49:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pcpnew_OpeningFcn, ...
    'gui_OutputFcn',  @pcpnew_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pcpnew is made visible.
function pcpnew_OpeningFcn(hObject, emptyvar1, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcpnew (see VARARGIN)

% Choose default command line output for pcpnew
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pcpnew wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcpnew_OutputFcn(emptyvar1, emptyvar2, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Callbacks and functions in the 'main' panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in browse_data.
% Summary: Browse for data
% Description:
%%%% -Browses for and sets dataset
%%%% -Scales dataset
%%%% -Creates 'main' panel uicontrols
%%%% -Sets variables to defaults
function browse_data_Callback(emptyvar1, emptyvar2, handles)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0
else
    dimnum=getappdata(pcpnew,'dimnum');
    for i = 1 : dimnum
        h.ledit=findobj('tag',[num2str(i) 'ledit']);
        h.uedit=findobj('tag',[num2str(i) 'uedit']);
        h.ostring=findobj('tag',[num2str(i) 'ostring']);
        h.o1but=findobj('tag',[num2str(i) 'o1but']);
        h.o2but=findobj('tag',[num2str(i) 'o2but']);
        h.fcheck=findobj('tag',[num2str(i) 'fcheck']);
        h.sradio=findobj('tag',[num2str(i) 'sradio']);
        h.rdbut=findobj('tag',[num2str(i) 'rdbut']);
        delete(h.ledit,h.uedit,h.ostring,h.o1but,h.o2but,h.fcheck,h.sradio,h.rdbut);
    end
    num_clus=getappdata(pcpnew,'num_clus');
    h.selnum_clus=findobj('tag','selnum_clus');
    set(h.selnum_clus,'value',1);
    for i = 1: num_clus                                                     %%All buttons are deleted
        h.cnum=findobj('-regexp','tag',[num2str(i) 'nclus']);
        h.ccolset=findobj('-regexp','tag',[num2str(i) 'csclus']);
        h.chide=findobj('-regexp','tag',[num2str(i) 'hclus']);
        h.ctrans=findobj('-regexp','tag',[num2str(i) 'tsclus']);
        h.cnoise=findobj('-regexp','tag',[num2str(i) 'nrclus']);
        h.csline=findobj('-regexp','tag',[num2str(i) 'lsclus']);
        h.cwline=findobj('-regexp','tag',[num2str(i) 'lwclus']);
        delete(h.cnum,h.ccolset,h.chide,h.ctrans,h.cnoise,h.csline,h.cwline);
    end
    numgrps=getappdata(pcpnew,'numgrps');
    for a = 1 : numgrps
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
    set(handles.datalabel,'String',fileName);                               %%Get selected file
    data_raw=load (fullfile(pathname,fileName));                            %%Load selected file
    data_raw=cell2mat(struct2cell(data_raw));                               %%Ensure matrix is array
    setappdata(pcpnew,'data_raw',data_raw);                                 %%Set data_raw (used later for sradio/scale)
    [mlength,dimnum]=size(data_raw);                                        %%Set dimensions
    setappdata(pcpnew,'dimnum',dimnum);
    numgrps=0;                                                              %%Default number of groups
    num_clus=0;
    setappdata(pcpnew,'num_clus',num_clus);                                 %%Default number of clusters
    setappdata(pcpnew,'numgrps',numgrps);
    names = num2cell(1:mlength);                                            %%Default numeric data names
    names=cellfun(@num2str,names,'UniformOutput',false);                    %%Used if 'datanames' are not browsed for
    setappdata(pcpnew,'datanames',names);
    groupspec_str=cell(dimnum,2);
    groupspec_str(:,:,1)={'Not Specified'};
    groupspec_rank=nan(mlength,1);                                          %%Default group specifications
    groupspec_num(:,:,1)=zeros(mlength,(dimnum*2));
    setappdata(pcpnew,'groupspec_num',groupspec_num);                       %%_num stores 'within range' group data
    setappdata(pcpnew,'groupspec_rank',groupspec_rank);                     %%_rank stores 'rank similarity' group data
    setappdata(pcpnew,'groupspec_str',groupspec_str);                       %%_str stores strings for group tables
    rangerank=0;                                                            %%rangerank stores data about whether the group is range/rank
    setappdata(pcpnew,'rangerank',rangerank);
    data_scaled=scaletominmax(data_raw);                                    %%Use scaletominmax to scale data as described in manual
    setappdata(pcpnew,'data_scaled',data_scaled);
    for i = 0 : dimnum-1                                                    %%Create axes controls and callbacks
        h.ledit=uicontrol('style','edit','units','pixels','position',[19,(460-i*23),97,22],'string',num2str(i+1),'tag',[num2str(i+1) 'ledit']);
        h.uedit=uicontrol('style','edit','units','pixels','position',[123,(460-i*23),51,22],'string','','tag',[num2str(i+1) 'uedit']);
        h.ostring=uicontrol('style','text','units','pixels','position',[202,(458-i*23),18,22],'string',num2str(i+1),'tag',[num2str(i+1) 'ostring']);
        h.o1but=uicontrol('style','pushbutton','units','pixels','position',[182,(460-i*23),18,22],'string','+','Callback',{'o1but_callback',i+1},'tag',[num2str(i+1) 'o1but']);
        h.o2but=uicontrol('style','pushbutton','units','pixels','position',[222,(460-i*23),18,22],'string','-','Callback',{'o2but_callback',i+1},'tag',[num2str(i+1) 'o2but']);
        h.fcheck=uicontrol('style','check','units','pixels','position',[247,(460-i*23),18,22],'tag',[num2str(i+1) 'fcheck']);
        h.sradio=uicontrol('style','radiobutton','units','pixels','position',[300,(458-i*23),18,22],'tag',[num2str(i+1) 'sradio']);
        h.rdbut=uicontrol('style','pushbutton','units','pixels','position',[375, (460-i*23),18,22],'tag',[num2str(i+1) 'rdbut']);
        set(h.o1but,'callback',{@changeorderstring1,(i+1)},'interruptible','off');
        set(h.o2but,'callback',{@changeorderstring2,(i+1)},'interruptible','off');
        set(h.sradio,'callback',{@sel_scaleunits,(i+1)},'interruptible','off');
        set(h.rdbut,'callback',{@rdbut_callback,(i+1)},'interruptible','off');
    end
    h.cluspn=findobj('-regexp','tag','cluspan');                            %%Allow interaction with remaining interface
    set(h.cluspn,'visible','on');
    h.groppn=findobj('-regexp','tag','groppan');
    set(h.groppn,'visible','on');
    h.outpn=findobj('-regexp','tag','outpan');
    set(h.outpn,'visible','on');
    h.opo=findobj('-regexp','tag','opt_order');
    set(h.opo,'visible','on');
    h.browsl=findobj('-regexp','tag','browse_lab');
    set(h.browsl,'visible','on');
    h.browsa=findobj('-regexp','tag','browse_units');
    set(h.browsa,'visible','on');
    h.browsn=findobj('-regexp','tag','browse_names');
    set(h.browsn,'visible','on');
    h.plotrw=findobj('-regexp','tag','plotraw');
    set(h.plotrw,'visible','on');
    h.filpanel=findobj('-regexp','tag','filpanel');
    set(h.filpanel,'visible','on');
    h.denpanel=findobj('tag','denpanel');
    set(h.denpanel,'visible','on');
    h.maxmin=findobj('tag','maxmin');
    set(h.maxmin,'visible','on');
    h.sstate=findobj('tag','sstate');
    set(h.sstate,'visible','on');
end

% --- Executes on button press in browse_lab.
% Summary: Browse for labels
% Description:
%%%% -Browses for and sets data labels
%%%% -Returns an error if incorrect dimensions
function browse_lab_Callback(emptyvar1, emptyvar2, emptyvar3)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0
else
L=load (fullfile(pathname,fileName));                                       %%Load selected file
fn=fieldnames(L);
x=L.(fn{1});                                                                %%Create cell array of strings
dimnum=getappdata(pcpnew,'dimnum');
if isequal(size(x),[1 dimnum])
    for i = 1 : dimnum
        h.ledit=findobj('tag',[num2str(i) 'ledit']);
        set(h.ledit,'string',cell2mat(x(i)));                               %%Set labels
    end
else
    h.errer=findobj('-regexp','tag','errer');                               %%If the dimensions don't match flag up and error
    set(h.errer,'string','Warning: Label matrix incorrect dimensions','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.errer,'string','');
end
end

% --- Executes on button press in browse_units.
% Summary: Browse for units
% Description:
%%%% -Browses for and sets data units
%%%% -Returns an error if incorrect dimensions
function browse_units_Callback(emptyvar1, emptyvar2, emptyvar3)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0 
else
L=load (fullfile(pathname,fileName));                                       %%Load selected file
fn=fieldnames(L);
x=L.(fn{1});                                                                %%Create cell array of strings
dimnum=getappdata(pcpnew,'dimnum');
if isequal(size(x),[1 dimnum])
    for i = 1 : dimnum
        h.uedit=findobj('tag',[num2str(i) 'uedit']);
        set(h.uedit,'string',cell2mat(x(i)));                               %%Set units
    end
else
    h.errer=findobj('-regexp','tag','errer');                               %%If the dimensions don't match flag up and error
    set(h.errer,'string','Warning: Unit matrix incorrect dimensions','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.errer,'string','');
end
end

% --- Executes on button press in browse_names.
% Summary: Browse for names
% Description:
%%%% -Browses for data names
%%%% -Returns an error if incorrect dimensions
function browse_names_Callback(emptyvar1, emptyvar2, emptyvar3)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0
else
L=load (fullfile(pathname,fileName));                                       %%Load selected file
fn=fieldnames(L);
x=L.(fn{1});                                                                %%Create cell array of strings
data_scaled=getappdata(pcpnew,'data_scaled');
[mlength,emptyvar1]=size(data_scaled);
if isequal(length(x),mlength)
    setappdata(pcpnew,'datanames',x)                                        %%Set datanames
else
    h.errer=findobj('-regexp','tag','errer');                               %%If the dimensions don't match flag up and error
    set(h.errer,'string','Warning: Data name matrix incorrect dimensions','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.errer,'string','');
end
end

% --- Executes on button press in opt_order.
% Summary: Optimises order
% Description:
%%%% -Uses function 'ordertest' to find (approx) optimal order
%%%% -Sets the ostrings to that order
function opt_order_Callback(emptyvar1,emptyvar2,emptyvar3)
data_scaled=getappdata(pcpnew,'data_scaled');                               %%Get data
[corder]=ordertest(data_scaled);                                            %%Retrieve optimised order, 'corder'
dimnum=getappdata(pcpnew,'dimnum');
for i = 1 : dimnum
    h.ostring=findobj('tag',[num2str(i) 'ostring']);                        %%Set new order
    set(h.ostring,'string',num2str(corder(i)));
end

% --- Function called by o1but_callback
% Summary: Increases dimension position on axes
% Description:
%%%% -If the string is not already equal to the number of dimensions:
%%%% -Changes tag('aostring') to increase by 1
%%%% -Changes tag('(a+1ostring') to decrease by 1
function changeorderstring1(emptyvar1, emptyvar2, a)
h.ostring=findobj('tag',[num2str(a) 'ostring']);
val=str2double(get(h.ostring,'string'));                                    %%Get the current string value
dimnum=getappdata(pcpnew,'dimnum');
if val < dimnum                                                             %%Unless the string is at the end of the order already
    h.ostring2=findobj('string',num2str(val+1),'style','text');             %%Find the string value of the current string value + 1
    set(h.ostring,'string',num2str(val+1));                                 %%Switch string values
    set(h.ostring2,'string',num2str(val));
end



% --- Function call by o2but_callback
% Summary: Decreases dimension position on axes
% Description:
%%%% -If the string is not already equal to 1:
%%%% -Changes tag('aostring') to decrease by 1
%%%% -Changes tag('(a-1ostring') to increase by 1
function changeorderstring2(emptyvar1, emptyvar2, a)
h.ostring=findobj('tag',[num2str(a) 'ostring']);                            %%Get the current string value
val=str2double(get(h.ostring,'string'));
if val > 1                                                                  %%Unless the string is at the start of the order already
    h.ostring2=findobj('string',num2str(val-1),'style','text');             %%Find the string value of the current string value - 1
    set(h.ostring,'string',num2str(val-1));                                 %%Switch string values
    set(h.ostring2,'string',num2str(val));
end

% --- Function called by sradio_callback
% Summary: Select dimension's scale and units to be displayed on axes
% Description:
%%%% -Ensures all other radio buttons are unselected
function sel_scaleunits(emptyvar1,emptyvar2,a)
dimnum=getappdata(pcpnew,'dimnum');
for i= 1 : dimnum
    if i ~= a                                                               %%Ensure only one scale can be set
        h.sradio=findobj('tag',[num2str(i) 'sradio']);
        set(h.sradio,'value',0);
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (Initial) callbacks in 'group' panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in cgroup.
% Summary: Creates a group
% Description:
%%%% -Gets label data from tag('ledit')
%%%% -Sets default table contents
%%%% -Sets default range/rank
%%%% -Initialises 'groupnew.m' and creates, labels and fills its table
function cgroup_Callback(emptyvar1, emptyvar2, emptyvar3)
numgrps=getappdata(pcpnew,'numgrps');
numgrps=numgrps+1;                                                          %%Store amount of groups data
dimnum=getappdata(pcpnew,'dimnum');
labels=cell(dimnum,1);
for i = 1 : dimnum                                                          %%Find labels
    h.ledit=findobj('Tag',[num2str(i) 'ledit']);
    labels(i,:)={get(h.ledit,'string')};
end
M=cell(dimnum,2);                                                           %%New group's default specification
M(:,:)={'Not Specified'};
rangerank=getappdata(pcpnew,'rangerank');
rangerank(numgrps)=1;                                                       %%Group default is 'within range'
setappdata(pcpnew,'rangerank',rangerank);
Figg=groupnew;                                                              %%Start 'groupnew'
h.gtable=uitable(Figg,'data',M,'ColumnEditable',[true, true],'ColumnName',{'Less than %','Greater than %'},'Tag','Gspec','rowname',labels,'units','pixels','position',[27,25,500,313]);
h.grtable=uitable(Figg,'data',M(:,1),'ColumnEditable',true,'ColumnName',{'Nearest to %'},'Tag','Grspec','rowname',labels,'units','pixels','position',[27,25,400,313],'visible','off');
h.gname=findobj('-regexp','Tag','gname');                                   %%Create 'within range' and 'rank similarity' tables and group name
set(h.gname,'string',num2str(numgrps));

%%%Note about groups
%groupspec_num: groupspec_num is a matrix containing 1's where a group specification has been met
%and 0's where it has not been met. If all group specifications have been
%met (i.e. the datum belongs to the group) then the datum's row will have
%all 1's, hence these are summed in 'JN' and 'allJN' to find the group
%members. (This weird format is used to keep all groupspec_num's uniform
%matrix sizes)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Callbacks in 'cluster' panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in selnum_clus.
% Summary: Select number of clusters
% Description:
%%%% -Removes any existing cluster uicontrols
%%%% -Creates new cluster uicontrols equal to number selected
%%%% -Performs a kmeans function on data_scaled and stores output
function selnum_clus_Callback(hObject, emptyvar1, emptyvar2)
num_clus=getappdata(pcpnew,'num_clus');                                     %%num_clus=number of clusters
hide=zeros(1,6);                                                            %%EDITNOTE: Matrix sizes will need changing if increase amount of clusters > 6
tran=hide;
nois=hide;
styl=ones(1,6);
wid=styl;
styl=styl*4;
colmat=[1,1,0;1,0,1;0,1,1;1,0,0;0,1,0;0,0,0];
for i = 1: num_clus                                                         %%All buttons are deleted on cluster number change
    h.cnum=findobj('-regexp','tag',[num2str(i) 'nclus']);
    h.ccolset=findobj('-regexp','tag',[num2str(i) 'csclus']);
    colmat(i,:)=get(h.ccolset,'BackgroundColor');
    h.chide=findobj('-regexp','tag',[num2str(i) 'hclus']);
    hide(i)=get(h.chide,'value');
    h.ctrans=findobj('-regexp','tag',[num2str(i) 'tsclus']);
    tran(i)=get(h.ctrans,'value');
    h.cnoise=findobj('-regexp','tag',[num2str(i) 'nrclus']);
    nois(i)=get(h.cnoise,'value');
    h.csline=findobj('-regexp','tag',[num2str(i) 'lsclus']);
    styl(i)=get(h.csline,'value');
    h.cwline=findobj('-regexp','tag',[num2str(i) 'lwclus']);
    wid(i)=get(h.cwline,'value');
    delete(h.cnum,h.ccolset,h.chide,h.ctrans,h.cnoise,h.csline,h.cwline);
end
num_clus=get(hObject,'value');                                              %%Get new amount of clusters
if num_clus == 1                                                            %%If the number of selected clusters is 1, no clusters exist
    num_clus =0;
    setappdata(pcpnew,'num_clus',num_clus);
else
    setappdata(pcpnew,'num_clus',num_clus);                                 %%Set new number of clusters
    for i = 1 : num_clus                                                    %%Cluster controls are recreated to the selected number of clusters
        h.cnum=uicontrol('style','text','string',num2str(i),'units','pixels','position',[465,196-(i-1)*23,77,14],'tag',[num2str(i) 'nclus']);
        h.ccolset=uicontrol('style','pushbutton','units','pixels','position',[549,194-(i-1)*23,22,22],'tag',[num2str(i) 'csclus'],'BackgroundColor',colmat(i,:));
        h.chide=uicontrol('style','checkbox','units','pixels','position',[637,194-(i-1)*23,22,22],'tag',[num2str(i) 'hclus'],'value',hide(i));
        h.ctrans=uicontrol('style','slider','units','pixels','position',[686,194-(i-1)*23,110,17],'tag',[num2str(i) 'tsclus','value',tran(i)]);
        h.cnoise=uicontrol('style','checkbox','units','pixels','position',[828,194-(i-1)*23,22,22],'tag',[num2str(i) 'nrclus'],'value',nois(i));
        h.clines=uicontrol('style','popupmenu','units','pixels','position',[882,194-(i-1)*23,70,22],'tag',[num2str(i) 'lsclus'],'string',{'dot','dash-dot','dash','solid'},'value',styl(i));
        h.clinew=uicontrol('style','popupmenu','units','pixels','position',[957,194-(i-1)*23,40,22],'tag',[num2str(i) 'lwclus'],'string',{'0.5','1.0','2.0','3.0','4.0','5.0','6.0','7.0','8.0','9.0','10.0','12.0'},'value',wid(i));
        set(h.ccolset,'callback',{@clus_colsel,i},'interruptible','off');
    end
    data_scaled=getappdata(pcpnew,'data_scaled');
    [IDX,C,sumd]=kmeans(data_scaled,num_clus);                              %%Get and store kmeans data for new amount of clusters
    setappdata(pcpnew,'C',C);
    setappdata(pcpnew,'sumd',sumd);
    setappdata(pcpnew,'IDX',IDX);
end

% --- Function called by 'csclus_Callback'
% Summary: Select cluster's colour
% Decription:
%%%% -Changes and stores colour for cluster a
%%%% -(NOTE) colours are stored to allow choices to be retained when
%%%% different numbers of clusters are selected
function clus_colsel (emptyvar1,emptyvar2,a)
col=uisetcolor;                                                             %%uisetcolor is a matlab colour palette function
h.csclus=findobj('-regexp','tag',[num2str(a) 'csclus']);
set(h.csclus,'BackgroundColor',col);                                        %%Colour is stored in the panel


% --- Executes on button press in optnum_clus.
% Summary: Optimise number of clusters
% Description:
%%%% -Calls function 'kmeanstest' to select the ideal number of clusters
function optnum_clus_Callback(emptyvar1,emptyvar2,emptyvar3)
data_scaled = getappdata(pcpnew,'data_scaled');
h.errer=findobj('-regexp','tag','errer');
h.cancelcalc=findobj('tag','cancelcalc');
kmeanstest(data_scaled,h);                                                  %%Calls kmeanstest to optimise number of clusters

% --- Executes on button press in kmedoid.
% Summary: Use kmedoid method for clusters
% Description:
%%%% -Calls function kemdoids (Copyright (c) 2010, Michael Chen) for
%%%% data_scaled and stores output
%%%% -Returns an error if <=1 clusters selected
function kmedoid_Callback(emptyvar1, emptyvar2, emptyvar3)
h.kmedoid=findobj('tag','kmedoid');
if get(h.kmedoid,'value')==1                                                %%If kmedoid is selected
    num_clus=getappdata(pcpnew,'num_clus');
    if num_clus > 1                                                         %%And if clusters exist
        data_scaled=getappdata(pcpnew,'data_scaled');
        data_scaled=data_scaled';
        [a,emptyvar1,emptyvar2]=kmedoids(data_scaled,num_clus);             %%Create and store new kmedoids cluster set
        a=a';
        setappdata(pcpnew,'medIDX',a);
    else
        set(h.kmedoid,'value',0);
        h.errer=findobj('-regexp','tag','errer');                           %%If no clusters selected flag error
        set(h.errer,'string','Warning: Please select a number of clusters before using medoids','ForegroundColor',[1 0 0]);
        pause(5);
        set(h.errer,'string','');
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Callbacks for 'output' panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in createf.
% Summary: Creates a new figure
% Description:
%%%% -Gets and stores current amount of open figures
%%%% -Creates a figure tag('(numfigs)Fig')
%%%% -Gets data_scaled and sets cursor mode for function 'dispnames'
function createf_Callback(emptyvar1, emptyvar2, emptyvar3)
numfigs=size(findobj('type','figure'));                                     %%Count amount of open figures and create a new one
numfigs=numfigs(1);
numfigs=numfigs+1;
setappdata(pcpnew,'numfigs',numfigs);
datanames=getappdata(pcpnew,'datanames');
data_scaled=getappdata(pcpnew,'data_scaled');
[emptyvar1,dimnum]=size(data_scaled);
    order=NaN(dimnum,1);
    flip=order;
    for i = 1 : dimnum                                                      %%Find/set order/flips/scale
        order(i,1)=str2double(get(findobj('tag',[num2str(i) 'ostring']),'string'));
        flip(i,1)=get(findobj('tag',[num2str(i) 'fcheck']),'value');
    end
    [o order]=sort(order);
    data_transformed=data_scaled;                                           %%Create transform matrix for flips and ordering
    flip=find(flip==1);
    data_transformed(:,flip)=-data_scaled(:,flip);
    data_transformed(:,o)=data_transformed(:,order');
h.f=figure('units','pixels','position',[50,50,500,500],'toolbar','figure','menu','none','tag',[num2str(numfigs) 'Fig']);
dcm_obj=datacursormode(h.f);
set(dcm_obj,'UpdateFcn',{@dispnames,data_transformed,datanames});                %%Passes appdata variables to name display for data cursor
axes('parent',h.f);

% --- Executes on button press in updatef.
% Summary: Updates/plots onto new figure
% Description:
%%%% -Gets handle for created figure, if it finds none returns error
%%%% -Gets appdata and information from uicontrols
%%%% -Creates default matriecs and empty matrices for use in loops
%%%% -Flips and orders data_scaled into data_transformed
%%%% -If 'plotraw' is checked then data_transformed is plotted
%%%% -If groups exist groupspec_num, groupspec_rank, rangerank matrices are taken from
%%%% appdata
%%%% -For each group (if it is not hidden):
%%%%%%%% --Relevent plotting information is extracted from uicontrols
%%%%%%%% --The members of data_scaled are extracted from its groupspec
%%%%%%%% --Empty groups return an error message
%%%%%%%% --If an envelope has not been specified the group is plotted
%%%%%%%% --If an envelope has been specified its upper and lower and
%%%%%%%% calculated and the fill is plotted
%%%% -If clusters exist kmedoird button determines which clusters are used
%%%% -For each cluster (if it is not hidden):
%%%%%%%% --Relevent plotting information is extracted from uicontrols
%%%%%%%% --If noise reduction is selected, the UQ/LQ is calculated and data
%%%%%%%% outside of it are eliminated
%%%%%%%% --If an envelope has not been specified the group is plotted
%%%%%%%% --If an envelope has been specified its upper and lower and
%%%%%%%% calculated and the fill is plotted
%%%% -Labels and scales are set on the figure appropriately
function updatef_Callback(emptyvar1, emptyvar2, emptyvar3)
h.errer=findobj('-regexp','tag','errer');
set(h.errer,'string','Please wait','ForegroundColor',[0 1 0]);
numfigs=getappdata(pcpnew,'numfigs');
h.f=findobj('tag',[num2str(numfigs) 'Fig']);                                %%Find new figure
misc_axes=findobj('parent',h.f,'tag','misc_axes');
delete(misc_axes);
if isempty(h.f)                                                             %%If no available figure flag up error
    set(h.errer,'string','Warning: No figure created','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.errer,'string','');
else
    figure(h.f);
    h.axes=findobj('type','axes');
    data_scaled=getappdata(pcpnew,'data_scaled'); 
    data_raw=getappdata(pcpnew,'data_raw');                                 %%Load dataseet
    [mlength, dimnum]=size(data_scaled);                                    %%Create dimensions
    styletypes={':','-.','--','-'};                                         %%Create style matrix (quicker than appdata?)
    widtypes=[0.5,1,2,3,4,5,6,7,8,9,10,12];                                 %%Create width matrix (quicker than appdata?)
    scaleax=NaN(1,dimnum);                                                  %%Preallocate axis variables
    order=scaleax;
    unitm=cell(1,dimnum);
    labels=unitm;
    flip=scaleax;
    maxmin=get(findobj('tag','maxmin'),'value');
    for i = 0 : dimnum-1                                                    %%Find/set labels/units/order/flips/scale
        h.ledit=findobj('Tag',[num2str(i+1) 'ledit']);
        h.uedit=findobj('Tag',[num2str(i+1) 'uedit']);
        h.ostring=findobj('Tag',[num2str(i+1) 'ostring']);
        h.fcheck=findobj('Tag',[num2str(i+1) 'fcheck']);
        h.sradio=findobj('Tag',[num2str(i+1) 'sradio']);
        scaleax(i+1)=get(h.sradio,'value');
        order(i+1)=str2double(get(h.ostring,'string'));
        if maxmin==1
        unitm(i+1)={[get(h.uedit,'string') ' (' num2str(max(data_raw(:,(i+1)))) ')' ]};
        labels(i+1)={[get(h.ledit,'string') ' (' num2str(min(data_raw(:,(i+1)))) ')' ]};
        else
        unitm(i+1)={get(h.uedit,'string')};
        labels(i+1)={get(h.ledit,'string')};        
        end
        flip(i+1)=(get(h.fcheck,'value'));
    end
    [scale_exist scale_index]=sort(scaleax,'descend');                      %%_exist shows existence of a scale, _index shows which axis
    [o order]=sort(order);
    data_transformed=data_scaled;                                           %%Create transform matrix for flips and ordering
    labels(o)=labels(order');                                               %%Ensure labels are in correct order
    unitm(o)=unitm(order');
    flip=find(flip==1);                                                     %%Get positions of flipped axes
    h.plotraw=findobj('-regexp','tag','plotraw');
    plotraw=get(h.plotraw,'value');                                         %%plotraw value
    data_transformed(:,flip)=-data_scaled(:,flip);
    data_transformed(:,o)=data_transformed(:,order');                       %%Flip and change axes order
    if plotraw == 1                                                         %%If raw data is selected then plot it first
        figure(h.f);                                                        %%NOTEDIT: Unsure which 'figure(h.f)' are necessary
        plot(data_transformed','b');
        figure(h.f);
        hold on
    end
    numgrps=getappdata(pcpnew,'numgrps');
    if numgrps > 0                                                          %%If groups exist
        groupspec_num=getappdata(pcpnew,'groupspec_num');                   %%Get the group specs
        groupspec_rank=getappdata(pcpnew,'groupspec_rank');
        rangerank=getappdata(pcpnew,'rangerank');
        for i = 1 : numgrps
            h.hgroup=findobj('-regexp','tag',[num2str(i) 'hgroup']);
            hidden=get(h.hgroup,'value');
            if hidden == 0                                                  %%If group not hidden
                h.lsgroup=findobj('tag',[num2str(i) 'lsgroup']);            %%Get line style
                styl=get(h.lsgroup,'value');
                styl=styletypes{styl};
                h.lwgroup=findobj('tag',[num2str(i) 'lwgroup']);            %%Get linewidth
                wid=get(h.lwgroup,'value');
                wid=widtypes(wid);
                h.csgroup=findobj('tag',[num2str(i) 'csgroup']);            %%Get colour info
                col=get(h.csgroup,'BackgroundColor');
                if rangerank(i)==1
                    JN=sum((groupspec_num(:,:,i)),2);
                    JN=find(JN==(dimnum)*2);                                %%Find the data rows (polylines) which have met all specifications
                elseif rangerank(i)==0
                    JN=groupspec_rank(:,i);
                    JN(JN==0)=[];                                           %%Find all members of rank group
                end
                if isempty(JN)                                              %%If group is empty, throw error
                    h.errer=findobj('-regexp','tag','errer');
                    set(h.errer,'string',['Warning: Group ' num2str(i) ' is empty '],'ForegroundColor',[1 0 0]);
                    pause(5);
                    set(h.errer,'string','');
                else
                    figure(h.f);
                    h.tsgroup=findobj('-regexp','tag',[num2str(i) 'tsgroup']);
                    trans=get(h.tsgroup,'value');                           %%Get envelope transparency
                    if trans == 0                                           %%If no transparency just plot group lines
                        plot((data_transformed(JN,:))','Color',col,'LineStyle',styl,'LineWidth',wid);
                        hold on
                    else
                        if length(JN) ==1                                   %%If single members flag up error
                            h.errer=findobj('-regexp','tag','errer');
                            set(h.errer,'string',['Warning: Group ' num2str(i) ' does not contain enough data for envelopes'],'ForegroundColor',[1 0 0]);
                            pause(5);
                            set(h.errer,'string','');
                        else
                            a=max(data_transformed(JN,:));
                            b=min(data_transformed(JN,:));
                            X=[o,fliplr(o)];
                            Y=[a,fliplr(b)];
                            h.ag=fill(X,Y,col,'facealpha',trans);           %%Create envelope of group and plot area
                            hold on
                        end
                    end
                    JN=[];
                end
            end
        end
    end
    num_clus=getappdata(pcpnew,'num_clus');
    if num_clus >0
        h.kmedoid=findobj('tag','kmedoid');
        med=get(h.kmedoid,'value');
        if med ==0                                                          %%Check kmedoid/kmeans toggle and get appropriate cluster members
            IDX=getappdata(pcpnew,'IDX');
        elseif med==1
            IDX=getappdata(pcpnew,'medIDX');
        end
        for i = 1 : num_clus
            h.hclus=findobj('-regexp','tag',[num2str(i) 'hclus']);
            if get(h.hclus,'value')==0
                h.csclus=findobj('-regexp','tag',[num2str(i) 'csclus']);    %%Get colour info
                col=get(h.csclus,'BackgroundColor');
                h.lsclus=findobj('-regexp','tag',[num2str(i) 'lsclus']);    %%Get line style
                styl=get(h.lsclus,'value');
                styl=styletypes{styl};
                h.lwclus=findobj('-regexp','tag',[num2str(i) 'lwclus']);    %%Get linewidth
                wid=get(h.lwclus,'value');
                wid=widtypes(wid);
                h.nrclus=findobj('-regexp','tag',[num2str(i) 'nrclus']);    %%Get noise reduction toggle
                nr=get(h.nrclus,'value');
                h.tsclus=findobj('-regexp','tag',[num2str(i) 'tsclus']);
                trans=get(h.tsclus,'value');                                %%Get transparency value for envelope
                if nr == 1                                                  %%Find UQ/LQ
                    UQ=prctile(data_scaled((IDX==i),:),75);
                    LQ=prctile(data_scaled((IDX==i),:),25);
                    for j = 1 : mlength
                        if IDX(j)==i
                            for k = 1 : dimnum
                                if data_scaled(j,k)>UQ(k)||data_scaled(j,k)<LQ(k)%%Eliminate data outside UQ/LQ
                                    IDX(j)=0;
                                end
                            end
                        end
                    end
                    if isempty(IDX==i)                                      %%If noise reduction has eliminated all data from a cluster flag warning
                        h.errer=findobj('-regexp','tag','errer');
                        set(h.errer,'string','Warning: Cluster empty due to noise reduction','ForegroundColor',[1 0 0]);
                        pause(5);
                        set(h.errer,'string','');
                        figure(h.f)
                    else
                        figure(h.f)                                         %%Otherwise plot members within UQ/LQ for all dimensions according to linespec
                        plot((data_transformed((IDX==i),:))','color',col,'LineStyle',styl,'LineWidth',wid);
                    end
                    UQ(:,flip)=-UQ(:,flip);                                 %%Transform envelopes
                    UQ(:,o)=UQ(:,order');
                    LQ(:,flip)=-LQ(:,flip);
                    LQ(:,o)=LQ(:,order');
                    hold on
                    if trans == 0                                           %%If 0, plot solid and bold
                        plot(UQ,'color',col,'LineStyle','-','LineWidth',wid+2);
                        plot(LQ,'color',col,'LineStyle','-','LineWidth',wid+2);
                    else
                        A=[o,fliplr(o)];
                        B=[UQ,fliplr(LQ)];
                        h.ac=fill(A,B,col,'facealpha',trans);               %%If not, plot envelope
                    end
                else
                    figure(h.f)                                             %%Without noise reduction
                    if trans == 0                                           %%If 0, plot according to linespec
                        plot((data_transformed((IDX==i),:))','color',col,'LineStyle',styl,'LineWidth',wid);
                    else
                        c=max(data_transformed((IDX==i),:));
                        d=min(data_transformed((IDX==i),:));
                        A=[o,fliplr(o)];
                        B=[c,fliplr(d)];
                        h.ac=fill(A,B,col,'facealpha',trans);               %%If not, plot envelope
                    end
                    hold on
                end
            end
        end
    end
    figure(h.f);
    xlim([1 dimnum]);
    set(h.axes,'XTick',1:1:dimnum,'tag','axes');
    set(h.axes,'XTickLabel',labels','XAxisLocation','bottom','XGrid','on'); %%Label Xaxes
    misc_axes=copyobj(h.axes,h.f);
    set(misc_axes,'XAxisLocation','top','XTicklabel',unitm,'YTickLabel',[]);
    set(misc_axes,'Tag','misc_axes');
    if scale_exist(1)==0                                                    %%If a scale for the axes has been selected scale axes appropriately
        if isempty(flip)
            set(h.axes,'YTickLabel',0:10:100);
        else
            e=0:20:100;
            f=100:-20:20;
            g=[f,e];
            set(h.axes,'YTickLabel',g);
        end
        ylabel('Normalised (%)');
    else
        data_raw=getappdata(pcpnew,'data_raw');
        Maxy=max(data_raw(:,scale_index(1)));
        Miny=min(data_raw(:,scale_index(1)));
        if isempty(flip)
            set(h.axes,'YTickLabel',Miny:(Maxy-Miny)/10:Maxy);              %%Y axis are instead plotted with raw data values if scale selected
        else
            e=Miny:(Maxy-Miny)/5:Maxy;
            f=Maxy:-(Maxy-Miny)/5:(Miny+(Maxy-Miny)/5);
            g=[f,e];
            set(h.axes,'YTickLabel',g);
        end
        figure(h.f);
        h.ledit=findobj('tag',[num2str(scale_index(1)) 'ledit']);
        dim_scaleax=get(h.ledit,'string');
        h.uedit=findobj('Tag',[num2str(scale_index(1)) 'uedit']);
        unite=get(h.uedit,'string');
        ylabel([dim_scaleax ' (' unite ')']);     %%Label Yaxis appropriately
    end
    figure(h.f)
    hold off
    set(h.errer,'string','');h.uedit=findobj('Tag',[num2str(i+1) 'uedit']);
end

% --- Executes on button press in out_data.
% Summary: Export group/cluster data to excel file
% Description:
%%%% -Retrieves relevent appdata
%%%% -For clusters, two labelled cell arrays are created
%%%% -For each cluster:
%%%%%%%% --The names of each member of data_scaled in the cluster are input
%%%%%%%% into one matrix
%%%%%%%% --The standard deviation, average distance to centroid and centroid
%%%%%%%% location are entered into the other
%%%% -If no clusters exist, message input into the matrices instead
%%%% -For each group:
%%%%%%%% --The members of data_scaled are extracted from its groupspec
%%%%%%%% --The names of each member are input into a cell array
%%%% =If no groups exist, message input into the matrix instead
%%%% -Cell arrays are input into different sheets of an excel file          %%Load dataseet
function out_data_Callback(emptyvar1, emptyvar2, emptyvar3)
IDX=getappdata(pcpnew,'IDX');                                               %%Get all the data to export
data_scaled=getappdata(pcpnew,'data_scaled');
C=getappdata(pcpnew,'C');
sumd=getappdata(pcpnew,'sumd');
[mlength,dimnum]=size(data_scaled);                                         %%Create dimensions
names=getappdata(pcpnew,'datanames');
num_clus=getappdata(pcpnew,'num_clus');
rangerank=getappdata(pcpnew,'rangerank');
groupspec_rank=getappdata(pcpnew,'groupspec_rank');
if num_clus > 0 && length(IDX)==mlength                                     %%Cluster data, IDX check is in case a new dataset has been reloaded
    A=cell(mlength+1,num_clus);
    B=cell((3+dimnum),num_clus+1);                                          %%Set headings
    B(2,1)={'std'};
    B(3,1)={'Average dist. to centroid'};
    B(4,1)={'Centroid Location'};
    for i = 1 : num_clus
        A(1,i)={['Cluster ' num2str(i) ' members']};                        %%Set out cluster labels
        A((2:length(find(IDX==i))+1),i)=names((IDX==i));                    %%Assign names from 'datanames' to clusters
        B(1,i+1)={['Cluster ' num2str(i) ' data']};
        B(3,i+1)=num2cell(sumd(i,:)/length((IDX==i)));                      %%Present other cluster data, std, average dist to centroid
        B(2,i+1)=num2cell(std(data_scaled((IDX==i))));
        B((4:dimnum+3),i+1)=num2cell(C(i,:)');                              %%Centroid locations
    end
else
    A={'No Clusters Exist'};
    B=A;
end
groupspec_num=getappdata(pcpnew,'groupspec_num');                           %%Group data
numgrps=getappdata(pcpnew,'numgrps');
D=cell(mlength+1,numgrps);
if numgrps > 0                                                              %%Group data
    for i = 1 : numgrps
        h.ngroup=findobj('tag',[num2str(i) 'ngroup']);
        gname=get(h.ngroup,'string');
        D(1,i)={['Group <' gname '> members']};                             %%Set headings
        if rangerank(i) == 1                                                %%Ensure different formats for range/rank are handled correctly
            JN=sum(groupspec_num(:,:,i),2);
            D((2:length(find(JN==dimnum*2))+1),i)=names((find(JN==dimnum*2))); %%Assign names from 'datanames' to groups
        else
            JN=groupspec_rank(:,i);
            JN(JN==0)=[];
            D((2:(length(JN)+1)),i)=names(JN);
        end
    end
else
    D={'No Groups Exist'};
end
[filename, pathname] = uiputfile({'*.xls';'*.txt'},'pick text file');       %%Find location of where user wants to put file
if pathname ==0
else
fullname = fullfile(pathname,filename);
if isempty(regexp(filename,'.txt','ONCE'))
    xlswrite(fullname, A, 1);                                                   %%Save to xls
    xlswrite(fullname, B, 2);
    xlswrite(fullname, D, 3);
else
    num_char=regexp(fullname,'.txt');
    Aname=fullname;
    Bname=fullname;
    Dname=fullname;
    Aname(num_char:num_char+1)='C1';
    Aname(num_char+2:num_char+5)='.txt';
    Bname(num_char:num_char+1)='C2';
    Bname(num_char+2:num_char+5)='.txt';
    Dname(num_char:num_char+1)='G1';
    Dname(num_char+2:num_char+5)='.txt';
    dlmcell(Aname,A);
    dlmcell(Bname,B);
    dlmcell(Dname,D);
end
end

% --- Executes on button press in fdata.
% Summary: Removes filtered data from dataset
% Description:
%%%% -Gets appdata and information from uicontrols
%%%% -Opens 'Filter.m' and creates table to allow specification to be
%%%% filtered
function fdata_Callback(emptyvar1, emptyvar2, emptyvar3)
dimnum=getappdata(pcpnew,'dimnum');
labels=cell(dimnum,1);
for i = 1 : dimnum                                                          %%Find labels
    h.ledit=findobj('Tag',[num2str(i) 'ledit']);
    labels(i,:)={get(h.ledit,'string')};
end
M=cell(dimnum,2);                                                           %%New group's specification
M(:,:)={'Not Specified'};
Figg2=Filter;                                                               %%start up 'Filter' and create specification table
h.ftable=uitable(Figg2,'data',M,'ColumnEditable',[true, true],'ColumnName',{'Less than %','Greater than %'},'Tag','Fspec','rowname',labels,'units','pixels','position',[27,25,500,313]);

% --- Executes on button press in rdata.
% Summary: Returns original dataset
% Description:
%%%% -Gets backup appdata, this is scaled and then reset
%%%% -Default group and cluster information reset
%%%% -Current group and cluster buttons deleted
function rdata_Callback(emptyvar1, emptyvar2, emptyvar3)
data_raw=getappdata(pcpnew,'Abackup');                                      %%Get backed up raw data
datanames=getappdata(pcpnew,'datanamesbackup');                             %%And backed up data names
data_scaled=scaletominmax(data_raw);                                        %%Reset appdata to defaults
setappdata(pcpnew,'data_raw',data_raw);
setappdata(pcpnew,'data_scaled',data_scaled);
setappdata(pcpnew,'datanames',datanames);
[mlength,dimnum]=size(data_raw);
groupspec_str=cell(dimnum,2);
groupspec_str(:,:,1)={'Not Specified'};
setappdata(pcpnew,'groupspec_str',groupspec_str);
groupspec_num(:,:,1)=zeros(mlength,(dimnum*2));
setappdata(pcpnew,'groupspec_num',groupspec_num);
groupspec_rank=nan(mlength,1);
setappdata(pcpnew,'groupspec_rank',groupspec_rank);
rangerank=0;
setappdata(pcpnew,'rangerank',rangerank);
numgrps=getappdata(pcpnew,'numgrps');
for a = 1 : numgrps                                                         %%Delete group controls
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
numgrps=0;                                                                  %%Set more defaults
setappdata(pcpnew,'numgrps',numgrps);
num_clus=getappdata(pcpnew,'num_clus');
for i = 1: num_clus                                                         %%Delete cluster controls
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
setappdata(pcpnew,'num_clus',num_clus);                                     %%Set more defaults
h.selnum_clus=findobj('-regexp','tag','selnum_clus');
set(h.selnum_clus,'value',1);

% --- Function called by use of datacursor on figure
% Summary: Allows presentation of member's name when clicking on polyline
% Description:
%%%% -Matches the selected polyline to its data and outputs related name
function output_txt = dispnames(emptyvar1,event_obj,data_transformed,datanames)  %%Finds and matches nam from datanames
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
targ = get(event_obj,'Target');                                             %%Get polyline handle
coords=get(targ,'YData');                                                   %%Get polyline values
[emptyvar1,num]=ismember(coords,data_transformed,'rows');                        %%Find which member
nam=datanames(num);                                                         %%Get name
pos = get(event_obj,'Position');                                            %%Get pointer coordinates
output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)], ['Name: ' nam{1}]};                          %%Display coordinates and text

% --- Executes on button press in denplot.
% Summary: Plots a density plot to a new figure
% Description:
%%%% -Gets relevent settings from uicontrols
%%%% -Calls contourtest.m function to convert to density matrix and plots
%%%% -Creates an error message if non numeric resolutions
function denplot_Callback(emptyvar1, emptyvar2, emptyvar3)
h.errer=findobj('-regexp','tag','errer');                                   %%Update user on progress
set(h.errer,'string','Please wait for calculation','ForegroundColor',[0 1 0]);
h.cancelcalc=findobj('tag','cancelcalc');
h.xres=findobj('tag','xres');                                               %%Get plot settings
h.yres=findobj('tag','yres');
h.dlog=findobj('tag','dlog');
XRes=str2double(get(h.xres,'string'));
YRes=str2double(get(h.yres,'string'));
dlog=get(h.dlog,'value');
if isnan(XRes) || isnan (YRes)                                              %%If format flag error
    set(h.errer,'string','Warning: Non numeric resolution selected','ForegroundColor',[1 0 0]);
    pause(5);
    set(h.errer,'string','');
else
    data_scaled=getappdata(pcpnew,'data_scaled');
    [emptyvar1,dimnum]=size(data_scaled);
    labels=cell(1,dimnum);                                                  %%Preallocate axis variables
    unitm=labels;
    order=NaN(dimnum,1);
    flip=order;
    scaleax=order;
    for i = 1 : dimnum                                                      %%Find/set labels/units/order/flips/scale
        h.ledit=findobj('tag',[num2str(i) 'ledit']);
        labels{i}=get(h.ledit,'string');
        order(i,1)=str2double(get(findobj('tag',[num2str(i) 'ostring']),'string'));
        flip(i,1)=get(findobj('tag',[num2str(i) 'fcheck']),'value');
        unitm(i)={get(findobj('tag',[num2str(i) 'uedit']),'string')};
        h.sradio=findobj('tag',[num2str(i) 'sradio']);
        scaleax(i)=get(h.sradio,'value');
    end
    [scale_exist scale_index]=sort(scaleax,'descend');
    [o order]=sort(order);
    data_transformed=data_scaled;                                           %%Create transform matrix for flips and ordering
    labels(o)=labels(order');
    flip=find(flip==1);
    data_transformed(:,flip)=-data_scaled(:,flip);
    data_transformed(:,o)=data_transformed(:,order');
    L=contourtest(data_transformed,XRes,YRes,h);                            %%See contourtest for details on L
    set(h.errer,'string','');
    h.f=figure;                                                             %%Create figure
    if dlog==1
        imagesc(log(L));                                                    %%If log plot is selected, ploy log
        h.axes=gca;
    else
        imagesc(L);                                                         %%Else normal plot
        h.axes=gca;
    end
    mat=[1,XRes:XRes:XRes*(dimnum-1)];                                      %%Create correct format ticks (different to plot in imagesc)
    set(h.axes,'XTick',mat);
    set(h.axes,'XTickLabel',labels');                                       %%Set xaxes ticks and labels
    if scale_exist(1)==0                                                    %%Set yaxis ticks and labels appropriately
        if isempty(flip)
            set(h.axes,'YTick',[1,YRes/10:YRes/10:YRes]);
            set(h.axes,'YTickLabel',100:-10:0);
        else
            set(h.axes,'YTick',[1,YRes/5:YRes/5:YRes*2]);
            set(h.axes,'YTicklabel',[100:-20:0,20:20:100]);
        end
        ylabel('Normalised (%)');
    else
        data_raw=getappdata(pcpnew,'data_raw');
        figure(h.f);
        Maxy=max(data_raw(:,scale_index(1)));
        Miny=min(data_raw(:,scale_index(1)));
        if isempty(flip)
            set(h.axes,'YTick',[1,YRes/10:YRes/10:YRes]);
            set(h.axes,'YTickLabel',Maxy:-(Maxy-Miny)/10:Miny);
        else
            set(h.axes,'YTick',[1,YRes/5:YRes/5:YRes*2]);
            e=Miny:(Maxy-Miny)/5:Maxy;
            f=Maxy:-(Maxy-Miny)/5:(Miny+(Maxy-Miny)/5);
            g=[f,e];
            set(h.axes,'YTickLabel',g);
        end
        h.ledit=findobj('tag',[num2str(scale_index(1)) 'ledit']);
        dim_scaleax=get(h.ledit,'string');
        ylabel([dim_scaleax ' (' cell2mat(unitm(scale_index(1))) ')']);
    end
end

% --- Executes on button press in cancelcalc
% Summary: Cancels lengthy calculations when pressed
% Description:
%%%% -Sets button userdata to 1
%%%% -This is picked up by the calculations and breaks the loop
function cancelcalc_Callback (emptyvar1, emptyvar2, emptyvar3)
set(gcbo,'userdata',1);



%%%%%%%%%%%%%%%%%%%
%%% State Functions
%%%%%%%%%%%%%%%%%%%


function lstate_Callback(emptyvar1,emptyvar2,emptyvar3)
[fileName,pathname]=uigetfile('*.mat','Select .mat file');                  %%Select file
if pathname == 0
else
    dimnum=getappdata(pcpnew,'dimnum');
    for i = 1 : dimnum
        h.ledit=findobj('tag',[num2str(i) 'ledit']);
        h.uedit=findobj('tag',[num2str(i) 'uedit']);
        h.ostring=findobj('tag',[num2str(i) 'ostring']);
        h.o1but=findobj('tag',[num2str(i) 'o1but']);
        h.o2but=findobj('tag',[num2str(i) 'o2but']);
        h.fcheck=findobj('tag',[num2str(i) 'fcheck']);
        h.sradio=findobj('tag',[num2str(i) 'sradio']);
        h.rdbut=findobj('tag',[num2str(i) 'rdbut']);
        delete(h.ledit,h.uedit,h.ostring,h.o1but,h.o2but,h.fcheck,h.sradio,h.rdbut);
    end
    num_clus=getappdata(pcpnew,'num_clus');
    for i = 1: num_clus                                                     %%All buttons are deleted
        h.cnum=findobj('-regexp','tag',[num2str(i) 'nclus']);
        h.ccolset=findobj('-regexp','tag',[num2str(i) 'csclus']);
        h.chide=findobj('-regexp','tag',[num2str(i) 'hclus']);
        h.ctrans=findobj('-regexp','tag',[num2str(i) 'tsclus']);
        h.cnoise=findobj('-regexp','tag',[num2str(i) 'nrclus']);
        h.csline=findobj('-regexp','tag',[num2str(i) 'lsclus']);
        h.cwline=findobj('-regexp','tag',[num2str(i) 'lwclus']);
        delete(h.cnum,h.ccolset,h.chide,h.ctrans,h.cnoise,h.csline,h.cwline);
    end
    numgrps=getappdata(pcpnew,'numgrps');
    for a = 1 : numgrps
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
    load (fullfile(pathname,fileName));
    setappdata(pcpnew,'C',C);
    setappdata(pcpnew,'IDX',IDX);
    setappdata(pcpnew,'data_raw',data_raw);
    setappdata(pcpnew,'data_scaled',data_scaled);
    setappdata(pcpnew,'datanames',datanames);
    setappdata(pcpnew,'dimnum',dimnum);
    setappdata(pcpnew,'groupspec_num',groupspec_num);
    setappdata(pcpnew,'groupspec_str',groupspec_str);
    setappdata(pcpnew,'groupspec_rank',groupspec_rank);
    setappdata(pcpnew,'num_clus',num_clus);
    setappdata(pcpnew,'numgrps',numgrps);
    setappdata(pcpnew,'rangerank',rangerank);
    setappdata(pcpnew,'sumd',sumd);
    set(findobj('tag','plotraw'),'value',plotraw);
    set(findobj('tag','maxmin'),'value',maxmin);
    set(findobj('tag','datalabel'),'string',datalabel);
    set(findobj('tag','selnum_clus'),'value',num_clus);
    set(findobj('tag','kmedoid'),'value',kmedoid);
   for i = 0 : dimnum-1                                                    %%Create axes controls and callbacks
        h.ledit=uicontrol('style','edit','units','pixels','position',[19,(460-i*23),97,22],'string',labels{i+1},'tag',[num2str(i+1) 'ledit']);
        h.uedit=uicontrol('style','edit','units','pixels','position',[123,(460-i*23),51,22],'string',unitm{i+1},'tag',[num2str(i+1) 'uedit']);
        h.ostring=uicontrol('style','text','units','pixels','position',[202,(458-i*23),18,22],'string',num2str(order(i+1)),'tag',[num2str(i+1) 'ostring']);
        h.o1but=uicontrol('style','pushbutton','units','pixels','position',[182,(460-i*23),18,22],'string','+','Callback',{'o1but_callback',i+1},'tag',[num2str(i+1) 'o1but'],'interruptible','off');
        h.o2but=uicontrol('style','pushbutton','units','pixels','position',[222,(460-i*23),18,22],'string','-','Callback',{'o2but_callback',i+1},'tag',[num2str(i+1) 'o2but'],'interruptible','off');
        h.fcheck=uicontrol('style','check','units','pixels','position',[247,(460-i*23),18,22],'tag',[num2str(i+1) 'fcheck'],'value',flip(i+1));
        h.sradio=uicontrol('style','radiobutton','units','pixels','position',[300,(458-i*23),18,22],'tag',[num2str(i+1) 'sradio'],'value',scaleax(i+1));
        h.rdbut=uicontrol('style','pushbutton','units','pixels','position',[375, (460-i*23),18,22],'tag',[num2str(i+1) 'rdbut']);
        set(h.o1but,'callback',{@changeorderstring1,(i+1)},'interruptible','off');
        set(h.o2but,'callback',{@changeorderstring2,(i+1)},'interruptible','off');
        set(h.sradio,'callback',{@sel_scaleunits,(i+1)},'interruptible','off');
        set(h.rdbut,'callback',{@rdbut_callback,(i+1)},'interruptible','off');
   end
   for i = 1 : num_clus                                                    %%Cluster controls are recreated to the selected number of clusters
       h.cnum=uicontrol('style','text','string',num2str(i),'units','pixels','position',[465,196-(i-1)*23,77,14],'tag',[num2str(i) 'nclus']);
       h.ccolset=uicontrol('style','pushbutton','units','pixels','position',[549,194-(i-1)*23,22,22],'tag',[num2str(i) 'csclus'],'BackgroundColor',ccol(i,:));
       h.chide=uicontrol('style','checkbox','units','pixels','position',[637,194-(i-1)*23,22,22],'tag',[num2str(i) 'hclus'],'value',chid(i));
       h.ctrans=uicontrol('style','slider','units','pixels','position',[686,194-(i-1)*23,110,17],'tag',[num2str(i) 'tsclus'],'value',ctrans(i));
       h.cnoise=uicontrol('style','checkbox','units','pixels','position',[828,194-(i-1)*23,22,22],'tag',[num2str(i) 'nrclus'],'value',cnr(i));
       h.clines=uicontrol('style','popupmenu','units','pixels','position',[882,194-(i-1)*23,70,22],'tag',[num2str(i) 'lsclus'],'string',{'dot','dash-dot','dash','solid'},'value',cstyl(i));
       h.clinew=uicontrol('style','popupmenu','units','pixels','position',[957,194-(i-1)*23,40,22],'tag',[num2str(i) 'lwclus'],'string',{'0.5','1.0','2.0','3.0','4.0','5.0','6.0','7.0','8.0','9.0','10.0','12.0'},'value',cwid(i));
       set(h.ccolset,'callback',{@clus_colsel,i},'interruptible','off');
   end
   for i = 1 : numgrps
       h.gnamem=uicontrol('style','text','units','pixels','position',[454,400-(i-1)*23,52,15],'string',num2str(i),'tag',[num2str(i) 'ngroup']);%%Needs position dep numgrp
       h.gedit=uicontrol('style','pushbutton','units','pixels','position',[535,400-(i-1)*23,22,22],'tag',[num2str(i) 'egroup']);
       h.ghide=uicontrol('style','checkbox','units','pixels','position', [579,400-(i-1)*23,22,22],'tag',[num2str(i) 'hgroup'],'value',ghid(i));
       h.gcolset=uicontrol('style','pushbutton','units','pixels','position',[639,400-(i-1)*23,22,22],'tag',[num2str(i) 'csgroup'],'BackgroundColor',gcol(i,:));
       h.gtrans=uicontrol('style','slider','units','pixels','position',[710,400-(i-1)*23,110,17],'tag',[num2str(i) 'tsgroup'],'value',gtrans(i));
       h.gremove=uicontrol('style','pushbutton','units','pixels','position',[852,400-(i-1)*23,22,22],'tag',[num2str(i) 'rgroup']);
       h.glines=uicontrol('style','popupmenu','units','pixels','position',[892,400-(i-1)*23,70,22],'tag',[num2str(i) 'lsgroup'],'string',{'dot','dash-dot','dash','solid'},'value',gstyl(i));
       h.glinew=uicontrol('style','popupmenu','units','pixels','position',[967,400-(i-1)*23,40,22],'tag',[num2str(i) 'lwgroup'],'string',{'0.5','1.0','2.0','3.0','4.0','5.0','6.0','7.0','8.0','9.0','10.0','12.0'},'value',gwid(i));
       set(h.gremove,'callback',{@removegroup,i},'interruptible','off');                           %%Set new control callbacks and their associated group (numgrps)
       set(h.gcolset,'callback',{@colourselect,i},'interruptible','off');                          %%Note group number is called as 'a' in the callbacks
       set(h.gedit,'callback',{@editgroup,i},'interruptible','off');
   end
   h.cluspn=findobj('-regexp','tag','cluspan');                            %%Allow interaction with remaining interface
   set(h.cluspn,'visible','on');
   h.groppn=findobj('-regexp','tag','groppan');
   set(h.groppn,'visible','on');
   h.outpn=findobj('-regexp','tag','outpan');
   set(h.outpn,'visible','on');
   h.opo=findobj('-regexp','tag','opt_order');
   set(h.opo,'visible','on');
   h.browsl=findobj('-regexp','tag','browse_lab');
   set(h.browsl,'visible','on');
   h.browsa=findobj('-regexp','tag','browse_units');
   set(h.browsa,'visible','on');
   h.browsn=findobj('-regexp','tag','browse_names');
   set(h.browsn,'visible','on');
   h.plotrw=findobj('-regexp','tag','plotraw');
   set(h.plotrw,'visible','on');
   h.filpanel=findobj('-regexp','tag','filpanel');
   set(h.filpanel,'visible','on');
   h.denpanel=findobj('tag','denpanel');
   set(h.denpanel,'visible','on');
   h.maxmin=findobj('tag','maxmin');
   set(h.maxmin,'visible','on');
   h.sstate=findobj('tag','sstate');
   set(h.sstate,'visible','on');
end


function sstate_Callback(emptyvar1,emptyvar2,emptyvar3)
[filename, pathname] = uiputfile({'*.mat'},'pick mat file');       %%Find location of where user wants to put file
if pathname ==0
else
handles=getappdata(pcpnew);
dimnum=handles.dimnum;
labels=cell(1,dimnum);                                                  %%Preallocate axis variables
unitm=labels;
order=NaN(dimnum,1);
flip=order;
scaleax=order;
h.plotraw=findobj('tag','plotraw');
h.maxmin=findobj('tag','maxmin');
h.datalabel=findobj('tag','datalabel');
h.kmedoid=findobj('tag','kmedoid');
handles.kmedoid=get(h.kmedoid,'value');
handles.plotraw=get(h.plotraw,'value');
handles.maxmin=get(h.maxmin,'value');
handles.datalabel=get(h.datalabel,'string');
for i = 1 : dimnum                                                      %%Find/set labels/units/order/flips/scale
    h.ledit=findobj('tag',[num2str(i) 'ledit']);
    labels{i}=get(h.ledit,'string');
    order(i,1)=str2double(get(findobj('tag',[num2str(i) 'ostring']),'string'));
    flip(i,1)=get(findobj('tag',[num2str(i) 'fcheck']),'value');
    unitm(i)={get(findobj('tag',[num2str(i) 'uedit']),'string')};
    h.sradio=findobj('tag',[num2str(i) 'sradio']);
    scaleax(i)=get(h.sradio,'value');
end
handles.labels=labels;
handles.order=order;
handles.flip=flip;
handles.unitm=unitm;
handles.scaleax=scaleax;
num_clus=handles.num_clus;
chid=NaN(1,num_clus);
ccol=[chid' chid' chid'];
cstyl=chid;
cwid=chid;
cnr=chid;
ctrans=chid;
for i = 1 : num_clus
    h.hclus=findobj('-regexp','tag',[num2str(i) 'hclus']);
    chid(i)=get(h.hclus,'value');
    h.csclus=findobj('-regexp','tag',[num2str(i) 'csclus']);    %%Get colour info
    ccol(i,:)=get(h.csclus,'BackgroundColor');
    h.lsclus=findobj('-regexp','tag',[num2str(i) 'lsclus']);    %%Get line style
    cstyl(i)=get(h.lsclus,'value');
    h.lwclus=findobj('-regexp','tag',[num2str(i) 'lwclus']);    %%Get linewidth
    cwid(i)=get(h.lwclus,'value');
    h.nrclus=findobj('-regexp','tag',[num2str(i) 'nrclus']);    %%Get noise reduction toggle
    cnr(i)=get(h.nrclus,'value');
    h.tsclus=findobj('-regexp','tag',[num2str(i) 'tsclus']);
    ctrans(i)=get(h.tsclus,'value');
end
handles.chid=chid;
handles.ccol=ccol;
handles.cstyl=cstyl;
handles.cwid=cwid;
handles.cnr=cnr;
handles.ctrans=ctrans;
numgrps=handles.numgrps;
ghid=NaN(1,numgrps);
gcol=[ghid' ghid' ghid'];
gstyl=ghid;
gwid=ghid;
gtrans=ghid;
for i = 1 : numgrps
    h.hgroup=findobj('-regexp','tag',[num2str(i) 'hgroup']);
    ghid(i)=get(h.hgroup,'value');
    h.lsgroup=findobj('tag',[num2str(i) 'lsgroup']);            %%Get line style
    gstyl(i)=get(h.lsgroup,'value');
    h.lwgroup=findobj('tag',[num2str(i) 'lwgroup']);            %%Get linewidth
    gwid(i)=get(h.lwgroup,'value');
    h.csgroup=findobj('tag',[num2str(i) 'csgroup']);            %%Get colour info
    gcol(i,:)=get(h.csgroup,'BackgroundColor');
    h.tsgroup=findobj('tag',[num2str(i) 'tsgroup']);
    gtrans(i)=get(h.tsgroup,'value');                           %%Get envelope transparency
end
handles.ghid=ghid;
handles.gcol=gcol;
handles.gstyl=gstyl;
handles.gwid=gwid;
handles.gtrans=gtrans;
fullname = fullfile(pathname,filename);
save(fullname, '-struct', 'handles');
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculation Functions
%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Called by denplot
% Summary: Creates a matrix of pixel densities based on a plot of AN
% Description:
%%%% -Gets passed relevent parameters and handles
%%%% -Interpolates lines joining AN values
%%%% -Runs over whole plot to sort AN values into bins in densities
%%%% =Updates progress on error display
function La = contourtest(AN,XRes,YRes,h)
set(h.cancelcalc,'userdata',0);
[mlength,dimnum]=size(AN);                                                  %%Get relevent dimensions/bins
Nbins=(dimnum-1)*XRes;
if min(min(AN))<0                                                           %%If plot has a flipped members
    YResa=YRes;                                                             %%Create appropriate versions of resolution
    YResb=YRes;
    YRes=YRes*2;
else
    YResa=0;                                                                %%Create appropriate versions of resolutions
    YResb=YRes;
end
La=zeros(YRes,Nbins);                                                       %%La will be a image matrix over YRes/Nbins pixels
L=zeros(mlength,Nbins);                                                     %%L will be a PCP matrix containing the same information as AN, but with more detail
for i = 1 : mlength                                                         %%For all members in L
    for k = 1 : dimnum-1
        for j = 1 : XRes
            L(i,(k-1)*XRes+j)=AN(i,k)-(AN(i,k)-AN(i,k+1))*(j-1)/XRes;           %%Interpolate between values of AN to find intermediate values
        end
    end
end                                                                         %%Plotting L (or L'?) will now look the same as plotting AN'
for i = 1:Nbins    
    for j = 1:YRes                                                          %%Over every pixel in the whole image matrix
        for k = 1 : mlength
            if L(k,i)>((j-YResa)/YResb-1/YResb)
                if L(k,i)<((j-YResa)/YResb+1/YResb)
                    La(j,i)=La(j,i)+1;                                          %%If a value of L lies within a pixel then increase density of that pixel
                end
            end
        end
    end
    set(h.errer,'string',['Please wait for calculation ' num2str(ceil(i*100/Nbins)) '% Complete'],'ForegroundColor',[0 1 0]);
    pause(0.0001);                                                          %%Update error display on progress
    if get(h.cancelcalc,'userdata')
        set(h.cancelcalc,'userdata',0);
        break
    end
end
La=flipud(La);                                                              %%Transform appropriately

% --- Called by optnum_clus
% Summary: Creates a graph of number of clusters vs spread based on kmeans
% Description:
%%%% -For m iterations, perform a kmeans test from 1 : 7 clusters
%%%% -Plot the number of clusters versus the average distance to centroid
%%%% -Update progress in error display panel
function kmeanstest(AN,h)
h.nf=figure;                                                                %%Create Figure
set(h.cancelcalc,'userdata',0);
for m = 1 : 50                                                              %%For 50 iterations
    for i = 1 : 7                                                           %%For 1 : 7 clusters
        [IDX,C,sumd]=kmeans(AN,i);                                          %%Perform kmeans test
        for j = 1 : i
            S=size(find(IDX==j));                                           %%Count number of members in each cluster
            num(j,:)=S(1);
        end
        dist(i)=mean(sumd./num);                                            %%Average distance for members of all clusters
    end
    figure(h.nf);
    plot(dist(:),'color',[rand rand rand]);                                 %%Plot distances
    xlabel('Number of Clusters');                                           %%Label appropriately
    ylabel('Avg dist to centroid for all clusters');
    hold on
    num=[];
    sumd=[];
    IDX=[];
    set(h.errer,'string',['Please wait for calculation ' num2str(m*2) '% Complete'],'ForegroundColor',[0 1 0]);
    pause(0.0001);                                                          %%Update progress
    if get(h.cancelcalc,'userdata')
        set(h.cancelcalc,'userdata',0);
        break
    end
end
set(h.errer,'string','');
uicontrol('parent',h.nf,'style','text','string','Select the amount of clusters at the point where no additional clusters will alter centroid distances significantly','units','normalized','position',[0 0.95 0.95 0.05],'ForegroundColor','r');

% --- Called by kmedoids radiobutton
% Summary: Uses downloaded kmedoids function
function [label, energy, index] = kmedoids(X,k)
% X: d x n data matrix
% k: number of cluster
% NOTE: DIMENSIONS ARE COLUMNS
% Written by Mo Chen (sth4nth@gamil.com)
v = dot(X,X,1);
D = bsxfun(@plus,v,v')-2*(X'*X);
n = size(X,2);
[emptyvar1, label] = min(D(randsample(n,k),:));
last = 0;
while any(label ~= last)
    [emptyvar1, index] = min(D*sparse(1:n,label,1,n,k,n));
    last = label;
    [val, label] = min(D(index,:),[],1);
end
% energy = sum(val);
energy=1;

% --- Called by opt_order_Callback
% Summary: Uses random swap to find optimal order
% Description:
%%%% -Creates corrgram value matrix
%%%% -Test Niter random orders, calculating the total correlation value
%%%% between neighbouring dimensions
%%%% -The highest sum correlation is the chosen order
function [corder]=ordertest(AN)
[emptyvar1,Ndim]=size(AN);                                                  %%Create dimensions
Niter=400+(Ndim-5)*1034;                                                    %%Rough estimate for amount of dimensions
if  Niter >15000
    Niter=15000;
elseif Niter<400
    Niter=400;
end
corr_matrix=NaN(Ndim,Ndim);
for i = 1 : Ndim
    for j = 1 : Ndim
        corr_matrix(i,j)=corr(AN(:,i),AN(:,j));                             %%Correlation matrix between dimensions
    end
end
corr_matrix = (corr_matrix.^2).^(1/2);                                      %%Modulus
order = NaN(Niter,Ndim);                                                    %%Preallocate variables
total_corr = NaN(Niter,1);
corr_order=NaN(1,(Ndim-1));
for m = 1 : Niter
    rr=rand(1,Ndim);                                                        %%Random matrix
    [emptyvar1 order(m,:)]=sort(rr);                                        %%Index gives random order
    for i = 1 : (Ndim-1)
        corr_order(i)=corr_matrix(order(m,i),order(m,i+1));                 %%Find correlations between each dimensions in the order
    end
    total_corr(m,:)=sum(corr_order(:));                                     %%Total correlation value for that order
end
M=find(total_corr==max(total_corr));                                        %%Max correlation of all orders
corder=order(M(1),:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MISC (when these are deleted, startup throws up errors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function datalabel_CreateFcn(emptyvar1, emptyvar2, emptyvar3)

% --- Executes on button press in plotraw.
function plotraw_Callback(emptyvar1, emptyvar2, emptyvar3)

% --- Executes during object creation, after setting all properties.
function plotraw_CreateFcn(emptyvar1, emptyvar2, emptyvar3)

% --- Executes during object creation, after setting all properties.
function selnum_clus_CreateFcn(hObject, emptyvar1, emptyvar2)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function errer_CreateFcn(hObject, emptyvar1, emptyvar2)
% hObject    handle to errer (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xres_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function xres_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yres_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function yres_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end 

% --- Executes on button press in dlog.
function dlog_Callback(hObject, eventdata, handles)


%%%%%% PARAMETERS: APPDATA AND OTHER IMPORTANT VARIABLES
%data_raw=Raw dataset, data_scaled=Scaled dataset (highest value = 1, lowest = 0)
%data_transformed=Transformed dataset, dimnum= number of dimensions, numgrps= number of
%groups, num_clus= number of clusters, numfigs= number of open figures,
%groupspec_str=(String-cellarray) Group specifications, groupspec_num=(Numeric array)**,
%order=axes order, flip=flipped axes, datanames=Imported data names,
%IDX=kmeans spec, C=cluster centroid locations, sumd=distance to cluster
%centroids, medIDX=kmedoids spec, labels/unitm=axes labels/units,

