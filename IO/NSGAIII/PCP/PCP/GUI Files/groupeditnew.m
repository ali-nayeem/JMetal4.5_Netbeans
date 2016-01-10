%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% groupeditnew.m, all functions have a similar counterpart in groupnew.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function varargout = groupeditnew(varargin)
% GROUPEDITNEW MATLAB code for groupeditnew.fig
%      GROUPEDITNEW, by itself, creates a new GROUPEDITNEW or raises the existing
%      singleton*.
%
%      H = GROUPEDITNEW returns the handle to a new GROUPEDITNEW or the handle to
%      the existing singleton*.
%
%      GROUPEDITNEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUPEDITNEW.M with the given input arguments.
%
%      GROUPEDITNEW('Property','Value',...) creates a new GROUPEDITNEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before groupeditnew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to groupeditnew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help groupeditnew

% Last Modified by GUIDE v2.5 06-Aug-2013 15:36:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @groupeditnew_OpeningFcn, ...
                   'gui_OutputFcn',  @groupeditnew_OutputFcn, ...
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


% --- Executes just before groupeditnew is made visible.
function groupeditnew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to groupeditnew (see VARARGIN)

% Choose default command line output for groupeditnew
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes groupeditnew wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = groupeditnew_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function gename_Callback(hObject, eventdata, handles)
% hObject    handle to gename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gename as text
%        str2double(get(hObject,'String')) returns contents of gename as a double


% --- Executes during object creation, after setting all properties.
function gename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in seclose.
function seclose_Callback(hObject, eventdata, handles)                      %%Similar function to sclose_callback, see groupnew.m
a=getappdata(pcpnew,'ea');                                                  %%Get group being worked with

data_scaled=getappdata(pcpnew,'data_scaled');
[mlength,dimnum]=size(data_scaled);

rangerank=getappdata(pcpnew,'rangerank');
if rangerank(a)==1
    h.gtable=findobj('-regexp','Tag','Gespec');
    data=get(h.gtable,'data');                                              %%Get new group specification
    groupspec_str=getappdata(pcpnew,'groupspec_str');
    groupspec_str(:,:,a)=data;
    setappdata(pcpnew,'groupspec_str',groupspec_str);
    groupspec_num=getappdata(pcpnew,'groupspec_num');                       %%Get all existing group specifications
    for n=1 : 2                                                             %%Add new specification to existing
        for j = 1:dimnum
            if str2double(cell2mat(data(j,n)))>=0
                G=str2double(cell2mat(data(j,n)))/100;                      %%G numerical version of group specification
                if n ==1
                    groupspec_num(:,j,a)=(data_scaled(:,j)<=G);             %%groupspec_num stores whether group specification conditions are met
                elseif n == 2
                    groupspec_num(:,j+dimnum,a)=(data_scaled(:,j)>=G);      %%If a specification is not met the groupspec_num stores a 0
                end
            elseif n==1
                groupspec_num(:,j,a)=1;                                     %%If a specification is met or there was no specification the groupspec_num stores a 1
            elseif n==2
                groupspec_num(:,j+dimnum,a)=1;
            end
            
        end
    end
    setappdata(pcpnew,'groupspec_num',groupspec_num);                       %%Set new group specifications matrix
    groupspec_rank=getappdata(pcpnew,'groupspec_rank');
    groupspec_rank(:,a)=NaN;
    setappdata(pcpnew,'groupspec_rank',groupspec_rank);
    h.gename=findobj('-regexp','Tag','gename');
    h.ngroup=findobj('-regexp','tag',[num2str(a) 'ngroup']);
    name=get(h.gename,'string');
    set(h.ngroup,'string',name);
    close(groupeditnew);
