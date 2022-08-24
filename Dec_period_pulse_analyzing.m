%% for stimulus of decreasing period pulse
clear all
close all
clc
path_sort=[''];
try
cd('D:\Experiment_Data\20190408') ; % the folder of the files
catch
cd('') ; % the folder of the files
end
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ; 

%%%%%%%%%%%%%%   user's setting  %%%%%%%%%%%%%%%%%%%%%%
BinningInterval=0.005;
SamplingRate=20000;
roi=[1:60]; %region of interest
trst=1;trnum=3; %sweep trials from trst to trend
f=40;
% p=5;
rest=20;

for m = [1]
    clearvars -except all_file n_file m BinningInterval SamplingRate roi trst trnum f p path_sort rest
    file = all_file(m).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    if isempty(strfind(filename,'tOSR_'))~=1; break; end;   %Those "latency.mat files should be excluded"
    load([filename]);
    name(name=='_')='-';
    
% %%%%%%%%%%%%%%%%%%%%%%  TimeStamps  %%%%%%%%%%%%%%%%%%%
    if size(a_data,1)==1              %only find one analog channel, possibly cause by the setting in MC_rack
        a_data2 = a_data(1,:);
    else
        a_data2 = a_data(3,:);   
    end
    [~,locs]=findpeaks(diff(a_data2),'MINPEAKHEIGHT',3*std(diff(a_data2)));
    analog_loc = (locs)/SamplingRate;
    TimeStamps = analog_loc; % timestamps when the stimuli turns on
    
%% Sorting data

% ==================== for sorted data in mat ========================
% 
%     ss=[29,30,28,27,22,21,14,20,...
%         13,6,12,5,19,11,4,3,10,...
%         18,2,9,1,8,17,7,16,15,26,...
%         25,23,24,32,31,33,34,39,...
%         40,47,41,48,55,49,56,42,...
%         50,57,58,51,43,59,52,60,...
%         53,44,54,45,46,35,36,38,37];
% 
%     Spikes = cell(1,60);
%     load([path_sort,filename(1:end-4),'_sort.mat']);
%     temp_spikes={};
%     for h=1:60
%         if h<11
%             temp_spikes{ss(h)} = eval(['adc00',int2str(h-1)]);
%         else
%             temp_spikes{ss(h)} = eval(['adc0',int2str(h-1)]);
%         end
%     end
%     for i=1:60
%         if isempty(temp_spikes{i})==1
%             continue
%         end
%         for j=1:length(temp_spikes{i}(:,1))
%             if temp_spikes{i}(j,3)==1 % this determine which unit we choose
%                 Spikes{i}=[Spikes{i} temp_spikes{i}(j,1)];
%             end
%         end
%     end

%%%%%%%%%%%%%%%%%%%%%%%%%%  Binning  %%%%%%%%%%%%%%%%%%%%%%%%
% TimeStamps=TimeStamps-2;
    n=0;
    delta=TimeStamps(end)-TimeStamps(end-1);
    while delta<rest
        n=n+1;
        delta=TimeStamps(end)-TimeStamps(end-n);
    end
    TSinTr=(length(TimeStamps(1:end-n)))/3;
    TimeStamps2=TimeStamps(1:TSinTr:length(TimeStamps)); % start time of a trial; TSinTr is total pulse number in one trial
    if length(TimeStamps2)<=(trst+trnum-1)
        trnum = length(TimeStamps2)-trst+1;
    end
    trend=trst+trnum-1;    
    
    n=0;
    delta=TimeStamps(end)-TimeStamps(end-1);
    while delta<rest
        n=n+1;
        delta=TimeStamps(end)-TimeStamps(end-n);
    end
    TSinTr=(length(TimeStamps(1:end-n)))/3;
 
    DataTime = (TimeStamps2(2) - TimeStamps2(1)); % period of one trial
    isi = TimeStamps(2) - TimeStamps(1); % period of pulses
    cut_spikes = seperate_trials(Spikes,TimeStamps2(trst:trend));    

    BinningTime = [ 0 : BinningInterval : DataTime]; 
    
        %%%%%% a3 %%%%%%%%%
    x1 = 0:BinningInterval:DataTime-BinningInterval;
    y1=zeros(1,length(x1)); 
    y1(1:2/BinningInterval)=0.18; %(unit:nA)
    y1(4/BinningInterval:6/BinningInterval)=0.18; %(unit:nA)
    y1(8/BinningInterval:10/BinningInterval)=0.18; %(unit:nA)
        
    y1=a_data(3,TimeStamps(1)*20000:TimeStamps(TSinTr)*20000);
    x1=1/20000:1/20000:length(y1)/20000;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%  Plot Different Trials   %%%%%%%%%%%%%%%%%
