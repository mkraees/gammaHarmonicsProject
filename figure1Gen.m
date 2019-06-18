function figure1Gen(subjectName, expType, stimType, row, col, num)

    if ~exist('row','var'); row = 1; end
    if ~exist('col','var'); col = 2; end
    if ~exist('num','var'); num = 1; end

    plotsFolder = '/home/me/GammaHarmonicData/Plots/Fig1';
    makeDirectory(plotsFolder);
    saveFolder = '/home/me/GammaHarmonicData/savedData';
    makeDirectory(saveFolder);
    
    if isfile(fullfile(saveFolder,[subjectName expType stimType '.mat']))
        load(fullfile(saveFolder,[subjectName expType stimType '.mat'])); %#ok<LOAD>
        disp('Variables loaded from Memory')
    else
        clearvars -except subjectName expType stimType saveFolder plotsFolder
        [highRMSElectrodes, goodPos, Fs, stPos, blPos, mt, folderLFP, timeVals, stimPeriod, baselinePeriod, folderSourceString] = getSubjectDetails(subjectName, expType, stimType); %#ok<ASGLU>
        [freqVals,psdST,psdBL,baseCorrectedLog10PSD, theta, RHO, stLFP, gammaSig, harmonicSig, gammaFreq, harmonicFreq, gammaAmp, harmonicAmp] = getPSDandPhase(highRMSElectrodes,folderLFP,goodPos,stPos,blPos,mt,Fs); %#ok<ASGLU>
        save(fullfile(saveFolder,[subjectName expType stimType '.mat']));
        disp('Variables Saved')
    end
    
        
    % PSD
    PSDst = squeeze(mean(psdST,2)); % mean across trials
    meanPSDST = mean(log10(PSDst),2);
        
    PSDbl = squeeze(mean(psdBL,2) ); % mean across trials
    meanPSDBL = mean(log10(PSDbl),2);
    
     
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

    clr = str2double(stimType);
    clr = clr/360;
    clrRGB = hsv2rgb([clr 1 1]);
    
    powerDB = 10*(meanPSDST - meanPSDBL);
    [fG, fH,] = findGammaPeak(powerDB, freqVals);
    pGpos = find(freqVals == fG);
    pHpos = find(freqVals == fH);
    BaselineFit = getBaselineFit(freqVals, powerDB, pGpos,pHpos,d,b,movlen,r);
    
    powerDB = movmean(powerDB,3);
    BaselineFit = movmean(BaselineFit,3);
    meanPSDBL = movmean(meanPSDBL,2);
    meanPSDST = movmean(meanPSDST,2);
    
    [freqGamma, freqHarmonic] = findGammaPeak(meanPSDST, freqVals);
    [freqGammaDB, freqHarmonicDB] = findGammaPeak(powerDB, freqVals);
    
%     figure()
    
    subplot(row, col, num)
    
    plot(freqVals,(meanPSDBL)','Color',[0 0 0],'LineWidth',1.5)
    hold on
    plot(freqVals,(meanPSDST)','Color',clrRGB,'LineWidth',1.5)
    
    plot(freqGamma,(meanPSDST(freqVals == freqGamma)),'o','HandleVisibility','off');
    text(freqGamma,(meanPSDST(freqVals == freqGamma)),[' G = '  num2str(freqGamma) ' Hz'],'Color',clrRGB);
    plot(freqHarmonic,(meanPSDST(freqVals == freqHarmonic)),'o','HandleVisibility','off');
    text(freqHarmonic,(meanPSDST(freqVals == freqHarmonic)),[' H = ' num2str(freqHarmonic) ' Hz'],'Color',clrRGB);
    xlim([0 150])
    xx = xlim; yy = ylim;
    text(xx(1)+0.35*(xx(2)-xx(1)), yy(1)+0.85*(yy(2)-yy(1)),['Freq. Ratio = ' num2str(round(freqHarmonic/freqGamma,2))]);
%     text(0.4*xx(2), 0.8*yy(2),['Freq. Ratio = ' num2str(round(freqHarmonic/freqGamma,2))]);
    
    
%     if num == 3; ylabel('log Poer (log_{10}((uV^{2})))','FontWeight', 'bold'); end
%     if num == 7; xlabel('Frequency (Hz)','FontWeight', 'bold'); end
%     
%     if num == 1; legend('BaseLine', 'Stimulus', 'Location', 'Best'); end
%     if num == 1; title('Power Spectrum'); end

    if num == 1; ylabel('M1','FontWeight', 'bold'); end
    if num == 5; ylabel('M3','FontWeight', 'bold'); end
    if num == 5; xlabel('Frequency (Hz)','FontWeight', 'bold'); end
    
    if num == 1; title('Power Spectrum'); end
%     if num == 3; title('Power Spectrum'); end
    
    set(gca, 'TickDir', 'out');
    hold off;
   
    
    
    subplot(row, col, num+1)
    hold on
    plot(freqVals,powerDB,'Color',clrRGB,'LineWidth',1.5)
    plot(freqVals, BaselineFit', 'Color',clrRGB, 'LineStyle', '--', 'LineWidth',1)
    
    plot(freqGammaDB,(powerDB(freqVals == freqGammaDB)),'ro','HandleVisibility','off');
    text(freqGammaDB,(powerDB(freqVals == freqGammaDB)),[' G = '  num2str(freqGamma) ' Hz'],'Color',clrRGB);
    plot(freqHarmonicDB,(powerDB(freqVals == freqHarmonicDB)),'ro','HandleVisibility','off');
    text(freqHarmonicDB,(powerDB(freqVals == freqHarmonicDB)),[' H = ' num2str(freqHarmonic) ' Hz'],'Color',clrRGB);
    
    line([freqGammaDB freqGammaDB], [BaselineFit(freqVals == freqGammaDB) powerDB(freqVals == freqGammaDB)], 'Color',clrRGB,'LineStyle','--');
    gDB = round(powerDB(freqVals == freqGammaDB)-BaselineFit(freqVals == freqGammaDB),2);
    text(freqGammaDB+2, BaselineFit(freqVals == freqGammaDB)+gDB/2,  [num2str(gDB) 'dB']);
    line([freqHarmonicDB freqHarmonicDB], [BaselineFit(freqVals == freqHarmonicDB) powerDB(freqVals == freqHarmonicDB)], 'Color',clrRGB,'LineStyle','--');
    hDB = round(powerDB(freqVals == freqHarmonicDB)-BaselineFit(freqVals == freqHarmonicDB),2);
    text(freqHarmonicDB+2, BaselineFit(freqVals == freqHarmonicDB)+hDB/2,  [num2str(hDB) ' dB']);
    
    xlim([0 150])
%     if num == 3; ylabel('Change in Power (dB)','FontWeight', 'bold'); end
%     if num == 7; xlabel('Frequency (Hz)','FontWeight', 'bold'); end
%     if num == 1; title('Change in Power from Baseline (dB)'); end

    if num+1 == 2; title('Change in Power (dB)'); end
%     if num == 4; title('Change in Power (dB)'); end

    hold off
    
end