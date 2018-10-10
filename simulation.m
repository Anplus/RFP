clc;clear;close all;
%% baseband
sample_rate = 2e9;
preamble = [1,0,1,0,0,1];
code  = randi([0,1],1,16);
rn16 = [preamble,code];
BLF = 40e3;
tpri = 1/BLF*sample_rate;
signal = [];
%%
state = 0;
for i = 1:1:length(rn16)
    if rn16(i) ==1
        if state ==1
            signal = [signal, zeros(1,tpri)];
            state = 0;
        else
            signal = [signal, ones(1,tpri)];
            state = 1;
        end
    else
        if state ==1
            signal = [signal, zeros(1,tpri/2), ones(1,tpri/2)];
            state = 1;
        else
            signal = [signal, ones(1,tpri/2), zeros(1,tpri/2)];
            state = 0;
        end   
    end
end
%%
t1 = 500e-6*sample_rate;
signal = [ones(1,t1),0.1*signal+1,ones(1,t1)];

%% modulate
fc = 920e6;
t = 0:1/sample_rate:(length(signal)-1)*1/sample_rate;
carrier = cos(2*pi*fc*t);
receive = signal.*carrier;
figure;
plot(receive);
fft_show(receive,sample_rate);

%% FMCW modulate
tp = 10e-6;
B = 1e6;
t = 0:1/sample_rate:1/sample_rate*tp;
y = chirp(t,fc,t1,fc+B);
receive = signal.*y;
figure;
plot(receive);
fft_show(receive,sample_rate);



