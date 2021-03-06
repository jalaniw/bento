function exptGui = build_experiment(source,~)
%
% possible data and metadata to include:
%   - mouse number, session number, trial number, stimulus name
%   - Ca imaging data (.mat), NVista log file, framerate
%   - Behavior video (.seq, .mp4, .avi), behavior annotations, timestamp?
%   framerate
%   - Audio data, audio log file/timestamp, framerate
%   - Tracking data, tracking data format

gui = guidata(source);
pth = pwd;

fillin = {'units','normalized','fontsize',11};
f = figure(999);clf;
exptGui.f = f;
set(f,'units','pixels','dockcontrols','off','menubar','none','NumberTitle','off',...
    'position',[80 123 1000 650],'ResizeFcn',@redrawBuilder);
uicontrol('style','text',fillin{:},'position',[0 .85 1 .15],'string','');
uicontrol('style','text',fillin{:},'position',[0 .925 1 .05],'string','Experiment manager','fontweight','bold');
uicontrol('style','text',fillin{:},'position',[.04 .875 .12 .05],'string','Parent directory:','horizontalalign','right');
exptGui.root = uicontrol('style','edit',fillin{:},'position',[.17 .886 .42 .045],'string',pth,'horizontalalign','left');

cnames          = {'Mouse','Sessn','Trial','Stim',...
                   'Calcium imaging file','Start Ca','Stop Ca','FR Ca','Alignments',...
                   'Annotation file','Start Anno','Stop Anno','FR Anno','Offset',...
                   'Behavior movie','Tracking','Audio file'};
exptGui.rowVis  = [1 1 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0];
colSizes        = ones(1,length(exptGui.rowVis)).*exptGui.rowVis;
exptGui.t       = uitable('parent',f,fillin{:},'position',[.01 .375 .98 .5],'columnname',cnames,'rowname','',...
                'columneditable',true,'columnwidth',mat2cell(colSizes,1,ones(1,length(colSizes))),...
                'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));


dat{1,1}    = 1;
dat{1,2}    = 1;
dat{1,3}    = 1;
dat(1,4)    = {''};
dat(1,5:8)  = {'',[],[],[]};
dat(1,9:13) = {'',[],[],[],[]};
dat(1,14:17) = {[],[],[],[]};

set(exptGui.t,'data',dat);
exptGui.CaMulti   = uicontrol('parent',f,fillin{:},'position',[.2 .325 .2 .03],'Tag','concatCa',...
                'style','checkbox','string','Multiple trials per Ca file','callback',@toggleVis);
exptGui.CaFRtxt   = uicontrol('parent',f,fillin{:},'position',[.2 .265 .14 .045],'Tag','concatCa',...
                'style','text','string','Ca framerate (Hz):','horizontalalignment','left');
exptGui.CaFR      = uicontrol('parent',f,fillin{:},'position',[.34 .265 .06 .05],'Tag','concatCa',...
                'style','edit');
exptGui.annoFR    = uicontrol('parent',f,fillin{:},'position',[.66 .265 .06 .05],'Tag','concatCa',...
                'style','edit');
exptGui.CaFRtog   = uicontrol('parent',f,fillin{:},'position',[.2 .225 .3 .03],'Tag','FRCa',...
                'style','checkbox','string','Variable Ca framerate','callback',@toggleVis);
exptGui.offset    = uicontrol('parent',f,fillin{:},'position',[.2 .175 .35 .03],'Tag','offset',...
                'style','checkbox','string','Time offset between Ca + annot start','callback',@toggleVis);
            
exptGui.annoMulti = uicontrol('parent',f,fillin{:},'position',[.5 .325 .25 .03],'Tag','concatAnnot',...
                'style','checkbox','string','Multiple trials per annotation file','callback',@toggleVis);
exptGui.annoFRtxt = uicontrol('parent',f,fillin{:},'position',[.5 .265 .16 .045],'Tag','concatCa',...
                'style','text','string','Anno framerate (Hz):','horizontalalignment','left');
exptGui.annoFRtog = uicontrol('parent',f,fillin{:},'position',[.5 .225 .35 .03],'Tag','FRAnnot',...
                'style','checkbox','string','Variable annot. framerate','callback',@toggleVis);
exptGui.incMovies = uicontrol('parent',f,fillin{:},'position',[.5 .175 .35 .03],'Tag','BhvMovies',...
                'style','checkbox','string','Link behavior movies','callback',@toggleVis);
exptGui.incTracking = uicontrol('parent',f,fillin{:},'position',[.5 .125 .35 .03],'Tag','Tracking',...
                'style','checkbox','string','Link tracking data','callback',@toggleVis);
exptGui.incAudio  = uicontrol('parent',f,fillin{:},'position',[.5 .075 .35 .03],'Tag','Audio',...
                'style','checkbox','string','Link audio data','callback',@toggleVis);

p = get(f,'position');
exptGui.bP        = uicontrol('parent',f,fillin{:},'position',[.025 .792-23*size(get(exptGui.t,'data'),1)/p(4) .02 .02*p(3)/p(4)],...
                'style','pushbutton','string','+','callback',@addRow);
exptGui.bM        = uicontrol('parent',f,fillin{:},'position',[.05 .792-23*size(get(exptGui.t,'data'),1)/p(4) .02 .02*p(3)/p(4)],...
                'style','pushbutton','string','-','callback',@removeRow);
exptGui.discover  = uicontrol('parent',f,fillin{:},'style','pushbutton','position',[.74 .886 .18 .045],...
                'string','Launch file finder','callback',@launchFinder);
            

exptGui.load      = uicontrol('parent',f,fillin{:},'style','pushbutton','position',[.025,.12,.15,.05],...
                'string','Save info','callback',@saveTable);
exptGui.load      = uicontrol('parent',f,fillin{:},'style','pushbutton','position',[.025,.06,.15,.05],...
                'string','Load info','callback',@loadTable);    
exptGui.next      = uicontrol('parent',f,fillin{:},'style','pushbutton','position',[.8,.175,.15,.1],...
                'string','Start import','backgroundcolor',[.65 1 .65],'callback',{@processTable,gui});
guidata(f,exptGui);

redrawBuilder(f,[]);