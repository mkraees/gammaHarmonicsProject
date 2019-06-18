% This program does the following

% 1. Computes the power spectral density of the signal 
% 2. Find the maximum power in the range specified by gammaRange. That is the peak gamma frequency
% 3. Compute the power in a band around the peak frequency specified by gammaBandWidth
% 4. Find the maximum power near 2xpeakGammaFreq. Find the peak harmonic power in the same way as step 3
% 5. Band-pass filter the signal around gamma and harmonic peak frequencies
% 6. Compute the analytic signals using hilbet tranform and get the phases

function [peakGammaFreq,harmonicFreq,freqRatio,gammaAmp,harmonicAmp,powerRatio,hilbPhaseDiff]=getGammaAndHarmonicProperties(x,gammaRangeHz,gammaBandwidthHz,tMS)

    if ~exist('gammaRangeHz','var');        gammaRangeHz = [30 75];         end
    if ~exist('gammaBandwidthHz','var');    gammaBandwidthHz = 20;          end

    delta = gammaBandwidthHz/2;
    BW = gammaBandwidthHz;

    Fs = round(1000./(tMS(2)-tMS(1)));
    T  = length(tMS)/1000; % Duration in seconds
    freqVals = 0:1/T:(Fs-1/T);

    fftx = fft(x);
    gammaRangePos = intersect(find(freqVals>=gammaRangeHz(1)),find(freqVals<gammaRangeHz(2)));
    fftGamma = fftx(gammaRangePos);
    gammaAmp = max(abs(fftGamma));
    gammaPos = gammaRangePos(find(abs(fftGamma)==gammaAmp,1));
    peakGammaFreq = freqVals(gammaPos);
%     gammaPhase = angle(fftx(gammaPos));

    estHarmonicFreq = 2*peakGammaFreq;

    harmonicRangePos = intersect(find(freqVals>=estHarmonicFreq-BW),find(freqVals<estHarmonicFreq+BW));
    fftHarmonic = fftx(harmonicRangePos);
    harmonicAmp = max(abs(fftHarmonic));
    harmonicPos = harmonicRangePos(find(abs(fftHarmonic)==harmonicAmp,1));
    harmonicFreq = freqVals(harmonicPos);
%     harmonicPhase = angle(fftx(harmonicPos));

    freqRatio = harmonicFreq/peakGammaFreq;
    powerRatio = harmonicAmp/gammaAmp;
%     phaseDiff  = harmonicPhase-2*gammaPhase;
%     hilbPhaseDiff = 180*phaseDiff;

%     hilbx = hilbert(x);
%     gammaPhaseHilb = unwrap(angle(hilbx(gammaPos)));
%     harmonicPhaseHilb = unwrap(angle(hilbx(harmonicPos)));
%     hilbPhaseDiff = 180*(gammaPhaseHilb-harmonicPhaseHilb);

    n = 4;
    [B,A] = butter(n,[peakGammaFreq-delta, peakGammaFreq+delta]/(Fs/2));
    [D,C] = butter(n,[harmonicFreq-delta, harmonicFreq+delta]/(Fs/2));
    gammaSig = filtfilt(B,A,x);
    harmonicSig = filtfilt(D,C,x);

    G = hilbert(gammaSig);
    H = hilbert(harmonicSig);
    phaseDiffFiltered = (angle(H)-2*angle(G));
    [~,rho] = rose(phaseDiffFiltered,25);
    meanPhaseDiff = getPhaseProperties(rho);
    hilbPhaseDiff = 180*meanPhaseDiff;
end