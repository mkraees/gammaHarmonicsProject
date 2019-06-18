function [freqVals,psdST,psdBL,baseCorrectedLog10PSD, theta, RHO, stLFP, gammaSig, harmonicSig, gammaFreq, harmonicFreq, gammaAmp, harmonicAmp, harmonicFreqActual, harmonicAmpActual] = getPSDandPhase(highRMSElectrodes,folderLFP,goodPos,stPos,blPos,mt,Fs)
% PSD = 3D Array - (Freq, trialIndex, electrodeInd)
% RHO = 3D Array - (100, trialIndex, electrodeInd)
    n = 4; % order of butterWorth Filt
    delta = 10;
    
    gammaRangeHz =[30 70];
    
    psdST = []; psdBL = []; baseCorrectedLog10PSD = []; RHO = [];
    stLFP = []; gammaSig = []; harmonicSig = []; gammaFreq = []; harmonicFreq = []; harmonicFreqActual = [];
    gammaAmp = []; harmonicAmp = []; harmonicAmpActual = [];
    for i = 1:length(highRMSElectrodes)
        load(fullfile(folderLFP,['elec' num2str(i)]),'analogData');
        stLFPP = analogData(goodPos,stPos)';
        blLFP = analogData(goodPos,blPos)';
        [psdSTelec,freqVals] = mtspectrumc(stLFPP,mt);
        psdBLelec = mtspectrumc(blLFP,mt);
        psdST = cat(3,psdST,psdSTelec);
        psdBL = cat(3,psdBL,psdBLelec);
        baseCorrectedLog10PSD = cat(3,baseCorrectedLog10PSD,log10(psdSTelec)-log10(psdBLelec));
        stLFP = cat(3,stLFP,stLFPP);
        
        gammaRangePos = intersect(find(freqVals>=gammaRangeHz(1)),find(freqVals<gammaRangeHz(2)));
        gammaRange = baseCorrectedLog10PSD(gammaRangePos,:,i);
        gammaAmpLog = max(gammaRange); % Amp difference from BL
        [gammaPosInd,~] = find(gammaRange==gammaAmpLog);
        gammaPos = gammaRangePos(gammaPosInd);
        peakGammaFreq = freqVals(gammaPos);
        gammaFreq = cat(2,gammaFreq,peakGammaFreq');
        
        peakHarmonicFreqExact = 2*peakGammaFreq; % Exact Harmonic
        harmonicFreq = cat(2,harmonicFreq,peakHarmonicFreqExact');
        harmonicPos = 2.*gammaPos-1;
        
        %original Harmonic
        harmonicFreqActualElec = [];
        harmonicPosActual = zeros(1,length(goodPos));
        for j =1:length(goodPos)
            harmonicRangePos = intersect(find(freqVals>=peakHarmonicFreqExact(j)-delta),find(freqVals<peakHarmonicFreqExact(j)+delta));
            harmonicRange = baseCorrectedLog10PSD(harmonicRangePos,j,i);
            harmonicAmpLog = max(harmonicRange); % Amp difference from BL
            [harmonicPosInd,~] = find(harmonicRange==harmonicAmpLog);
            harmonicPosActual(j) = harmonicRangePos(harmonicPosInd);
            peakHarmonicFreqActual = freqVals(harmonicPosActual(j));
            harmonicFreqActualElec = cat(2,harmonicFreqActualElec,peakHarmonicFreqActual');
        end
        harmonicFreqActual = cat(2,harmonicFreqActual,harmonicFreqActualElec');
        
        
        Rho = []; gammaSIG = []; harmonicSIG = [];
        gammaAmps = zeros(1,length(gammaPos)); harmonicAmps = zeros(1,length(gammaPos)); harmonicAmpsActual = zeros(1,length(gammaPos));
        for j =1:length(goodPos)
            [B,A] = butter(n,[peakGammaFreq(j)-delta, peakGammaFreq(j)+delta]/(Fs/2));
            [D,C] = butter(n,[peakHarmonicFreqExact(j)-delta, peakHarmonicFreqExact(j)+delta]/(Fs/2));
            
            gammaSignal = filtfilt(B,A,stLFPP(:,j));
            harmonicSignal = filtfilt(D,C,stLFPP(:,j));

            G = hilbert(gammaSignal);
            H = hilbert(harmonicSignal);
            phaseDiff = (angle(H)-2*angle(G));
            [theta,rho] = rose(phaseDiff,25); % 25*4
            Rho = cat(2,Rho,rho');
            
            gammaSIG = cat(2,gammaSIG,gammaSignal);
            harmonicSIG = cat(2,harmonicSIG,harmonicSignal);
            
            gammaAmps(j) = psdSTelec(gammaPos(j),j);
            harmonicAmps(j) = psdSTelec(harmonicPos(j),j);
            harmonicAmpsActual(j) = psdSTelec(harmonicPosActual(j),j);
        end
        RHO = cat(3,RHO,Rho);
        gammaSig = cat(3,gammaSig,gammaSIG);
        harmonicSig = cat(3,harmonicSig,harmonicSIG);
        gammaAmp = cat(2,gammaAmp,gammaAmps');
        harmonicAmp = cat(2,harmonicAmp,harmonicAmps');
        harmonicAmpActual = cat(2,harmonicAmpActual,harmonicAmpsActual');
    end 
end