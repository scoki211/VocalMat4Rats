function fnSaveBGFloorSegParamsFile(strFileName, ...
                                    a2fBackground, ...
                                    a2bFloor, ...
                                    a2strctGTTuningEllipses, ...
                                    iGTTuningFrame, ...
                                    strctSegParams)

% Takes all the data that goes into a background-floor-segmentation-params
% file, and puts it into such a file.  Files produced by this function
% should work in place of a "Background.mat" or "Detection.mat" file used
% by Repository/MouseHouse.
                            
% Convert segmentation tuning ellipses to Repository format
astrctTuningEllipses= ...
  fnConvertSegmentationGTToRepositoryFormat(a2strctGTTuningEllipses, ...
                                            iGTTuningFrame);

strctBackground=struct('m_a2fMedian',a2fBackground, ...
                       'm_a2bFloor',a2bFloor, ...
                       'm_astrctTuningEllipses',astrctTuningEllipses, ...
                       'm_strctSegParams',strctSegParams, ...
                       'm_strMethod','FrameDiff_v7');
% The real files have a strctMovieInfo variable, which contains the 
% standard file metadata about the clip that all this stuff came from.
% We'll see if we can get away with not having that.
save(strFileName,'strctBackground');                     

end