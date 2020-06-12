%Mingshuang Li, UT Austin, 2020.06.06
%Waveform and spectrum, based on matlab
clear;

wavefile = input('Please type in the wave file name: ', 's');
[waveform, fs] = audioread(wavefile);

waveform = waveform(:,1);
    dt = 1/fs;
    t = 0:dt:(length(waveform)*dt)-dt; % analysis the duration of audio file
    
% plot the waveform    
figure;    
plot(t(1:fs),waveform(1:fs)); xlabel('Seconds'); ylabel('Amplitude');

m = length(waveform);       % original sample length
n = input('FFT frequency: ');
y = fft(waveform,n);

f = (0:n-1)*(fs/n);
intensity = 10*log10(abs(y))+ 58.227; %calibrated with praat, the accuracy can not be guaranteed
% plot the spectrum (FFT)
figure;
plot(f(1:fix(n/5)),intensity(1:fix(n/5))) % Frequency range of the FFT analysis can be modified 
xlabel('Frequency (Hz)')
ylabel('Intensity (dB)')

% plot the spectrum with power as the y-axis 
figure;
pspectrum(waveform,fs);


waveform = single( waveform(:, 1) );
nsamples = length(waveform);

% LTSA configuration
div_len = round(.5 * fs);
subdiv_len = floor(div_len/6);
nfft = subdiv_len;
noverlap = round( subdiv_len/4 );

tic
ltsa = ltsa_process(waveform, div_len, subdiv_len, noverlap, nfft);
toc


figure;
ltsa_view(ltsa, fs, nsamples, [0 10000]);% frequency range: 0:10000

