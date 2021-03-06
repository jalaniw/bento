function applyColor(source,~,parent)
data = guidata(source);
gui  = guidata(parent);

for i = 1:length(data.h.bhvrs)
    beh = strrep(data.h.lbls(i).String,' ','_');
    newColor = data.h.bhvrs(i).BackgroundColor;
    gui.annot.cmap.(beh) = newColor;
end

guidata(gui.h0,gui);

updateSliderAnnot(gui);
updatePlot(gui.h0,[]);
updatePreferredCmap(gui.annot.cmap);

close(data.h0);