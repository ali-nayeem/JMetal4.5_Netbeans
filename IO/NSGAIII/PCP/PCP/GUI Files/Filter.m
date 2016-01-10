%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MATLAB GUIDE startup functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = Filter(varargin)
% FILTER MATLAB code for Filter.fig
%      FILTER, by itself, creates a new FILTER or raises the existing
%      singleton*.
%
%      H = FILTER returns the handle to a new FILTER or the handle to
%      the existing singleton*.
%
%      FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTER.M with the given input arguments.
%
%      FILTER('Property','Value',...) creates a new FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Filter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Filter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Filter

% Last Modified by GUIDE v2.5 06-Aug-2013 10:27:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Filter_OpeningFcn, ...
    'gui_OutputFcn',  @Filter_OutputFcn, ...
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


% --- Executes just before Filter is made visible.
function Filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Filter (see VARARGIN)

% Choose default command line output for Filter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Filter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Filter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Filter.m functions and callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in fsclose.
% Summary: Saves and closes filter information
% Description:
%%%% 
function fsclose_Callback(hObject, eventdata, handles)
h.table=findobj('-regexp','Tag','Fspec');
M=get(h.table,'data');                                                      %%Get new filter specification
data_scaled=getappdata(pcpnew,'data_scaled');
data_raw=getappdata(pcpnew,'data_raw');                                     %%Get raw data/names and backup
setappdata(pcpnew,'Abackup',data_raw);                  
dimnum=getappdata(pcpnew,'dimnum');
datanames=getappdata(pcpnew,'datanames');
setappdata(pcpnew,'datanamesbackup',datanames);
M(strcmp(M(:,1),'Not Specified'),1)={'0'};                                  %%0 is chosen as no scaled variables will be <0
M(strcmp(M(:,2),'Not Specified'),2)={'100'};                                %%100 is chosen as no scaled variables will be >100
M=cell2mat(cellfun(@str2double,M,'uniformoutput',false));
M=M/100;
for n = 1 : 2
    for i = 1 : dimnum
        if n == 1
            H=data_scaled(:,i)<M(i,n);                                      %%Find data which can be filtered
            data_scaled(H,:)=[];                                            %%Eliminate these from datasets
            data_raw(H,:)=[];
            datanames(H)=[];
        elseif n == 2
            H=data_scaled(:,i)>M(i,n);
            datanames(H)=[];
            data_scaled(H,:)=[];
            data_raw(H,:)=[];
        end
        H=[];
    end
end
[mlength,emptyvar1]=size(data_scaled);                                      %%Create dimensions and reset new defaults
groupspec_str=cell(dimnum,2);
groupspec_str(:,:,1)={'Not Specified'};
setappdata(pcpnew,'datanames',datanames);
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
close(Filter);


% hObject    handle to fsclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
