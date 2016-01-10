function output_txt = dispnames(~,~,data_transformed,datanames)  %%Finds and matches nam from datanames
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
targ = get(event_obj,'Target');                                             %%Get polyline handle
coords=get(targ,'YData');                                                   %%Get polyline values
[~,num]=ismember(coords,data_transformed,'rows');                        %%Find which member
nam=datanames(num);                                                         %%Get name
pos = get(event_obj,'Position');                                            %%Get pointer coordinates
output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)], ['Name: ' nam{1}]};