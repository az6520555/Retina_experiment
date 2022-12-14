% white noise stimulus
clearvars -except L
close all
savepath='\\192.168.0.102\Public\Retina\Chou\stimuli_data\20220916_stimuli\';
Tot=300;
dt=0.05;
x_rand=randn(1,Tot/dt);
%% different mean different contrast 20211008
mean_set=[2 5 10 15];
C_set=[0.05,0.1,0.15,0.2,0.3];

for i=1:length(mean_set)
    figure(i*878);hold on
    for j=1:length(C_set)
        mean=mean_set(i);
        amp=mean*C_set(j);
        [t,ey,a2]=generate_stimulus(x_rand,mean,amp,dt);
        plot(t,ey)
        save([savepath,'\WhiteNoise_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'t','ey','a2')
    end
end

%% 
% amp_set=[0.5,1,1.5,2,3];
% for i = 1%:length(amp_set)
%     mean=10;
%     amp=2 %amp_set(i);
%     [t,inten,a2]=generate_stimulus(x_rand,mean,amp,dt);
% %     save([savepath,'\WhiteNoise_mean=',num2str(mean),'_amp=',num2str(amp),'.mat'],'t','inten','a2')
%     plot(t,inten,'linewidth',1);hold on
% end

% title('White noise stimulus')
% xlabel('time (s)')
% ylabel('light intensity (mW/m^2)')
% set(gcf,'Position',[300,300,600,300])
% xlim([100,104])