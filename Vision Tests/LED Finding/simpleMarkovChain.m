% Simple Markov Chain


x = 0;

figure
while 1
   
    if x > 6
        prob = 0.40;
    elseif x < -6
        prob = 0.60;
    else
        prob = 0.5;
    end
    
    d = rand(1);
    if d > prob;
        x = x+1;
    elseif d < prob
        x = x-1;
    end
    
    
    plot(x,0,'k+');
    xlim([-25 25])
    pause(0.1);
    
    if x < -25 || x > 25
        close all
        break
    end
end