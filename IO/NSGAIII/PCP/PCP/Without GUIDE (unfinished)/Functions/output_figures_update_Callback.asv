function output_figures_update_Callback (~,~,~)
h=evalin('base','h');
if isempty(h.fig)
    set(h.output_error,'string','Warning: No figure created','ForegroundColor',[1 0 0]);
    pause(5)
    set(h.output_error,'string','');
else
    dimnum=h.dimnum;
    styletypes={':','-.','--','-'};                                         %%Create style matrix (quicker than appdata?)
    widtypes=[0.5,1,2,3,4,5,6,7,8,9,10,12];                                 %%Create width matrix (quicker than appdata?)
    scaleax=NaN(1,dimnum);                                                  %%Preallocate axis variables
    order=scaleax;
    unitm=cell(1,dimnum);
    labels=unitm;
    flip=scaleax;
    for i = 1 : dimnum
        scaleax(i)=get(h.sradio(i),'value');
        order(i)=str2double(get(h.ostring(i),'string'));
        unitm(i)={get(h.uedit(i),'string')};
        labels(i)={get(h.ledit(i),'string')};
        flip(i)=get(h.fcheck(i),'value');
    end
    [scale_exist scale_index]=sort(scaleax,'descend');                      %%_exist shows existence of a scale, _index shows which axis
    [o order]=sort(order);
    data_scaled=h.data_scaled;
    data_transformed=data_scaled;                                           %%Create transform matrix for flips and ordering
    labels(o)=labels(order');                                               %%Ensure labels are in correct order
    flip=find(flip==1);
    data_transformed(:,flip)=-data_scaled(:,flip);
    data_transformed(:,o)=data_transformed(:,order');
    if get(h.input_plotrawdata,'value')==1
        figure(h.fig);
        plot(data_transformed',':b');
        hold on;
    end
    numgrps=h.numgrps;
    num_clus=h.num_clus;
    if numgrps > 0 
        groupspec_num=h.groupspec_num;
        groupspec_rank=h.groupspec_rank;
        rangerank=h.rangerank;
        for i = 1 : numgrps
            if get(h.hgroup(i),'value')==0
                styl=get(h.lsgroup(i),'value');
                styl=styletypes(styl);
                wid=get(h.lwgroup(i),'value');
                wid=widtypes(wid);
                col=get(h.csgroup(i),'BackgroundColor');
                if rangerank(i)==1
                    JN=sum((groupspec_num(:,:,i)),2);
                    JN=find(JN==(dimnum)*2);                                %%Find the data rows (polylines) which have met all specifications
                elseif rangerank(i)==0
                    JN=groupspec_rank(:,i);
                    JN(JN==0)=[];                                           %%Find all members of rank group
                end
                if isempty(JN)                                              %%If group is empty, throw error
                    set(h.output_error,'string',['Warning: Group ' num2str(i) ' is empty '],'ForegroundColor',[1 0 0]);
                    pause(5);
                    set(h.output_error,'string','');
                else
                    figure(h.fig);
                    trans=get(h.tsgroup,'value');
                    if trans == 0
                        plot((data_transformed(JN,:))','Color',col,'LineStyle',styl,'LineWidth',wid);
                        hold on
                    else
                        if length(JN) ==1                                   %%If single members flag up error
                            set(h.output_error,'string',['Warning: Group ' num2str(i) ' does not contain enough data for envelopes'],'ForegroundColor',[1 0 0]);
                            pause(5);
                            set(h.output_error,'string','');
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
    
    if num_clus>0
        med = get (k.medoid,'value');
        if med == 0
            IDX=h.IDX;
        else
            IDX=h.medIDX;
        end   
        for i = 1 : num_clus
            if get(h.hclus(i),'value')==0
                col=get(h.csclus(i),'BackgroundColor');
                styl=get(h.lsclus(i),'value');
                styl=styletypes(styl);
                wid=get(h.lwclus(i),'value');
                wid=widtypes(wid);
                nr=get(h.nrclus(i),'value');
                trans=get(h.tsclus,'value');
                if nr == 1
                end
            end
        end
    end
end