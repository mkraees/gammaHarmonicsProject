function saveData(subjectName, expType, stimType)
    saveFolder = '/home/me/GammaHarmonicData/savedData';
    makeDirectory(saveFolder);
    
    if isfile(fullfile(saveFolder,[subjectName expType stimType '.mat']))
        disp('Variables loaded from Memory')
    else
        clearvars -except subjectName expType stimType saveFolder
        [highRMSElectrodes, goodPos, Fs, stPos, blPos, mt, folderLFP, timeVals, stimPeriod, baselinePeriod, folderSourceString] = getSubjectDetails(subjectName, expType, stimType); %#ok<ASGLU>
        [freqVals,psdST,psdBL,baseCorrectedLog10PSD, theta, RHO, stLFP, gammaSig, harmonicSig, gammaFreq, harmonicFreq, gammaAmp, harmonicAmp, harmonicFreqActual, harmonicAmpActual] = getPSDandPhase(highRMSElectrodes,folderLFP,goodPos,stPos,blPos,mt,Fs); %#ok<ASGLU>
        save(fullfile(saveFolder,[subjectName expType stimType '.mat']));
        disp('Variables Saved')
    end
end