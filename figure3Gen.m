function [Mean, Std, rayleighTest] = figure3Gen(subjectName, expType, stimType)
% Generate Figure 3

    plotsFolder = '/home/me/GammaHarmonicData/Plots/Fig333';
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

    if strcmp(subjectName, 'alpa')
        c = 0.25;
    elseif strcmp(subjectName, 'tutu')
        c = 0.6;
    else
        c = 0.5;
    end
    
    powerDB = 10*(log10(psdST)-log10(psdBL));
    [gammaPos, harmonicPos, gammaDB, harmonicDB] = deal(zeros(length(goodPos),length(highRMSElectrodes)));
    for i = 1:length(highRMSElectrodes)
        for j = 1:length(goodPos)
            gammaPos(j,i) = find(freqVals == gammaFreq(j,i));
            harmonicPos(j,i) = find(freqVals == harmonicFreq(j,i));
            gammaDB(j,i) = powerDB(gammaPos(j,i),j,i);
            harmonicDB(j,i) = powerDB(harmonicPos(j,i),j,i);
        end
    end
    
    countTrial = zeros(1,length(goodPos));
    for j = 1:length(goodPos)
        for i = 1:length(highRMSElectrodes)
            if (gammaDB(j,i) >= 10) && (harmonicDB(j,i) >= 3)
                countTrial(j) = countTrial(j) + 1;
            end
        end
    end
    goodTialsInd = find(countTrial >= c*length(highRMSElectrodes));
    
    countElec = zeros(1,length(highRMSElectrodes));
    for i = 1:length(highRMSElectrodes)
        for j = 1:length(goodPos)
            if (gammaDB(j,i) >= 10) && (harmonicDB(j,i) >= 3)
                countElec(i) = countElec(i) + 1;
            end
        end
    end
    goodElecsInd = find(countElec >= c*length(goodPos));

    selectedElecIndices = goodElecsInd;
    selectedTrialIndices = goodTialsInd;

    elecIndSelected = find(countElec == max(countElec),1);
    trialIndSelected = find(countTrial == max(countTrial),1);

    
    % PSD
    PSDst = squeeze(mean(psdST,2)); % mean across trials
    meanPSDST = mean(log10(PSDst),2);
    
    PSDbl = squeeze(mean(psdBL,2) ); % mean across trials
    meanPSDBL = mean(log10(PSDbl),2);

    [freqGamma, freqHarmonic] = findGammaPeak(meanPSDST, freqVals);
    [singleTrialGamma, singleTrialHarmonic] = findGammaPeak(psdST(:,trialIndSelected,elecIndSelected), freqVals);

    figure('units','normalized','outerposition',[0 0 1 1])
    pos1 = [0.1 0.6 0.35 0.3];
    subplot('Position',pos1)

    plot(freqVals,(meanPSDBL)','k','LineWidth',1.5)
    hold on
    plot(freqVals,(meanPSDST)','r','LineWidth',1.5)
    
    plot(freqGamma,(meanPSDST(freqVals == freqGamma)),'ro','HandleVisibility','off');
    text(freqGamma,(meanPSDST(freqVals == freqGamma)),[' G = '  num2str(freqGamma) 'Hz'],'Color','r');
    plot(freqHarmonic,(meanPSDST(freqVals == freqHarmonic)),'ro','HandleVisibility','off');
    text(freqHarmonic,(meanPSDST(freqVals == freqHarmonic)),[' H = ' num2str(freqHarmonic) 'Hz'],'Color','r');

    plot(freqVals,log10(psdST(:,trialIndSelected,elecIndSelected))',':b','LineWidth',1.5)
    plot(singleTrialGamma,log10(psdST((find(freqVals == singleTrialGamma)),trialIndSelected,elecIndSelected)),'bo','HandleVisibility','off');
    text(singleTrialGamma,log10(psdST((find(freqVals == singleTrialGamma)),trialIndSelected,elecIndSelected)),[' G = '  num2str(singleTrialGamma) 'Hz'],'Color','b');
    plot(singleTrialHarmonic,log10(psdST((find(freqVals == singleTrialHarmonic)),trialIndSelected,elecIndSelected)),'bo','HandleVisibility','off')
    text(singleTrialHarmonic,log10(psdST((find(freqVals == singleTrialHarmonic)),trialIndSelected,elecIndSelected)),[' H = ' num2str(singleTrialHarmonic) 'Hz'],'Color','b');
    
    legend('BaseLine', 'Stimulus', 'SingleTrial', 'Location', 'Best')
    xlim([0 150])
    xlabel('Frequency (Hz)','FontSize', 12); ylabel('log10(PSD)','FontSize', 12);
    title([subjectName expType '-' stimType ' PSD'])
    set(gca, 'TickDir', 'out');
    hold off;


    % Raw LFP
    pos2 = [0.55 0.6 0.4 0.3];
    subplot('Position',pos2)
    stimTime = timeVals(stPos);
    hold on
    plot(stimTime, stLFP(:,trialIndSelected,elecIndSelected), 'b', 'LineWidth',1.5);
    plot(stimTime, gammaSig(:,trialIndSelected,elecIndSelected), 'g', 'LineWidth',1.5);
    plot(stimTime, harmonicSig(:,trialIndSelected,elecIndSelected), 'm', 'LineWidth',1.5);
    plot(stimTime, gammaSig(:,trialIndSelected,elecIndSelected) + harmonicSig(:,trialIndSelected,elecIndSelected), '--r', 'LineWidth',1.5);
    legend('LFP','G','H', 'G+H', 'Location', 'Best');
    xlabel('Time (s)','FontSize', 12)
    if strcmp(expType, 'Color')
        xlim([0.25 0.5])
    elseif  strcmp(expType, 'Length')
        xlim([0.5 0.75])
    end
    title('Single Trial LFP')
    set(gca, 'TickDir', 'out');
    hold off;

    % SingleElectrode SingleTrial
    subplot(234)
    rho = RHO(:,trialIndSelected,elecIndSelected);
    polarplot(theta',rho);
    title('Single Trial');

    % SingleElectrode AllTrials 
    subplot(235)
    polarplot(theta',mean(RHO(:,:,elecIndSelected),2));
    hold on
    polarplot(theta',mean(RHO(:,selectedTrialIndices,elecIndSelected),2));
    hold off
    title(['SingleElectrode' ' - (' num2str(length(selectedTrialIndices)) '/' num2str(length(goodPos)) ')']);

    %AllElectrodes AllTrials
    meanRHOall = mean(squeeze((mean(RHO(:,:,:),2))),2);
    meanRHOselected = mean(squeeze((mean(RHO(:,:,selectedElecIndices),2))),2);
    [Mean, Std, rayleighTest] = getPhaseProperties(meanRHOselected);
    subplot(236)
    polarplot(theta',meanRHOall);
    hold on
    polarplot(theta',meanRHOselected);
    hold off
    title(['AllElectrodes' ' - (' num2str(length(selectedElecIndices)) '/' num2str(length(highRMSElectrodes)) ')']);
    
    saveas(gcf,fullfile(plotsFolder,[subjectName expType stimType 'Fig3' '.fig']))
    saveas(gcf,fullfile(plotsFolder,[subjectName expType stimType 'Fig3' '.tiff']))
    
end
