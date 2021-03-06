function gui = drawAudio(gui)

if(isfield(gui,'audio'))
    delete(gui.audio.panel);
end

audio.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
audio.axes         = axes('parent',audio.panel,'ytick',0:25:100); hold on;
audio.yScale       = 1;
audio.win          = 20;
audio.bg           = image();set(audio.bg,'visible','off');
audio.img          = image();
audio.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');
colormap jet;

audio.thrLo = -100;
audio.thrHi = -40;
audio.freqLo = 0;
audio.freqHi = 125;

xlabel('time (sec)');
axis tight;
xlim(audio.win*[-1 1]);


gui.audio = audio;