%     if length(TimeStamps2)<=18
%         sweepend=length(TimeStamps2);
%     else
%         sweepend=24;
%     end
    sweepend=trend;
    figure;
    set(gcf,'position',[150,30,1024,900])
    h = subplot(sweepend+1,1,1);
    
    for sweepindex=1:sweepend-1
        TimeStampsSweep=TimeStamps2(sweepindex:sweepindex+1); % forcus on which trails 
        cut_spikes = seperate_trials(Spikes,TimeStampsSweep);
        for i = 1:60
            [n,xout] = hist(cut_spikes{i},BinningTime) ; % n: number of spike in a specific binning interval; xout: binning time
            BinningSpike(sweepindex,i,:) = n ;
        end
        subplot(sweepend+1,1,sweepindex);
        plot(BinningTime,squeeze(sum(BinningSpike(sweepindex,roi,:),2)));
    end
        
    subplot(sweepend+1,1,sweepindex+1);
    plot(x1,y1,'r');
    samexaxis('abc','xmt','on','ytac','join','yld',1) % function need ''parseArgs'' function, from matlab center
%     ylim([min(y1)-0.01,max(y1)+0.01]);
    set(get(h,'title'),'string',[name,'  ch',num2str(roi)]);

    %%%%%%%%%%%%%%%%% raster plot %%%%%%%%%%%%%%%%%%%
    BinningSpike2 = sum(BinningSpike(trst:trend-1,:,:),1)/size(BinningSpike,1); % sum of every trail
%     SB=sum(BinningSpike2(1,ch,:),2);
    SB=sum(BinningSpike2(1,roi,:),2)/length(roi)/BinningInterval;
    SB1=squeeze(SB);   
 
    figure
    imagesc(BinningTime,[1:60],squeeze(BinningSpike2));
    title([name,'(sum over ',sprintf('%.0f',length(TimeStamps2)),' trails) ']);
    xlabel('t(s)');ylabel('channel');
    colorbar;
%     saveas(gcf,[name,'_raster.jpg'],'jpg')
%     saveas(gcf,[name,'_raster.fig'],'fig')    
     
%%%%%%%%%%%%%  get peaks  %%%%%%%%%%%%%%%%%%%%%
%     SB1=sum(BinningSpike(chst1:chend1,:),1)/trnum;  
    [spks,slocs]=findpeaks(smooth(SB1),'minpeakdistance',floor(DataTime/BinningInterval/80),'MINPEAKHEIGHT',max(SB1)/30); % minpeakheight is ajustable 

    if isempty(slocs)
        slocstime=NaN;
    end
    lastpulse = DataTime - 5 - isi;
    slocstime=(slocs-1)*BinningInterval; 
    temp = find(slocstime > lastpulse); 
    osrspike = slocstime(temp(1));
    t_OSR = osrspike-lastpulse;
    
%%%%%%%%%%%%%%%%%%%%%%%%%  Plot histogram   %%%%%%%%%%%%%%%%%  
    timefragment=[0 100];
    figure
    subplot(6,1,6);
    plot(x1,y1,'r');xlim(timefragment);
    subplot(6,1,1:5); 
    plot(BinningTime,SB1,'r');xlim(timefragment); %,slocstime,spks,'r*'
    
%     title([name,'   Ch',num2str(roi),sprintf('\n'),' PeakTime(s)=',sprintf('%8.3f',slocstime),sprintf('\n')]);
%     ylabel('firing rate per 5ms');
    hold on
    plot(BinningTime,smooth(SB1),'g');
    plot(BinningTime(slocs), spks,'b*');
    x_ = BinningTime(slocs);  y_ = spks;
    for te = 1:length(x_)
        text(x_(te), y_(te), ['\leftarrow (', num2str(x_(te)), ';', num2str(y_(te)), ')']);
    end
    xlabel('t(s)');
    %%

    title([name,sprintf('\n'),'   t_O_S_R=',num2str(t_OSR)]);
    samexaxis('abc','xmt','on','ytac','join','yld',1) % function need ''parseArgs'' function, from matlab center
end
    
    %% plot single channel
ch = 43;
fr=squeeze(BinningSpike2);
figure('Name',['Ch',num2str(ch)],'NumberTitle','off')
title([name,'   Ch',num2str(ch)]);
ax1=subplot(6,1,2:5); 
plot(BinningTime,fr(ch,:));
ylabel('firing rate per 5ms');
ax2=subplot(6,1,6);
plot(x1,y1,'r');
samexaxis('abc','xmt','on','ytac','join','yld',1) % function need ''parseArgs'' function, from matlab center
xlabel('t(s)');

%% plot average firing rate of several channels
A = [];
B = [];
A = [8 11 43]; % p type cahnnel
B = [9 28 44 45 46 53 54 59 60]; % n type channel
% A=[15 26];
% B=[7 29 30 38];
fr=squeeze(BinningSpike2);
data1=[];
data2=[];
for i=1:length(A)
    data1=[data1;fr(A(i),:)];
end
for i=1:length(B)
    data2=[data2;fr(B(i),:)];
end
mean_fr1=sum(data1,1)/length(A);
mean_fr2=sum(data2,1)/length(B);
subplot(6,1,2:5); 
plot(BinningTime,mean_fr2,'Color','b','DisplayName','average firing rate of N type cells');hold on;
plot(BinningTime,mean_fr1,'Color','g','DisplayName','average firing rate of P type cells');

title(name);
ylabel('firing rate per 5ms');
subplot(6,1,6);
plot(x1,y1,'r');
samexaxis('abc','xmt','on','ytac','join','yld',1) % function need ''parseArgs'' function, from matlab center
xlabel('t(s)');