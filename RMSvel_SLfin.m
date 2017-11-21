% calculate root mean square velocities
%
% track file arranged where
% each row is a separate cell
% each column is a separate t
%
clear all
close all
clc



% convert time frames to real units
IndtoHours = 0.25; % Time-Lapse every 0.25 h
TimeWindow = 1/IndtoHours; % calculate speed as the displacement per hour
minTrackLength = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% list of conditions
ConditionList = [1 2 3 4 5 6 19 20 21 22 23 24 49 50 51 52 53 54 67 68 69 70 71 72];

NumConditions = length(ConditionList);

StoreD = zeros(4,NumConditions);

% cycle through each condition
for i = 1:NumConditions
    
    % select condition number
    Condition = ConditionList(i);
    
    prefix = 'EGF(E6)w';
%     
%     if Condition < 10;
%         prefix = 'C0';
%     end
%     
    % generate file name
    FileNameIn = strcat(prefix,num2str(Condition));
    
    % load data
    load(FileNameIn);
    
          % how many cells, how long
        NumCells = size(storeX,1);
        MaxTime = size(storeY,2);
        
        % calculate velocities over a time window according to Brugge JCB 2012
        % this reduces noise from nuclear shape changes
        velX=storeX(:,(1+TimeWindow):TimeWindow:end)-storeX(:,1:TimeWindow:end-TimeWindow);
        velY=storeY(:,(1+TimeWindow):TimeWindow:end)-storeY(:,1:TimeWindow:end-TimeWindow);
        velX=velX(:,1:60);
        velY=velY(:,1:60);
        % magnitude of velocity in 2D
        velR  = sqrt(velX.*velX+velY.*velY);
        
        storeXh=storeX(:,(1:4:240));
        storeYh=storeY(:,(1:4:240));


counterindexZ = 1
Time = 1:counterindexZ:size(velR,2);
%or nanmean(...)
meanRMS=mean(velR,'omitnan');
meanRMS=meanRMS(:,1:60);
quartiles=quantile(velR, [0.25, 0.75]);
quartiles=quartiles(:,1:60);
quantiles=quantile(velR, [0.8, 0.85, 0.9, 0.95, 0.99]);
quantiles=quantiles(:,1:60);
FileNameOut = strcat('vel-',prefix,num2str(Condition),'.mat');
        
        save(FileNameOut,'velX','velY','velR','storeX','storeY','storeXh','storeYh', 'meanRMS','quartiles','quantiles')
       
end


%
% plot(Time,quartiles(1,:),'Color',[229/256 229/256 229/256],'Linewidth',1);
% hold on
% plot(Time,quartiles(2,:),'Color',[229/256 229/256 229/256],'Linewidth',1);
% X=[Time,fliplr(Time)];
% hold on
% inBetween=[quartiles(1,:),fliplr(quartiles(2,:))];
%     Z=fill(X, inBetween, [229/256 229/256 229/256],'EdgeColor','none');
%     hold on
% plot(Time,meanRMS,'Color',[152/256 78/256 163/256],'Linewidth',3);
% xlim([0 64])
% ylim([0 65])
% 
%  xlabel('Time (h)')
%  ylabel('Speed (um/h)')
% titlename = strcat('well',num2str(Condition),' RMS Plot');
% title(titlename);
%       
%   savefilename = strcat(prefix,num2str(Condition),'RMS');
%     print(gcf,savefilename,'-depsc','-r2000')
% figure;
% end
% %%
% % Check against raw imaris velocities    
% velXi=storevelX(:,:);
% velYi=storevelY(:,:);
%         
%         % magnitude of velocity in 2D
%         velRi  = sqrt(velXi.*velXi+velYi.*velYi);
%         meanRMSi=[mean(velRi(:,1:4:248),'omitnan')];         
% quartilesi=quantile(velRi(:,1:4:248), [0.25, 0.75]);
% 
% plot(Time,quartilesi(1,:),'Color',[152/256 78/256 163/256],'Linewidth',1);
% plot(Time,quartilesi(2,:),'Color',[152/256 78/256 163/256],'Linewidth',1);
% X=[Time,fliplr(Time)];
% inBetween=[quartilesi(1,:),fliplr(quartilesi(2,:))];
%     Z=fill(X, inBetween, [229/256 229/256 229/256]);
%     hold on
% plot(Time,meanRMSi,'Color',[152/256 78/256 163/256],'Linewidth',3);
% xlim([0 64])
% ylim([0 75])
% hold off 
% title('Imaris velocities')
% xlabel('Time (h)')
% ylabel('Speed (um/h)')
%         

