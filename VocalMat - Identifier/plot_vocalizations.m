% close all
tic
clc
clear all
raiz = pwd;
[vfilename,vpathname] = uigetfile({'*.mat'},'Select the output file');
cd(vpathname);
list = dir('*.wav');

vfilename = vfilename(1:end-4);
vfile = fullfile(vpathname,vfilename);

% disp('Cleaning variables: time_vocal freq_vocal intens_vocal output')
% clear time_vocal freq_vocal intens_vocal output
% fprintf('\n');
disp(['Reading ' vfilename])
load([vfile]);
% y1 = y; % y(1:10000000,:);
% nfft = 1024;
% nover = (128);
% window = hamming(256);
% % db_threshold = -115; %original
% db_threshold = -115; 
dx = 0.4;
% disp('Calculating spectrogram')
% [S,F,T,P] = spectrogram(y1, window, nover, nfft, fs, 'yaxis', 'MinThreshold',db_threshold);

%cutoff frequency
% min_freq = find(F>45000);
% F = F(min_freq);
% S = S(min_freq,:);
% P = P(min_freq,:);

% T = size(y1,1)+T;
figure('Name',vfilename,'NumberTitle','off')
% surf(T,F,10*log10(P),'edgecolor','none')
% axis tight; view(0,90);
% 
% colormap(gray);
% xlabel('Time (s)'); ylabel('Freq (Hz)')
% colorbar
% close all
% disp('Applying highpass filter')
% [q,nd] = max(10*log10(P));
% vocal = find(q>-105); %original
% % vocal = find(q>-99); %works better when we have a high 
% q = q(vocal);
% T = T(vocal);
% nd = nd(vocal);
% F = F(nd);

hold on

% plot3(T,F(nd),q,'r','linewidth',4)
disp('Showing segmented points')
for k=1:size(time_vocal,2)
    scatter3(time_vocal{k},freq_vocal{k},intens_vocal{k},'filled')
end
hold off
c = colorbar;
c.Label.String = 'dB';
view(2)
% scrollplot('WindowSizey',120000)

%Vocalization Segmentating
%If there a huge diff between a point and the next point in time domain, it
%means that one vocalization ended and another just started.

% id = 0;
% disp('Postprocessing on the segmented vocalizations')
% for k = 1:size(T,2)-1
%    
%     if T(k+1)-T(k)> 0.01 %If >0.002s, it is a new vocalization
%         id=id+1;
%         time_vocal{id} = [];
%         freq_vocal{id} = [];
%         intens_vocal{id} = [];
%     
%     else %if it is not a new vocalization
%         if k==1
%             id=1;
%             time_vocal{id} = [];
%             freq_vocal{id} = [];
%             intens_vocal{id} = [];
%         end
%         time_vocal{id}=[time_vocal{id}, T(k)]; %Storing vector time for that vocalization
%         freq_vocal{id} = [freq_vocal{id} , F(k)]; %Storing vector frequency for that vocalization
%         intens_vocal{id} = [intens_vocal{id}, q(k)];
%     end
% end

%Remove too small vocalizations (< 5 points)
disp('Calc median distance between points')
dist_vocal = {};
for k=1:size(time_vocal,2)
%    if  size(time_vocal{k},2) < 8 %|| max(freq_vocal{k})-min(freq_vocal{k}) > 45000
%        time_vocal{k}=[];
%        freq_vocal{k}=[];
%        intens_vocal{k}=[];
%    end
   dista = [];
   for j = 1:size(time_vocal{k},2)-1
       dista = [dista; pdist([time_vocal{k}(j:j+1)' freq_vocal{k}(j:j+1)'],'euclidean')];
   end
   dist_vocal{k} = median(dista);
%    
%    if median(dist) > 1000 %in general, when it is a real vocalization, the median is exaclty 244.1406!!
%        time_vocal{k}=[];
%        freq_vocal{k}=[];
%        intens_vocal{k}=[];
%    end
end

