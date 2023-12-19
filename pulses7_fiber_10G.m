% pulses_fiber_10G.m
clear all;	warning on;
mm = 4096; % 2048, 4096, 8192, 16384,
global c

 c = 2.99792458 * 1e8;	%m/sec
  centerfreq = 194.05*1e12;
  widthfreq = 1000*1e9;	%Hz
startfreq = centerfreq - 0.5.* widthfreq
 stepfreq = widthfreq / mm; % Hz
 
   distance = 1 * 1000;
  eyezoomin = 6;
  NRZ = 50;
   judgevoltage = 0.5;
   bitrate = 10e9; %1073741824	% bps;
   timeperbit = 1/(bitrate)
  pulsestowatch = 10;
  
   b = 0.0;
   
 %____________________________________________________
 
 [freqcol, wlcol, omegacol, kcol] = wl_freq_omega(mm, stepfreq, startfreq );

%___________________________________________________________________________

[ncorecol, Ncorecol, scorecol] = sellmeiercore(1e6.* wlcol);	%get index !! input wavelength as um
 betacorecol = kcol.* ncorecol;

[ncladcol, Ncladcol, scladcol] = sellmeierclad(1e6.* wlcol);	%get index !! input wavelength as um
 betacladcol = kcol.* ncladcol;

betacol = kcol.* sqrt((ncladcol).^2 + ((ncorecol).^2 - (ncladcol).^2) .* b);
  
 %___________________________________________________________________________
 
 polyfitbeta = polyfit(omegacol,betacol,3);%fitting by 3rd order
 betaestcol = polyval(polyfitbeta,omegacol);% get
 
 dpolyfitbeta = polyder(polyfitbeta);%derivate
 dbetadomegacol = polyval(dpolyfitbeta,omegacol);%get
 
 fig2 = figure(2);
 set(fig2,'Position',[100 400 600 300])
plot(1e-12.* omegacol,1.0001e-6.* betacol,'r-',...
   1e-12.* omegacol,1e-6.* betaestcol,'g-',...
      1e-12.* omegacol,1e-6.* betacorecol,'b-',...
   1e-12.* omegacol,1e-6.* betacladcol,'y-');

xlabel('T [Hz]','FontSize',12); 	ylabel('beta [rad / m]','FontSize',9);
  
%fig5 = figure(5);
%set(fig5,'Position',[320 50 400 300])
%plot(1e-12.* omegacol,dbetadomegacol);
%xlabel('T','FontSize',9);  
%ylabel('dbetadomega','FontSize',9);

 polyfitdbetadomega = polyfit(omegacol,dbetadomegacol,2);%fitting
 dpolyfitbetadomega = polyder(polyfitdbetadomega);%derivate
 ddbetaddomegacol = polyval(dpolyfitbetadomega,omegacol);%get

fig3 = figure(3);
set(fig3,'Position',[320 50 500 320])
plot(1e-12.* freqcol, 1e24.* ddbetaddomegacol); 
% probably correct !! p.73 of NTT book.
xlabel('freq [THz]','FontSize',9);
ylabel('ddbetaddomega [ps^2 / m] ','FontSize',9);

 Dcol = -1.* omegacol.* ddbetaddomegacol ./ wlcol;

fig4 = figure(4);
set(fig4,'Position',[320 50 500 320])
plot(1e-12.* freqcol, 1e6.* Dcol); 
% probably correct !! p.73 of NTT book.
xlabel('freq [THz]','FontSize',9);
ylabel('D [ps/(nm*km)]','FontSize',12);

%___________________________________________________________
  tstep = 1/(stepfreq*mm*1) % sec I think this sould be 1 !! not 2 !!!!

resolutionperpulse = timeperbit / tstep
[tcol, pulsescol] = signalgenerate_square(mm, tstep, bitrate, resolutionperpulse, NRZ);

fftpulsescol = (fft(pulsescol));
freqmax = 1/tstep 
fcol = [freqmax/mm : freqmax/mm : freqmax]';

fig5 = figure(5);
set(fig5,'Position',[320 400 600 270])
plot(1e-9*fcol, abs(fftpulsescol).^2)
xlabel(' GHz','FontSize',9);
xlim([0 1.0*1e-9* freqmax])
title('Power');
% make profile

nfftpulsescol = [fftpulsescol(0.5*mm+1:mm);fftpulsescol(1:0.5*mm)];

fig7 = figure(7);
set(fig7,'Position',[320 50 300 270])
plot(1e-9*fcol, abs(nfftpulsescol).^2)
xlabel('GHz');title('Power');

%___________________________________________________________

expFcol = zeros(mm,1);
for ii = 1:mm
   gamma = 0.5 .* ddbetaddomegacol(ii) .* omegacol(ii).^2;
   expF = exp(-j.* gamma .* distance) .* nfftpulsescol(ii) ;
   %expF = nfftpulsescol(ii);

   expFcol(ii,1) = expF;
end

%fig8 = figure(8);
%set(fig8,'Position',[320 50 700 270])
%plot(abs(nfftpulsescol) + 100,'r');hold on;
%plot(abs(expFcol), 'b');hold off;

nexpFcol = [expFcol(0.5*mm+1:mm);expFcol(1:0.5*mm)];
ifftnexpFcol = ifft(nexpFcol);

fig9 = figure(9);
set(fig9,'Position',[20 50 1100 270])
plot(1e9.* tcol,abs(pulsescol).^2,'r-',...
   1e9.* tcol,abs(ifftnexpFcol).^2,'b-');%,1e9.* tcol,real(pulses2col),'g-')
xlabel(' nanosec','FontSize',9);grid on;
title('Power');
maxt = 1e9.* max(tcol)
xlim([0, timeperbit * pulsestowatch *1e9])
ylim([0, 2])

eyepatternstep = resolutionperpulse * 1.5
ttcol = zeros(mm,1);
for ii = 1:mm
   tt = mod(ii,eyepatternstep);  
   ttcol(ii,1) = tt * tstep;
end

fig10 = figure(10);
set(fig10,'Position',[20 100 600 270]);
plot(1e9.* ttcol,abs(pulsescol).^2,'r.',1e9.* ttcol,abs(ifftnexpFcol).^2,'b.-',...
   1e9.* tstep .* [eyezoomin eyezoomin],[0,1.5],'g-');
xlabel(' nanosec','FontSize',9);grid on;
title('Power');

      [nvaluzerocol, nvaluonecol] =...
   eyepattern_func(mm, ifftnexpFcol, eyepatternstep, eyezoomin, judgevoltage);


   
   [meanzero, stdzero, meanone, stdone, Q, ber] = ...
      getber(nvaluzerocol, nvaluonecol)
disp('****************************************************')
   
%fig11 = figure(11);
%set(fig11,'Position',[20 100 600 270])
%stem(valucol,'o-');



