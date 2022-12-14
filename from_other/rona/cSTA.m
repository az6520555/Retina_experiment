clear all
close all
cd('E:\Chou\20210701\SplitData');
all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file); 
SamplingRate = 20000;
cc = hsv(3);
rr = [9,17,25,33,41,49,...
      2,10,18,26,34,42,50,58,...
      3,11,19,27,35,43,51,59,...
      4,12,20,28,36,44,52,60,...
      5,13,21,29,37,45,53,61,...
      6,14,22,30,38,46,54,62,...
      7,15,23,31,39,47,55,63,...
        16,24,32,40,48,56];
roi = [1:60];
    
for z = []
    clearvars -except all_file n_file z SamplingRate cc ey isi2 statispks statistime w fr information rr STA roi
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([filename]);
    name(name=='_')='-';
    bin = 10;  BinningInterval = bin*10^-3;  %ms

%% diode as TriggerData
%     load(['E:\google_rona\20170929\diode\diode_',filename]);
%     [~,locs_a2]=findpeaks(diff(diff(a2)),'MINPEAKHEIGHT',5*std(diff(diff(a2))));
%     TimeStamps_a2 = (locs_a2)/SamplingRate;
%     TriggerData = eyf(TimeStamps_a2(1)*SamplingRate:TimeStamps_a2(end)*SamplingRate);% figure;plot(isi);
%% a_data as TriggerData  
    TriggerData = a_data(3,TimeStamps(1)*SamplingRate:TimeStamps(length(TimeStamps))*SamplingRate);% figure;plot(isi);
    inten = downsample(TriggerData,SamplingRate*BinningInterval);

%% spike process
    BinningTime = [TimeStamps(1) : BinningInterval : TimeStamps(end)];
    BinningSpike = zeros(60,length(BinningTime));
    for i = 1:60
        [n,xout] = hist(Spikes{i},BinningTime) ;
        BinningSpike(i,:) = n ;
    end
     BinningSpike(:,1) = 0;BinningSpike(:,end) = 0;    
     temprr=0;

%% STA
    for nn = 1:length(roi)
        spike = BinningSpike(roi(nn),:);

        window = 1;  %STA window
        window2 = 1;
        sts = [];
        temp = 0;
        spike(1:window/BinningInterval) = 0;
        spike(length(spike)-window2/BinningInterval-10:end) = 0;
        for in = 1:length(spike)
           if spike(in)~=0
              temp = temp+1;
              sts(temp,:) = spike(in)*inten(in-round(window/BinningInterval):in+round(window2/BinningInterval));
           end
        end
        STA = sum(sts)/sum(spike);%;
        STA = STA-STA(end);
        STA = STA/max(abs(STA));
%         figure(roi(nn));hold on;
        figure(300);subplot(8,8,rr(nn));
        STA = STA/max(abs(STA));
        t = [-window*1000:bin:window2*1000];
        plot(t,STA,'LineWidth',1.5);%,'color',cc(z,:)
       
    end
end

   