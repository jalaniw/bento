function mov = applyTracking(gui,mov,time)

frnum = floor(time*gui.data.annoFR)+1;
if(isempty(gui.data.tracking.active{frnum})&frnum>1)
    gui.data.tracking.active{frnum} = gui.data.tracking.active{frnum-1};
end
if(isempty(gui.data.tracking.inactive{frnum})&frnum>1)
    gui.data.tracking.inactive{frnum} = gui.data.tracking.inactive{frnum-1};
end
    
eval(['pts = ' gui.data.tracking.fun '(gui.data.tracking.args, ' num2str(frnum) ' );']);
if(length(gui.data.io.movie.fid)>1)
    dims = [gui.data.io.movie.reader.width];
    if(dims(1)~=max(dims))
        pad = (max(dims)-dims(1))/2;
        for i=1:size(pts,1)
            pts(i,2:2:end)=pts(i,2:2:end)+pad;
        end
    end
end

active       = gui.data.tracking.active{frnum};
inactive     = gui.data.tracking.inactive{frnum};

[~,indsA,indsB]     = intersect(pts(:,1),active);
if(~isempty(indsA))
    inds         = sortrows([indsB indsA],1);
    inds         = inds(:,2);
else
    inds=[];
end
plotActive   = pts(inds, 2:end);

[~,indsA,indsB]     = intersect(pts(:,1),inactive);
if(~isempty(indsA))
    inds         = sortrows([indsB indsA],1);
    inds         = inds(:,2);
else
    inds=[];
end
plotInactive = pts(inds, 2:end);

if(size(pts,2)<=4)
    mov = insertObjectAnnotation(mov,'circle',plotActive,...
                                 cellstr(num2str( (1:length(active))' ))',...
                                 'color','green','textcolor','w','linewidth',4,'FontSize',12);
                             
    mov = insertObjectAnnotation(mov,'circle',plotInactive,...
                                 cellstr(num2str( ((length(active)+1):size(pts,1))' ))',...
                                 'color','blue','textcolor','w','linewidth',2,'FontSize',12);
else
    for j=1:size(plotActive,1)
        for i = 3:2:size(plotActive,2)
            mov = insertShape(mov,'Line',plotActive(j,i-2:i+1),'linewidth',3,'color','green');
            mov = insertShape(mov,'FilledCircle',[plotActive(j,i:i+1) 6],'color','green');
        end
        mov = insertShape(mov,'FilledCircle',[plotActive(j,1:2) 7],'color','red','opacity',1);
    end
    for j=1:size(plotInactive,1)
        for i = 3:2:size(plotInactive,2)
            mov = insertShape(mov,'Line',plotInactive(j,i-2:i+1),'linewidth',3,'color','cyan');
            mov = insertShape(mov,'FilledCircle',[plotInactive(j,i:i+1) 6],'color','cyan');
        end
        mov = insertShape(mov,'FilledCircle',[plotInactive(j,1:2) 7],'color','red','opacity',1);
    end
end

% apply crop+zoom if turned on
if(~isempty(gui.data.tracking.crop))
    mov = imcrop(mov,gui.data.tracking.crop);
end