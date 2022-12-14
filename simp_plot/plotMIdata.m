clear all
close all

path='G:\我的雲端硬碟\september_2022_expdata\20220916\MIandSTA';
cd(path)
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file);
cc=hsv(n_file);

        rr =[9,17,25,33,41,49,...
          2,10,18,26,34,42,50,58,...
          3,11,19,27,35,43,51,59,...
          4,12,20,28,36,44,52,60,...
          5,13,21,29,37,45,53,61,...
          6,14,22,30,38,46,54,62,...
          7,15,23,31,39,47,55,63,... 
            16,24,32,40,48,56];
roi = [1:60];
filelistMI=[];
filelistSTA=[];
MI_savedata=[];

for z = [11 13 12 14 15]  % 5 9 13 17
    file = all_file(z).name;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([filename]);
    name(name=='_')='-';
    TS=TimeShift;
    
    %% plot multichannel data
    figure(2);
    for i=1:60
        subplot(8,8,rr(i));hold on;title(num2str(i))
        plot(TimeShift,MI{i},'LineWidth',1,'LineStyle','-');
        xlim([-1000 1000])
    end
    
    file_onoff='F:\我的雲端硬碟\Retina exp\exp data\整理\OnOff_index\20200318-onoff2-sort-unit2onoff_index.mat';
    onoff_color(file_onoff)
    file_NP='F:\我的雲端硬碟\Retina exp\exp data\整理\NP_classification\20200318_OU_tau=op5_2_sort_unit2_MI_also_other_parameters.mat'
    NPcolor(file_NP)
    
    %% plot singlechannel data
    figure(3);hold on;box on
    channel=7;
%     title(['channel ',num2str(channel)])
    plot(TimeShift,MI{channel},'LineWidth',1.5,'LineStyle','-')
    xlim([-1000 1000])
    xlabel('\deltat (ms)')
    ylabel('MI (bits/s)')
    ax = gca;
    ax.XGrid = 'on';
%     xline(0,'--')
    %% plot figure of every channel and STA
%     file = all_file(filelistSTA(z)).name ;
%     [pathstr, name, ext] = fileparts(file);
%     directory = [pathstr,'\'];
%     filename = [name,ext];
%     load([filename]);
%     mkdir MIfigure
%     for channel=1:60
%         figure(channel)
% %         subplot(2,1,1);hold on;box on
%         plot(TS,MI{channel},'LineWidth',2,'LineStyle','-')
%         xlabel('\deltat (ms)')
%         ylabel('MI (bits/s)')
%         title(['MI  channel ',num2str(channel)])
%         ax = gca;ax.XGrid = 'on';xline(0)
%         subplot(2,1,2);hold on;box on
%         plot(TimeShift{channel},STAAAAA{channel},'LineWidth',2,'LineStyle','-')
%         title(['STA  channel ',num2str(channel)])
%         xlim([-1000 1000])
%         xlabel('time to spike (ms)')
%         ylabel('STA')
end
    
    %% save data
%     saving_channel=39;

% cd([path,'\MIfigure']);mkdir(name);cd([path,'\MIfigure\',name])
% for i=1:60;figure(i);
%     legend('no filter','fc=10','fc=7','fc=4','fc=2');saveas(gcf,[path,'\MIfigure\',name,'\',name,'_channel',num2str(i),'.png']);
% end


%% save xls file
% MI_savedata=[TS' MI_savedata];
% path_data='F:\我的雲端硬碟\Retina exp\Retina as NGD paper submit\data';
% data_name='0419 data.xls'
% writematrix(MI_savedata,fullfile(path_data,data_name))