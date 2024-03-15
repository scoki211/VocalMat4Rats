% USV_morpher
% Takes sample USV RGB seed image (VocalMAT spectrogram)  as xxx.png and then morphs it and adds noise. 
% Output is xxx_m.png to be used as an 'artificial' call for training VocalMAT
% calls morphimage routine by Dima Pröfrock
% Dima Pröfrock (2024). morphimage (https://www.mathworks.com/matlabcentral/fileexchange/11975-morphimage), 
% MATLAB Central File Exchange. 
% Note: not all morphed images will be suitable - check them!
% D Bilkey 
% University of Otago, Dunedin, New Zealand 
% 1/4/22

%% set up parameters
numspawn= 10;               % number of different morphed images to generate from this seed
morphquant=50;              % degree of morphing applied  (50 is about max)
adnoise=true;               % add noise to output image
noiseprob=1;                % probability that noise will be added to any one morphed image (0-1)
noiseamp=0.1;               % variance of noise to add  (0.1);
ploton=true;                % plot input and output images, with pause after each morph

%% load seed image
%[fname] = uigetfile('*.png','select a .png file as the seed USV call');
fname='225.png';   % use to test otherwise change to line above
seedimage=imread(fname);
imagesize(1) = length(seedimage(1,:,:));
imagesize(2) = length(seedimage(:,1,:));

for spawnnum = 1:numspawn   % repeat to generate multiple spawn from one seed
    if ploton
      close all
      figure; 
      subplot(1,2,1);
      imagesc(seedimage);
      title('Original')
    end % ploton
    
    %% Create a random morphfield and morph image
    morphfield = morphquant*imresize(rand(5,5,2)-0.5,imagesize,'bilinear');
    
    for i=1:3                           % step through 3 planes of RGB image
       imageplane=seedimage(:,:,i);
       MorphedImage(:,:,i) = morphimage(imageplane,morphfield);  % morph image
    end % i   
    
    %% add noise if required
    if adnoise
      r1=rand;      % generate random between 0 and 1
      if r1 < noiseprob   % add noise to images if r1 is less than noiseprob 

        % create noise field to add to image
        noisefield=zeros(imagesize(1),imagesize(2));
        for i = 1: imagesize(1)               % add noise to portion of png image 
          for j = 1: imagesize(2)
            noisefield(i,j)=(randn)*noiseamp;
          end
        end  
        
        % add noise to three (RGB) components of image 
        for i = 1:3
          mini=min(min(MorphedImage(:,:,i)));
          maxi=max(max(MorphedImage(:,:,i)));
          rplane=rescale(MorphedImage(:,:,i));  % rescale to between zero and one
          nplane=rplane+noisefield;             % add noise
          idx=find(nplane<0);                   % trim any extreme (noise) values <0 and > 1
          nplane(idx)=0;                        
          idx=find(nplane>1);
          nplane(idx)=1;
          MorphedImage(:,:,i)=round(rescale(nplane,mini,maxi));  % rescale to previous range
        end 
      end  % if r1 
    end  % if adnoise

    
    %% save .png image   
    outname=strrep(fname,'.png','_m');
    outname=strcat(outname,num2str(spawnnum),'.png');
    imwrite(uint8(MorphedImage),outname);
     
    if ploton
        subplot(1,2,2);
        imagesc(uint8(MorphedImage));
        title('   Morphed   - Press return')
        fprintf('Press return to continue \n');    
        pause
    end % plot on
    
    
end % of spawnnum

