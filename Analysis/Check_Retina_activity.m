% Calculate spike number according to stimuli sequence
clear; close all

% load('\\192.168.0.102\Public\Retina\Chou\stimulus_saving\01-Sep-2022\stimuli_seq_01-Sep-2022_17-0.mat')
% filename_part=cell(size(parameters,1),1);
% for i=1:size(parameters,1)
%     [path_part filename_part{i} ext_part]=fileparts(parameters(i,2));
% end

path_diode='\\192.168.0.102\Public\Retina\Chou\Exp\20220907\07-Sep-2022\';
path_data='\\192.168.0.102\Public\Retina\Chou\Exp\20220907\SplitData\';
cd(path_diode)
all_file=dir('*.mat');
recording_time=cell(length(all_file),1);
for i=1:length(all_file)
    recording_time{i}=all_file(i).date;
end
[time,t_ind]=sort(recording_time); % t_ind 

%% load exp data to check spike number
spike_numbers=zeros(length(all_file),60);
for i=1:length(all_file)
    load([path_data,all_file(t_ind(i)).name])
    for j=1:60
        spike_numbers(i,j)=length(Spikes{j});
    end
%     figure(1);plot(i*ones(1,60),spike_numbers(i,:),'o');hold on
    figure(2);plot(1:60,spike_numbers(i,:),'o-');hold on % plot firing rate according to different datasets
end
for i=1:60 % plot firing rate change according to channels
    figure(3);plot(1:length(all_file),spike_numbers(:,i),'o-');hold on
end

% calcuating errorbar
for i=1:60
    std_of_channels=std(spike_numbers,0,2);
    mean_of_channels=mean(spike_numbers,2);
end
figure(4)
errorbar(1:length(all_file),mean_of_channels,std_of_channels)

%% check MI height
% path_MI='\\192.168.0.102\Public\Retina\Chou\Exp\20220901\SplitData\MIandSTA\';
% MI_heights=zeros(30,60);
% for i=1:length(all_file)
%     [path_MI2,filename_MI,ext_MI]=fileparts(all_file(t_ind(i)).name);
%     load([path_MI,filename_MI,'_MI.mat'])
%     for j=1:60
%         MI_heights(i,j)=max(MI{j});
%     end
% end
% for i=1:60
%     plot(1:length(all_file),MI_heights(:,i),'o-');hold on
% end
% 
