function CC = getBaselineFit(freqVals, baseCorrectedDB,pGpos,pHpos,d,b,movlen,r,plotFlag)

    if ~exist('d','var');  d = 10;  end
    if ~exist('b','var');  b = 10;  end
    if ~exist('movlen','var');  movlen = 20;  end
    if ~exist('r','var');  r = 0;  end
    if ~exist('plotFlag','var');  plotFlag = 0;  end
    
    AA = baseCorrectedDB;
    BB = movmean(AA,15);
    
    xg = [freqVals(pGpos-d) freqVals(pGpos+d)];
    yg = [BB(pGpos-d) BB(pGpos+d)];
    xgq = pGpos-d:pGpos+d;
    sg = spline(xg,yg,xgq);
    
    xh = [freqVals(pHpos-b) freqVals(pHpos+b)];
    yh = [BB(pHpos-b) BB(pHpos+b)];
    xhq = pHpos-b:pHpos+b;
    sh = spline(xh,yh,xhq);
    
    BB(xgq) = sg;
    BB(xhq) = sh-sh*r;
    CC = movmean(BB,movlen);
    
    if plotFlag
        figure()
        hold on
        plot(freqVals,AA)
        % plot(freqVals(xgq),sg,'g')
        % plot(freqVals(xhq),sh,'g')
         plot(freqVals,CC, 'k--')
         hold off
    end
end