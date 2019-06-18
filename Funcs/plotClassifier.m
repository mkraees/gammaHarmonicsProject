function plotClassifier(ylim,xlim,xa,ya)
    a = ylim;
    b = xlim;
    xx(1:50) = xa;
    xy = linspace(a(1),a(2),50);
    plot(xx,xy,'LineStyle','--','Color',[0.5 0.5 0.5])

    yy(1:50) = ya;
    yx = linspace(b(1),b(2),50);
    plot(yx,yy,'LineStyle','--','Color',[0.5 0.5 0.5])
end