for i = 1:length(goodGHPos)
    e0 = goodGHPos(i,1);
    i0 = goodGHPos(i,2);

    wcParams.Wee     = 16;
    wcParams.Wei     = 26;
    wcParams.taue    = 20;

    wcParams.Wie     = 20;
    wcParams.Wii     = 1;
    wcParams.taui    = 10;

    wcParams.thetaE  = 5;
    wcParams.thetaI  = 20;
    wcParams.m       = 1;

    stimParams.e = e0;
    stimParams.i = i0;
    wcParams.modelParam = 'sig';

    tVals=1:2000;               % trace for 2 seconds. Fs = 1000 Hz
    goodTimePos = 1001:2000;    % Compute parameters for the last 1 second

    y0 = [0 0]; % start from origin
    [t,y] = ode45(@(t,y) eqn_WCJS2014(t,y,wcParams,stimParams),tVals,y0);

    E = y(goodTimePos,1);
    I = y(goodTimePos,2);
    tMS = tVals(goodTimePos);


    Sig = E+I;
    fftSig = log(abs(fft(Sig)));
    figure()
    plot(fftSig)
    xlim([0 200])
    title(['E = ' num2str(e0) '  I = ' num2str(i0)])

end