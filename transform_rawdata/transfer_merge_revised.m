clear 
MergeName='20220901_whole_field.mat'; % mat file of offlinesorter output 
ListName='20220901_list.txt'; % filenames list
path='\\192.168.0.102\Public\Retina\Chou\Exp\20220901\'; % mat file directory of offlinesorter output 
path_separated='\\192.168.0.102\Public\Retina\Chou\Exp\20220901\SplitData\'; % directory providing the files (splitdata)
load([path,MergeName])
channel = [12,13,14,15,16,17,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67,68,71,72,73,74,75,76,77,78,82,83,84,85,86,87];
unit_number=4;
merge_Spikes = cell(unit_number,60);

cd(path)
mkdir sort
for u=1:unit_number
    for h=1:60
        adch_channel = eval(['adch_',int2str(channel(h))]);
        for i=1:size(adch_channel,1)
            if adch_channel(i,2)==u  % 2: column of unit
                merge_Spikes{u,h} = [merge_Spikes{u,h} adch_channel(i,3)]; % 3: column of timestamps
            end
        end
    end
end


fileID = fopen([path, ListName],'r');
formatSpec = '%c';
txt = textscan(fileID,'%s','delimiter','\n');
num_files = length(txt{1});
cutrange = zeros(1,num_files+1);

for i = 1:num_files
    load(fullfile(path_separated, [txt{1}{i},'.mat']));
    cutrange(i+1) = cutrange(i) + size(a_data,2);
end

cutrange=cutrange./20000;

for i = 1:num_files
    Spikes = cell(1,60);
    for u=1:unit_number
        for j = 1:60
            spike=find(merge_Spikes{u,j}>cutrange(i) & merge_Spikes{u,j}<cutrange(i+1));
            Spikes{j} = merge_Spikes{u,j}(spike)-cutrange(i);
        end
        save([path,'\sort\',txt{1}{i},'_unit',num2str(u),'.mat'],'Spikes')
    end
end

fclose(fileID);