% disp('Removing empty cells')
% time_vocal = time_vocal(~cellfun('isempty',time_vocal));
% freq_vocal = freq_vocal(~cellfun('isempty',freq_vocal));
% intens_vocal = intens_vocal(~cellfun('isempty',intens_vocal));

%Verify if the vocalizations detected are too long. If it is, probably
%there is too much noise and we need to remove noise (>125ms, Based on
%maximum duration measured at Acoustic variability and distinguishability
%among mouse, 2003)
% denoiseing=0;
% for k=1:size(time_vocal,2)
%     if (max(time_vocal{k})-min(time_vocal{k}))>0.125 %125ms
%         denoiseing = 1;
%     end
% end
% 
% if denoiseing 
%         close
%         disp('Too much noise! Running denoising process')
%         disp('Saving and cleaning variables')
%         clear time_vocal freq_vocal intens_vocal output
%         save('temp') %I have to clean all the varibles now, otherwise I wont have enough memory to make the calculation
%         cd(raiz)
%         clearvars -except vfile y1 fs vpathname
%         
%         vocalmat_denoising(vfile,y1,fs);
%         
%         cd(vpathname)
%         load('temp')
%         clear y1 fs
%         vfilename = [vfilename '_no_noise'];
%         disp(['Reading audio ' vfilename '.wav'])
%         
%         [y1,fs]=audioread([vfilename '.wav']); 
%         nfft = 1024;
%         nover = (128);
%         window = hamming(256);
%         % db_threshold = -115; %original
%         db_threshold = -115; 
%         dx = 0.4;
%         disp('Calculating spectrogram')
%         [S,F,T,P] = spectrogram(y1, window, nover, nfft, fs, 'yaxis', 'MinThreshold',db_threshold);
%         
%         %cutoff frequency
%         min_freq = find(F>45000);
%         F = F(min_freq);
%         S = S(min_freq,:);
%         P = P(min_freq,:);
%         
%         figure('Name',vfilename,'NumberTitle','off')
%         
%         disp('Applying highpass filter')
%         [q,nd] = max(10*log10(P));
%         vocal = find(q>-105); %original
%         % vocal = find(q>-99); %works better when we have a high 
%         q = q(vocal);
%         T = T(vocal);
%         nd = nd(vocal);
%         F = F(nd);
%         
%         hold on
%         disp('Showing segmented points')
%         scatter3(T,F,q,'filled')
%         hold off
%         c = colorbar;
%         c.Label.String = 'dB';
%         view(2)
%       
%         %Vocalization Segmentating
%         %If there a huge diff between a point and the next point in time domain, it
%         %means that one vocalization ended and another just started.
% 
%         id = 0;
%         disp('Postprocessing on the segmented vocalizations')
%         for k = 1:size(T,2)-1
% 
%             if T(k+1)-T(k)> 0.01 %If >0.002s, it is a new vocalization
%                 id=id+1;
%                 time_vocal{id} = [];
%                 freq_vocal{id} = [];
%                 intens_vocal{id} = [];
% 
%             else %if it is not a new vocalization
%                 if k==1
%                     id=1;
%                     time_vocal{id} = [];
%                     freq_vocal{id} = [];
%                     intens_vocal{id} = [];
%                 end
%                 time_vocal{id}=[time_vocal{id}, T(k)]; %Storing vector time for that vocalization
%                 freq_vocal{id} = [freq_vocal{id} , F(k)]; %Storing vector frequency for that vocalization
%                 intens_vocal{id} = [intens_vocal{id}, q(k)];
%             end
%         end
%      %Remove too small vocalizations (< 5 points)
%     disp('Removing small vocalizations (< 8 points)')
%     for k=1:size(time_vocal,2)
%        if  size(time_vocal{k},2) < 8 %|| max(freq_vocal{k})-min(freq_vocal{k}) > 45000
%            time_vocal{k}=[];
%            freq_vocal{k}=[];
%            intens_vocal{k}=[];
%        end
%        dist = [];
%        for j = 1:size(time_vocal{k},2)-1
%            dist = [dist; pdist([time_vocal{k}(j:j+1)' freq_vocal{k}(j:j+1)'],'euclidean')];
%        end
% 
%        if median(dist) > 1000 %in general, when it is a real vocalization, the median is exaclty 244.1406!!
%            time_vocal{k}=[];
%            freq_vocal{k}=[];
%            intens_vocal{k}=[];
%        end
%     end 
%     
%     disp('Removing empty cells')
%     time_vocal = time_vocal(~cellfun('isempty',time_vocal));
%     freq_vocal = freq_vocal(~cellfun('isempty',freq_vocal));
%     intens_vocal = intens_vocal(~cellfun('isempty',intens_vocal));
% end
%     
% 
% output = [];
% %Plot names on spectrogram and organize table
disp('Plotting names on spectrogram and organizing table')
for i=1:size(time_vocal,2)
    text(time_vocal{i}(round(end/2)),freq_vocal{i}(round(end/2))+5000,[num2str(i)],'HorizontalAlignment','left','FontSize',20,'Color','r');
