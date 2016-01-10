clear
my_dir=pwd;
addpath([my_dir '/Functions']);

% 1 Create main GUI
h.main=figure('units','pixels','position',[50,50,1029,599],'name','PCP Toolbar');
h.input_panel=uipanel('parent',h.main,'units','pixels','position',[10,13,428,586],'tag','input_panel','title','input');
h.input_browse_data=uicontrol('units','pixels','parent',h.input_panel,'style','pushbutton','position',[8,546,144,22],'tag','input_browse_data','string','Browse for dataset (.mat)');
h.input_browse_labels=uicontrol('units','pixels','parent',h.input_panel,'style','pushbutton','position',[8,523,164,22],'tag','input_browse_labels','string','Browse for axes labels (.mat)','visible','off');
h.input_browse_units=uicontrol('units','pixels','parent',h.input_panel,'style','pushbutton','position',[8,500,159,22],'tag','input_browse_units','string','Browse for axes units (.mat)','visible','off');
h.input_browse_names=uicontrol('units','pixels','parent',h.input_panel,'style','pushbutton','position',[177,523,165,22],'tag','input_browse_names','string','Browse for data names (.mat)','visible','off');
h.input_optorder=uicontrol('units','pixels','parent',h.input_panel,'style','pushbutton','position',[172,500,88,22],'tag','input_optorder','string','Optimise order','visible','off');
h.input_datadisplay=uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[159,549,158,14],'tag','input_datadisplay','string','','visible','off');
h.input_plotrawdata=uicontrol('units','pixels','parent',h.input_panel,'style','checkbox','position',[265,499,93,22],'tag','input_plotrawdata','string','Plot raw data','visible','off');
set(h.input_browse_data,'callback',{@input_browse_data_Callback,h});
set(h.input_browse_labels,'callback',{@input_browse_labels_Callback});
set(h.input_browse_units,'callback',{@input_browse_units_Callback});
set(h.input_browse_names,'callback',@input_browse_names_Callback);
set(h.input_optorder,'callback',{@input_optorder_Callback,h});
uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[8,480,52,19],'string','Labels');
uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[101,480,52,19],'string','Units');
uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[172,480,69,19],'string','Axes order');
uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[251,480,52,19],'string','Flip axis');
uicontrol('units','pixels','parent',h.input_panel,'style','text','position',[314,480,102,19],'string','Set scale to variable');

% 2 Create Groups panel
h.groups_panel=uipanel('units','pixels','parent',h.main,'position',[450,277,563,201],'tag','groups_panel','title','Groups','visible','off');
h.groups_create=uicontrol('units','pixels','parent',h.groups_panel,'position',[6,164,105,22],'tag','groups_create','string','Create new group');
set(h.groups_create,'callback',@groups_create_Callback);
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[6,149,61,14],'string','Group name');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[72,148,52,15],'string','Edit group');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[129,148,52,15],'string','Hide group');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[129,148,52,15],'string','Hide group');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[186,148,66,15],'string','Group colour');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[257,148,120,15],'string','Envelope transparency');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[382,148,73,15],'string','Remove group');
uicontrol('units','pixels','parent',h.groups_panel,'style','text','position',[460,148,79,15],'string','Line style/width');

% 3 Create Clusters panel
h.clusters_panel=uipanel('units','pixels','parent',h.main,'position',[450,72,562,205],'tag','clusters_panel','title','Clusters','visible','off');
h.clusters_selnum=uicontrol('units','pixels','parent',h.clusters_panel,'style','popupmenu','position',[11,166,157,20],'value',1,'string',{'Select number of clusters','2','3','4','5','6'});
h.clusters_optnum=uicontrol('units','pixels','parent',h.clusters_panel,'style','pushbutton','position',[173,165,91,22],'string','Optimal number','tag','clusters_optnum');
h.clusters_kmedoid=uicontrol('units','pixels','parent',h.clusters_panel,'style','radiobutton','position',[269,164,156,23],'string','K-Medoid method (binary)');
set(h.clusters_optnum,'callback',@clusters_optnum_Callback);
set(h.clusters_selnum,'callback',@clusters_create_Callback);
set(h.clusters_kmedoid,'callback',@clusters_kmedoid_Callback);
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[11,148,77,14],'string','Cluster number');
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[93,147,70,15],'string','Cluster colour');
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[168,147,59,15],'string','Hide cluster');
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[232,147,120,15],'string','Envelope transparency');
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[357,147,78,15],'string','Noise reduction');
uicontrol('units','pixels','parent',h.clusters_panel,'style','text','position',[440,147,79,15],'string','Line style/width');

