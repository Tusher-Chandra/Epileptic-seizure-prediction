%%
clear all;
close all;
clc
loc= 'D:\EEE400FT\nonseiz(filtered)';
loc2 = 'D:\EEE400FT\features\non seizure';
addpath  ('D:\EEE400FT\MAT FILES(10sub)')
sf = 250;
load('nonseizinfo.mat');

a=nonseiz(:,1);
b=nonseiz(:,2);
in=1;
for i = 1:length(nonseizsamsize)
    load(sprintf('Sub%d.mat',i));
    
    EEG = double(EEGDATA(1:7,:));
    for j=1:nonseizsamsize(i)
        EEGS = EEG(:,a(j)*sf+1:b(j)*sf);
        file=sprintf('sub%dnsam%d.mat',i,j);
        for k = 1:length(EEGS(:,1))
            %%feature
            f1(1,k) = jfeeg('var', EEGS(k,:));
            f2(1,k) = jfeeg('kurt', EEGS(k,:));
            f3(1,k)  = jfeeg('skew',EEGS(k,:));
            f4(1,k)  = jfeeg('max',EEGS(k,:));
            f5(1,k)  = jfeeg('min',EEGS(k,:));
            f6(1,k)  = jfeeg('sh',EEGS(k,:));
          
            EEGSF(k,:) =  Bandpass_Seiz(double(EEGS(k,:)),4,25,0.5,250);
            
            f11(1,k) = jfeeg('var', EEGSF(k,:));
            f22(1,k) = jfeeg('kurt', EEGSF(k,:));
            f33(1,k)  = jfeeg('skew',EEGSF(k,:));
            f44(1,k)  = jfeeg('max',EEGSF(k,:));
            f55(1,k)  = jfeeg('min',EEGSF(k,:));
            f66(1,k)  = jfeeg('sh',EEGSF(k,:));
        end
         nonsezfeat(in,:) = [f1,f2,f3,f4,f5,f6,0];
         fnonsezfeat(in,:) = [f11,f22,f33,f44,f55,f66,0];
         in = in +1;
        save (fullfile(loc,file),'EEGS','EEGSF')
    end
    EEG = [];
end
save (fullfile(loc2,'nonsezfeat.mat'),'nonsezfeat','fnonsezfeat')

