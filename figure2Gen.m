
saveFolder = '/home/me/GammaHarmonicData/savedData/Power';
if isfile(fullfile(saveFolder,'GHpowers.mat'))
    load(fullfile(saveFolder,'GHpowers.mat'));
    disp('Variables loaded from Memory')
else
    tutuColorGammaPower = [];
    alpaColorGammaPower = [];
    alpaLengthGammaPower = [];
    kesariLengthGammaPower = [];
    kesariColorGammaPower = [];

    tutuColorHarmonicPower = [];
    alpaColorHarmonicPower = [];
    alpaLengthHarmonicPower = [];
    kesariLengthHarmonicPower = [];
    kesariColorHarmonicPower = [];

    [gammaAmp, harmonicAmp] = getGHPower('tutu', 'Color', '0');
    tutuColorGammaPower = cat(1,tutuColorGammaPower,gammaAmp);
    tutuColorHarmonicPower = cat(1,tutuColorHarmonicPower,harmonicAmp);

    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Color', '0');
    alpaColorGammaPower = cat(1,alpaColorGammaPower,gammaAmp);
    alpaColorHarmonicPower = cat(1,alpaColorHarmonicPower,harmonicAmp);

    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Color', '0');
    kesariColorGammaPower = cat(1,kesariColorGammaPower,gammaAmp);
    kesariColorHarmonicPower = cat(1,kesariColorHarmonicPower,harmonicAmp);

    hue = 10:10:90;
    Hue = num2str(hue(:));
    for i =1: length(hue)
        [gammaAmp, harmonicAmp] = getGHPower('tutu', 'Color', Hue(i,:));
        tutuColorGammaPower = cat(1,tutuColorGammaPower,gammaAmp);
        tutuColorHarmonicPower = cat(1,tutuColorHarmonicPower,harmonicAmp);
        [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Color', Hue(i,:));
        alpaColorGammaPower = cat(1,alpaColorGammaPower,gammaAmp);
        alpaColorHarmonicPower = cat(1,alpaColorHarmonicPower,harmonicAmp);
        [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Color', Hue(i,:));
        kesariColorGammaPower = cat(1,kesariColorGammaPower,gammaAmp);
        kesariColorHarmonicPower = cat(1,kesariColorHarmonicPower,harmonicAmp);
        disp(hue(i));
    end

    close all
    hue = 100:10:350;
    Hue = num2str(hue(:));
    for i =1: length(hue)
        [gammaAmp, harmonicAmp] = getGHPower('tutu', 'Color', Hue(i,:));
        tutuColorGammaPower = cat(1,tutuColorGammaPower,gammaAmp);
        tutuColorHarmonicPower = cat(1,tutuColorHarmonicPower,harmonicAmp);
        [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Color', Hue(i,:));
        alpaColorGammaPower = cat(1,alpaColorGammaPower,gammaAmp);
        alpaColorHarmonicPower = cat(1,alpaColorHarmonicPower,harmonicAmp);
        [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Color', Hue(i,:));
        kesariColorGammaPower = cat(1,kesariColorGammaPower,gammaAmp);
        kesariColorHarmonicPower = cat(1,kesariColorHarmonicPower,harmonicAmp);
        disp(hue(i));
    end

    disp('kesari');
    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Length', 'con0');
    kesariLengthGammaPower = cat(1,kesariLengthGammaPower,gammaAmp);
    kesariLengthHarmonicPower = cat(1,kesariLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Length', 'con25');
    kesariLengthGammaPower = cat(1,kesariLengthGammaPower,gammaAmp);
    kesariLengthHarmonicPower = cat(1,kesariLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Length', 'con50');
    kesariLengthGammaPower = cat(1,kesariLengthGammaPower,gammaAmp);
    kesariLengthHarmonicPower = cat(1,kesariLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Length', 'con75');
    kesariLengthGammaPower = cat(1,kesariLengthGammaPower,gammaAmp);
    kesariLengthHarmonicPower = cat(1,kesariLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('kesari', 'Length', 'con100');
    kesariLengthGammaPower = cat(1,kesariLengthGammaPower,gammaAmp);
    kesariLengthHarmonicPower = cat(1,kesariLengthHarmonicPower,harmonicAmp);

    disp('alpa')
    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Length', 'con0');
    alpaLengthGammaPower = cat(1,alpaLengthGammaPower,gammaAmp);
    alpaLengthHarmonicPower = cat(1,alpaLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Length', 'con25');
    alpaLengthGammaPower = cat(1,alpaLengthGammaPower,gammaAmp);
    alpaLengthHarmonicPower = cat(1,alpaLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Length', 'con50');
    alpaLengthGammaPower = cat(1,alpaLengthGammaPower,gammaAmp);
    alpaLengthHarmonicPower = cat(1,alpaLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Length', 'con75');
    alpaLengthGammaPower = cat(1,alpaLengthGammaPower,gammaAmp);
    alpaLengthHarmonicPower = cat(1,alpaLengthHarmonicPower,harmonicAmp);
    [gammaAmp, harmonicAmp] = getGHPower('alpa', 'Length', 'con100');
    alpaLengthGammaPower = cat(1,alpaLengthGammaPower,gammaAmp);
    alpaLengthHarmonicPower = cat(1,alpaLengthHarmonicPower,harmonicAmp);
    
    save(fullfile(saveFolder,'GHpowers.mat'),'tutuColorGammaPower','alpaColorGammaPower', 'alpaLengthGammaPower',...
    'kesariLengthGammaPower', 'kesariColorGammaPower', 'tutuColorHarmonicPower',...
    'alpaColorHarmonicPower', 'alpaLengthHarmonicPower', 'kesariLengthHarmonicPower', 'kesariColorHarmonicPower');
end

xa = 10; ya = 2;
xCalpa = 10; yCalpa = 2;
xCtutu = 10; yCtutu = 2;

alpaColorCases = intersect(find(alpaColorGammaPower >= xCalpa),find(alpaColorHarmonicPower >= yCalpa));
alpaLengthCases = intersect(find(alpaLengthGammaPower >= xa),find(alpaLengthHarmonicPower >= ya));
kesariColorCases = intersect(find(kesariColorGammaPower >= xa),find(kesariColorHarmonicPower >= ya));
kesariLengthCases = intersect(find(kesariLengthGammaPower >= xa),find(kesariLengthHarmonicPower >= ya));
tutuColorCases = intersect(find(tutuColorGammaPower >= xCtutu),find(tutuColorHarmonicPower >= yCtutu));

save(fullfile(saveFolder,'selectedCases.mat'),'alpaColorCases', 'alpaLengthCases', 'kesariColorCases',...
    'kesariLengthCases', 'tutuColorCases');
    
% Plot
figure()
greys = {[0.8 0.8 0.8],[0.6 0.6 0.6],[0.4 0.4 0.4],[0.2 0.2 0.2],[0 0 0]};
subplot(131)
hold on
for i = 1:36
    scatter(alpaColorGammaPower(i),alpaColorHarmonicPower(i), 50, hsv2rgb([(i-1)/36 1 1]),'filled');
end

for i =1:5
    scatter(alpaLengthGammaPower(i),alpaLengthHarmonicPower(i),100, greys{i},'filled');
end
xlim([0 22]); ylim([-2 10]);
xlabel('GammaPower in dB','FontSize',11,'FontWeight','bold'); ylabel('HarmonicPower in dB','FontSize',11,'FontWeight','bold');
plotClassifier(ylim,xlim,xCalpa,yCalpa)
hold off
title('M1')

subplot(132)
hold on
for i = 1:36
    scatter(kesariColorGammaPower(i),kesariColorHarmonicPower(i), 50, hsv2rgb([(i-1)/36 1 1]),'filled');
end
for i = 1:5
    scatter(kesariLengthGammaPower(i),kesariLengthHarmonicPower(i),100, greys{i},'filled');
end
xlim([0 22]); ylim([-2 10]);
xlabel('GammaPower in dB','FontSize',11,'FontWeight','bold'); ylabel('HarmonicPower in dB','FontSize',11,'FontWeight','bold');
plotClassifier(ylim,xlim,xa,ya)
hold off
title('M2')

subplot(133)
hold on
for i = 1:36
    scatter(tutuColorGammaPower(i),tutuColorHarmonicPower(i), 50, hsv2rgb([(i-1)/36 1 1]),'filled');
end
xlim([0 22]); ylim([-2 10]);
xlabel('GammaPower in dB','FontSize',11,'FontWeight','bold'); ylabel('HarmonicPower in dB','FontSize',11,'FontWeight','bold');
plotClassifier(ylim,xlim,xCtutu,yCtutu)
hold off
title('M3')