% 4 Create Output panel
h.output_panel=uipanel('units','pixels','parent',h.main,'position',[450,477,480,122],'tag','output_panel','title','Output','visible','off');
h.output_error=uicontrol('units','pixels','parent',h.output_panel,'style','text','position',[13,81,325,20],'tag','output_error','BackgroundColor',[1 1 1]);
h.output_cancel=uicontrol('units','pixels','parent',h.output_panel,'style','pushbutton','string','Cancel calculation','position',[352,78,105,25],'tag','output_cancel');
h.output_figures_panel=uipanel('units','pixels','parent',h.output_panel,'position',[14,8,270,64],'tag','output_figures_panel','title','Figures');
h.output_figures_create=uicontrol('units','pixels','parent',h.output_figures_panel,'style','pushbutton','position',[15,18,108,22],'tag','output_figures_create','string','Create new figure');
h.output_figures_update=uicontrol('units','pixels','parent',h.output_figures_panel,'style','pushbutton','position',[145,18,112,23],'tag','output_figures_update','string','Update new figure');
h.output_data_panel=uipanel('units','pixels','parent',h.output_panel,'position',[287,8,182,64],'tag','output_data_panel','title','Data');
h.output_data_outdata=uicontrol('units','pixels','parent',h.output_data_panel,'style','pushbutton','position',[11,18,163,23],'tag','output_data_outdata','string','Output group and cluster data');
set(h.output_cancel,'callback',@output_cancel_Callback);
set(h.output_figures_create,'callback',@output_figures_create_Callback);
set(h.output_figures_update,'callback',@output_figures_update_Callback);
set(h.output_data_outdata,'callback',@output_figures_outdata_Callback);

% 5 create Filtering panel
h.filter_panel=uipanel('units','pixels','parent',h.main,'position',[450,13,201,60],'tag','filter_panel','title','Filtering','visible','off');
h.filter_data=uicontrol('units','pixels','parent',h.filter_panel,'style','pushbutton','position',[11,16,66,23],'tag','filter_data','string','Filter data');
h.filter_returndata=uicontrol('units','pixels','parent',h.filter_panel,'style','pushbutton','position',[80,16,110,23],'tag','filter_returndata','string','Return original data');
set(h.filter_data,'callback',@filter_data_Callback);
set(h.filter_returndata,'callback',@filter_returndata_Callback);

% 6 create Density Plot panel
h.density_panel=uipanel('units','pixels','parent',h.main,'position',[661,13,351,60],'tag','density_panel','title','Density Plot','visible','off');
h.density_xres=uicontrol('units','pixels','parent',h.density_panel,'position',[47,18,29,22],'tag','density_xres','style','edit','string','40');
h.density_yres=uicontrol('units','pixels','parent',h.density_panel,'position',[117,18,29,22],'tag','density_yres','style','edit','string','500');
h.density_log=uicontrol('units','pixels','parent',h.density_panel,'position',[153,17,75,23],'tag','density_log','style','checkbox','string','Log scale','value',1);
h.density_plot=uicontrol('units','pixels','parent',h.density_panel,'position',[239,17,101,23],'tag','density_plot','style','pushbutton','string','Plot to new figure');
set(h.density_plot,'callback',@density_plot_Callback);
uicontrol('units','pixels','parent',h.density_panel,'style','text','position',[13,22,27,14],'string','XRes');
uicontrol('units','pixels','parent',h.density_panel,'style','text','position',[83,22,27,14],'string','YRes');
