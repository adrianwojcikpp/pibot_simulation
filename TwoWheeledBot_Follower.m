close all;
hFig = figure('Name', 'Two Wheels Playground', 'Windowstyle', 'docked', 'KeyPressFcn', @fig_kpfcn);

txt = text(1,11,"");
hold on
axis([0 10 0 12])
axis square
grid on

title('Two Wheeled Bot position control')
drawnow
%%
ts = 0.01;
k = 1;

nSamples = 4000;
im = cell(nSamples,1);
x = nan(nSamples,1);
y = nan(nSamples,1);

ref = [6 6];

hPlot = plot(x,y, 'r');
bot = TwoWheeledBot([2,2], 0, 2, 1, 0.9, 0.5);
hVector = plot(nan(2,1),nan(2,1), 'g', 'LineWidth', 2);
hRef = plot(ref(1),ref(2), '*', 'MarkerSize', 10);


bot.Kwp = 5;
bot.Kvp = 2;
bot.Kwd = 100*ts;
bot.Kvd = 100*ts;

c_old = bot.Center;

while k <= nSamples
    %% Update trajectory plot
    im{k} = frame2im(getframe(hFig));
    hVector.XData = [bot.Center(1), ref(1)];
    hVector.YData = [bot.Center(2), ref(2)];
    hRef.XData = ref(1);
    hRef.YData = ref(2);
    hPlot.XData(k) = bot.Center(1);
    hPlot.YData(k) = bot.Center(2);

    %% Increment counter
    k = k + 1;

    %% Bot position control routine
    [bot, w1, w2, em, eth] = bot.positionController(ref);

    if em < 0.05
        ref = 8*rand(2,1) + 1;
    end
    
    bot = bot.update(w1, w2, ts);

    %% Label update
    txt.String = num2str([w1 w2 em eth], ...
        ['[\\omega_R = %.2f rad/s , ' ...
        '\\omega_L = %.2f rad/s , ' ...
        '\\Deltax = %.2f m , ' ...
        '\\Delta\\theta = %.2f deg]']);
    
    
    drawnow

end

%%
filename = ['bot_anim_' char(datetime('now','Format','yyyy_MM_dd__HH_mm_ss')) '.gif']; 
for idx = 1:nSamples
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0);
    end
end
