close all;
figure('Name', 'Two Wheels Playground', 'Windowstyle', 'docked')

txt = text(0,6,"");
hold on
axis([-7 7 -7 7])
axis square
grid on
bot = TwoWheeledBot([-1,3], 0, 2, 1, 1.8, 0.5);
angle = 0;

%%

while true
    
    for i = 1 : 90/0.5
    bot = bot.rotateByOrigin(0.5, [-1 1 0]);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 2/0.01
    bot = bot.moveBy(0, -0.01);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 90/0.5
    bot = bot.rotateByOrigin(0.5, [-1 -1 0]);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 2/0.01
    bot = bot.moveBy(0.01, 0);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 90/0.5
    bot = bot.rotateByOrigin(0.5, [1 -1 0]);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 2/0.01
    bot = bot.moveBy(0, 0.01);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 90/0.5
    bot = bot.rotateByOrigin(0.5, [1 1 0]);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

    for i = 1 : 2/0.01
    bot = bot.moveBy(-0.01, 0);
    bot = bot.rotateWheelBy(1, -0.05);
    bot = bot.rotateWheelBy(2, -0.05);
    txt.String = num2str(bot.getOrientation(), '%.2f');
    drawnow
    end

end
