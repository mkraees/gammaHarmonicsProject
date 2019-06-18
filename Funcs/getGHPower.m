function [gammaAmp, harmonicAmpExact] = getGHPower(subjectName,expType,stimType)

saveFolder = '/home/me/GammaHarmonicData/savedData';
if isfile(fullfile(saveFolder,[subjectName expType stimType '.mat']))
    load(fullfile(saveFolder,[subjectName expType stimType '.mat']))
end

% PSD
PSDst = squeeze(mean(psdST,2)); % mean across trials
meanPSDST = mean(log10(PSDst),2);
PSDbl = squeeze(mean(psdBL,2)); % mean across trials
meanPSDBL = mean(log10(PSDbl),2);
baseCorrectedDB = 10*(meanPSDST-meanPSDBL);
[fG, fH, gammaAmp, ~, ~, ~, ~, harmonicAmpExact] = findGammaPeak(baseCorrectedDB, freqVals);

pGpos = find(freqVals == fG);
pHpos = find(freqVals == fH);

if strcmp(expType, 'Length')
    d = 15;
    b = 12;
    movlen = 15;
    r = 0;
elseif strcmp(expType, 'Color')
    d = 10;
    b = 12;
    movlen = 20;
    r = 0.5;
end

plotFlag = 0;
CC = getBaselineFit(freqVals, baseCorrectedDB,pGpos,pHpos,d,b,movlen, r, plotFlag);

gammaAmp = gammaAmp - CC(pGpos);
harmonicAmpExact = harmonicAmpExact - CC(pHpos);

% gammaAmp = gammaAmp - (baseCorrectedDB(pGpos-d)+baseCorrectedDB(pGpos+d))/2;
% harmonicAmpExact = harmonicAmpExact - (baseCorrectedDB(pHpos-d)+baseCorrectedDB(pHpos+d))/2;

% figure()
% hold on
% plot(meanPSDST,'r');
% plot(meanPSDBL,'k');
% plot(baseCorrectedDB,'b');
% line([pGpos pGpos],[baseCorrectedDB(pGpos)-gammaAmp baseCorrectedDB(pGpos)],'linestyle','--')
% line([pHpos pHpos],[baseCorrectedDB(pHpos)-harmonicAmpExact baseCorrectedDB(pHpos)],'linestyle','--')
% title([subjectName expType stimType])
% hold off

end