close all;
hFig = figure('Name', 'Two Wheels Playground', 'Windowstyle', 'docked', 'KeyPressFcn', @fig_kpfcn);

txt = text(0,6,"");
hold on
axis([-7 7 -7 7])
axis square
grid on
bot = TwoWheeledBot([0,0], 0, 2, 1, 0.9, 0.5);
guidata(hFig, [0, 0])
title('Two Wheeled Bot (W,S,A,D) control')
drawnow

%%
ts = 0.001;

x = nan(10000,1);
y = nan(10000,1);

hPlot = plot(x,y, 'r');

k = 1;
c = bot.Center;
o = bot.getOrientation;

while true
    
    waitforbuttonpress;
    hPlot.XData(k) = bot.Center(1);
    hPlot.YData(k) = bot.Center(2);
    k = k + 1;
    w = guidata(hFig);
    bot = bot.update(w(1), w(2), ts);
    
    if c(1) ~= bot.Center(1) || c(2) ~= bot.Center(2) ||o ~= bot.getOrientation
    drawnow
    end

    c = bot.Center;
    o = bot.getOrientation;

end

%%

function [] = fig_kpfcn(H,E)
% Figure (and pushbutton) keypressfcn
w = guidata(H);
    switch E.Key
        case 'd'
            w(1) = -50;
            w(2) = 50;
        case 'a'
            w(1) = 50;
            w(2) = -50;
        case 'w'
            w(1) = 50;
            w(2) = 50;
        case 's'
            w(1) = -50;
            w(2) = -50;
    end
guidata(H, w)
end