else
    h.numpol=findobj('tag','enumpol');
    numpol=get(h.numpol,'value');
    values=[1,2,3,4,5,6,7,8,9,10,20,30,40,50,100,200,300,400,500,1000];
    numpol=values(numpol);
    if numpol > mlength
        h.errer=findobj('tag','errer');                                     %%If the dimensions don't match flag up and error
        set(h.errer,'string','Warning: More similar polylines selected than number of data','ForegroundColor',[1 0 0]);
        pause(5);
        set(h.errer,'string','');
    else
        h.rtable=findobj('tag','Gerspec');
        data=get(h.rtable,'data');
        groupspec_str=getappdata(pcpnew,'groupspec_str');
        groupspec_num=getappdata(pcpnew,'groupspec_num');
        groupspec_num(:,:,a)=NaN;
        groupspec_str(:,1,a)=data;
        groupspec_str(:,2,a)={'NaN'};
        setappdata(pcpnew,'groupspec_num',groupspec_num);
        setappdata(pcpnew,'groupspec_str',groupspec_str);
        for i = 1 : dimnum
            if isnan(str2double(cell2mat(data(i,1))))
                data(i,:)={'NaN'};
            end
        end
        data=cell2mat(cellfun(@str2num,data,'uniformoutput',false));
        if isnan(data)==ones(dimnum,1);
            groupspec_rank=getappdata(pcpnew,'groupspec_rank');
            groupspec_rank(:,a)=0;
            setappdata(pcpnew,'groupspec_rank',groupspec_rank);
        else
            data=data/100;
            [b,c]=sort(data);
            c(isnan(b))=[];
            b(isnan(b))=[];
            dis=NaN(length(b),1);
            dist=NaN(mlength,1);
            for i = 1:mlength
                for n = 1:length(b)
                    dis(n)=(data_scaled(i,c(n))-b(n))^2;
                end
                dist(i)=(sum(dis))^(1/2);
            end
            
            groupspec_rank=getappdata(pcpnew,'groupspec_rank');
            [emptyvar1,groupspec_rank(:,a)]=sort(dist);
            groupspec_rank((numpol+1):mlength,a)=0;
            setappdata(pcpnew,'groupspec_rank',groupspec_rank);
        end
        close(groupeditnew);
    end
end

% hObject    handle to seclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in trange.
function terange_Callback(hObject, eventdata, handles)
a=getappdata(pcpnew,'ea');
rangerank=getappdata(pcpnew,'rangerank');
rangerank(a)=1;
setappdata(pcpnew,'rangerank',rangerank);
h.gtable=findobj('tag','Gespec');
set(h.gtable,'visible','on');
h.grtable=findobj('tag','Gerspec');
set(h.grtable,'visible','off');
h.numpol=findobj('tag','enumpol');
h.pollabel=findobj('tag','epollabel');
set(h.numpol,'visible','off');
set(h.pollabel,'visible','off');
getappdata(groupeditnew);

% hObject    handle to trange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in trank.
function terank_Callback(hObject, eventdata, handles)
a=getappdata(pcpnew,'ea');
rangerank=getappdata(pcpnew,'rangerank');
rangerank(a)=0;
setappdata(pcpnew,'rangerank',rangerank);
h.gtable=findobj('tag','Gespec');
set(h.gtable,'visible','off');
h.grtable=findobj('tag','Gerspec');
set(h.grtable,'visible','on');
h.numpol=findobj('tag','enumpol');
h.pollabel=findobj('tag','epollabel');
set(h.numpol,'visible','on');
set(h.pollabel,'visible','on');
getappdata(groupeditnew);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rangerank=getappdata(pcpnew,'rangerank');
a=getappdata(pcpnew,'ea');
groupspec_str=getappdata(pcpnew,'groupspec_str');
if strcmp(groupspec_str(:,2,a),'NaN')
    rangerank(a)=0;
else
    rangerank(a)=1;
end
setappdata(pcpnew,'rangerank',rangerank);
% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes on selection change in enumpol.
function enumpol_Callback(hObject, eventdata, handles)
% hObject    handle to enumpol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns enumpol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from enumpol


% --- Executes during object creation, after setting all properties.
function enumpol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enumpol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
