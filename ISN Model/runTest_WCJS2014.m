clear;

e0 = 0:0.5:20; lE=length(e0);
i0 = 0:0.5:20; lI=length(i0);

eFR = zeros(lE,lI);
iFR = zeros(lE,lI);
peakFreq = zeros(lE,lI);
harmonicFreq = zeros(lE,lI);
freqRatio = zeros(lE,lI);
peakAmp = zeros(lE,lI);
harmonicAmp = zeros(lE,lI);
powerRatio = zeros(lE,lI);
hilbPhaseDiff = zeros(lE,lI);
freqRatioSelected = zeros(lE,lI);
powerRatioSelected = zeros(lE,lI);
hilbPhaseDiffSelected = zeros(lE,lI);


for j=1:lE
    for k=1:lI
        disp([j k]);
        [eFR(j,k),iFR(j,k),peakFreq(j,k),harmonicFreq(k,j),freqRatio(j,k),peakAmp(j,k),harmonicAmp(j,k),powerRatio(j,k),hilbPhaseDiff(j,k)] = test_WCJS2014(e0(j),i0(k),0);
    end
end

goodHarmonicPos = find(harmonicAmp > 1.5);
goodGammaPos = find(peakAmp > 19);
goodPos = intersect(goodHarmonicPos,goodGammaPos);

freqRatioSelected(goodPos) = freqRatio(goodPos);
powerRatioSelected(goodPos) = powerRatio(goodPos);
hilbPhaseDiffSelected(goodPos) = hilbPhaseDiff(goodPos);

goodGHPos = zeros(length(goodPos),2);
for i = 1:length(goodPos)
    [row, col] = find(harmonicAmp == harmonicAmp(goodPos(i)));
    goodGHPos(i,1) = row;
    goodGHPos(i,2) = col;
end


% Figures
figure()
colormap jet

subplot(421)
pcolor(e0,i0,eFR'); shading interp; 
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold');
title('E firing rate');

subplot(422)
pcolor(e0,i0,iFR'); shading interp;
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold'); 
title('I Firing rate');

subplot(423)
pcolor(e0,i0,peakAmp'); shading interp;
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold'); 
title('Peak Power');

subplot(424)
pcolor(e0,i0,harmonicAmp'); shading interp;
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold'); 
title('Harmonic Power');

subplot(425)
pcolor(e0,i0,peakFreq'); shading interp;
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold'); 
title('Peak Frequency (Hz)');

subplot(426)
pcolor(e0,i0,freqRatioSelected'); shading interp;
colorbar;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold'); 
caxis([0 3])
title('Frequency Ratio (H/F)');

subplot(427)
pcolor(e0,i0,powerRatioSelected'); shading interp;
xlabel('Input to E pop. (i_{E})','FontWeight','bold'); ylabel('Input to I pop. (i_{I})','FontWeight','bold'); colorbar;
title('Power Ratio (H/F)');

subplot(428)
pcolor(e0,i0,hilbPhaseDiffSelected'); shading interp;
% xlabel('iE','FontWeight','bold'); ylabel('iI','FontWeight','bold');
colorbar;
caxis([0 360])
title('Phase Diff (H/F)');