%     output = [output; i, size(time_vocal{i},2) , min(time_vocal{i}), max(time_vocal{i}), (max(time_vocal{i})-min(time_vocal{i})) , max(freq_vocal{i}), mean(freq_vocal{i}),(max(freq_vocal{i})-min(freq_vocal{i})) , min(freq_vocal{i}), min(intens_vocal{i}), max(intens_vocal{i}), mean(intens_vocal{i})];
end

% output = array2table(output,'VariableNames', {'ID','Num_points','Start_sec','End_sec','Duration_sec','Max_Freq_Hz','Mean_Freq_Hz','Range_Freq_Hz','Min_Freq_Hz','Min_dB','Max_dB','Mean_dB'});
% warning('off','MATLAB:xlswrite:AddSheet');

% xlswrite(vfile,output,filename)
% writetable(output,[vpathname '_VocalMat'],'FileType','spreadsheet','Sheet',vfilename)
% vfilename
% size(time_vocal,2)
% size(output,1)
cd(raiz)

% [var] = lbox2(time_vocal);
% prompt = 'What is the original value? ';
% x = input(prompt)
% aaa = ans;
X = [vfilename,' has ',num2str(size(output,1)),' vocalizations.'];
disp(X)

set(gca,'xlim',[0 dx]);
set(gca,'ylim',[0 max(F)]);
% Generate constants for use in uicontrol initialization
pos=get(gca,'position');
% Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
% xmax=max(T);
% maxF = max(F);
yourcell = 1:size(time_vocal,2);
% Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
hb = uicontrol('Style', 'listbox','Position',[pos(1)+10 pos(2)+100 100 pos(4)+700],...
     'string',yourcell,'Callback',... 
     ['if get(hb, ''Value'')>0 ',...
     ' Stri=[''set(gca,''''xlim'''',[-dx/2 dx/2]+['' num2str(time_vocal{get(hb, ''Value'')}(1)) '' '' num2str(time_vocal{get(hb, ''Value'')}(1)) ''])'']; ',...
     ' eval(Stri); ', ...
     'end']);
 %      ' update_slide(get(hb, ''Value''), time_vocal,xmax, maxF), ',...

% This avoids flickering when updating the axis
% set(gca,'xlim',[0 dx]);
% set(gca,'ylim',[0 max(F)]);
% Generate constants for use in uicontrol initialization
% pos=get(gca,'position');
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
xmax=max(T);
Stri=['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
h=uicontrol('style','slider',...
    'units','normalized','position',Newpos,...
    'callback',Stri,'min',0,'max',xmax-dx,'SliderStep',[0.0001 0.010]);
% set(gcf,'Renderer','OpenGL')

% close all
% save(['output_' vfilename])
warning('off', 'MATLAB:save:sizeTooBigForMATFile')
disp('Cleaning variables: y y1 S F T P fs q nd vocal id' ) 
clear y y1 S F T P fs q nd vocal id
toc 
