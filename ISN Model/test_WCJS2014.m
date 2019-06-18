% modelParam: 'sig', 'pp' or 'pl' for sigmoidal, piecewise power or piecewise linear

function [x, yy, eFR,iFR,peakFreq,harmonicFreq,freqRatio,peakAmp,harmonicAmp,powerRatio,hilbPhaseDiff] = test_WCJS2014(e0,i0,displayFlag)

if ~exist('displayFlag','var');        displayFlag=0;                   end

eqnName = 'eqn_WCJS2014';
[wcParams,stimParams] = defaultParams_JS2014; % Get default parameters

stimParams.e = e0;
stimParams.i = i0;
wcParams.modelParam = 'sig';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tVals=1:2000;               % trace for 2 seconds. Fs = 1000 Hz
goodTimePos = 1001:2000;    % Compute parameters for the last 1 second

y0 = [0 0]; % start from origin
[t,y] = ode45(@(t,y) eqn_WCJS2014(t,y,wcParams,stimParams),tVals,y0);

% Get FFT of last 1 second. We get 1 second resolution
eFR = mean(y(goodTimePos,1),1);
iFR = mean(y(goodTimePos,2),1);

ffty1 = fft(y(goodTimePos,1));
ffty2 = fft(y(goodTimePos,2));
freqVals = 0:999; % Hz
yy = y(goodTimePos,1);
x = y(goodTimePos,1)+y(goodTimePos,2);
tMS = tVals(goodTimePos);
gammaRangeHz = [30 75];
[peakFreq,harmonicFreq,freqRatio,peakAmp,harmonicAmp,powerRatio,hilbPhaseDiff]=getGammaAndHarmonicProperties(x,gammaRangeHz,20,tMS);
if displayFlag
    
    figure();
    subplot(221);
    plot(t,y(:,1),'r'); hold on;
    plot(t,y(:,2),'b');
    plot(t,eFR+zeros(1,length(t)),'r--'); 
    plot(t,iFR+zeros(1,length(t)),'b--');
    xlabel('Time (ms)');

    
    subplot(222);
    plot(freqVals,log10(abs(ffty1)),'r'); hold on;
    plot(freqVals,log10(abs(ffty2)),'b');
    plot(peakFreq,log10(peakAmp),'ro');
    plot(harmonicFreq,log10(harmonicAmp),'bo');
    xlim([0 150]);
    xlabel('Frequency (Hz)');
    ylabel('log Power');
    
    subplot(212);
    xRange = [0 1];
    yRange = [0 1];
    numDivisions = 20;
    xList = linspace(xRange(1),xRange(2),numDivisions+1);
    yList = linspace(yRange(1),yRange(2),numDivisions+1);
    
    describeDynamics(eqnName,xList,yList,wcParams,stimParams);
end
end

function [wcParams,stimParams] = defaultParams_JS2014
wcParams.Wee     = 16;
wcParams.Wei     = 26;
wcParams.taue    = 20;

wcParams.Wie     = 20;
wcParams.Wii     = 1;
wcParams.taui    = 10;

wcParams.thetaE  = 5;
wcParams.thetaI  = 20;
wcParams.m       = 1;

stimParams.e = 0;
stimParams.i = 0;
end