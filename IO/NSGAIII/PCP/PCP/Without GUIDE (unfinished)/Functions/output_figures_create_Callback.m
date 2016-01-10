function output_figures_create_Callback (~,~,~)
h=evalin('base','h');
dimnum=h.dimnum;
data_scaled=h.data_scaled;
    order=NaN(dimnum,1);
    flip=order;
    for i = 1 : dimnum                                                      %%Find/set order/flips/scale
        order(i,1)=str2double(get(h.ostring(i),'string'));
        flip(i,1)=get(h.fcheck(i),'value');
    end
    [o order]=sort(order);
    data_transformed=data_scaled;                                           %%Create transform matrix for flips and ordering
    flip=find(flip==1);
    data_transformed(:,flip)=-data_scaled(:,flip);
    data_transformed(:,o)=data_transformed(:,order');
h.fig=figure('units','pixels','position',[50,50,600,600],'toolbar','figure','menu','none');
dcm_obj=datacursormode(h.fig);
set(dcm_obj,'UpdateFcn',{@dispnames,data_transformed,h.names});
h.fig_axes=axes('parent',h.fig);
assignin('base','h',h);