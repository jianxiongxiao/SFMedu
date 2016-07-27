function GraphAB = merge2graphs(GraphA,GraphB)


commonFrames = intersect(GraphA.frames,GraphB.frames);

[newFramesFromB,indexNewFramesFromB] = setdiff(GraphB.frames,GraphA.frames);

if isempty(commonFrames)
    GraphAB = [];
    return;
end

GraphAB = GraphA;

if isempty(newFramesFromB)
    return;
end


% add the non-overlapping frame first
firstCommonFrame = commonFrames(1);


% transform GraphB.Mot and GraphB.Str to be in the same world coordinate system of GraphA
RtBW2AW = concatenateRts(inverseRt(GraphA.Mot(:,:,GraphA.frames==firstCommonFrame)), GraphB.Mot(:,:,GraphB.frames==firstCommonFrame));
GraphB.Str = transformPtsByRt(GraphB.Str, RtBW2AW);
for i=1:length(GraphB.frames)
    GraphB.Mot(:,:,i) = concatenateRts(GraphB.Mot(:,:,i), inverseRt(RtBW2AW));
end

GraphAB.frames = [GraphA.frames newFramesFromB];
GraphAB.Mot(:,:,length(GraphA.frames)+1:length(GraphAB.frames)) = GraphB.Mot(:,:,indexNewFramesFromB);

% add the new tracks

for commonFrame = commonFrames
    
    cameraIDA = find(GraphA.frames==commonFrame);   cameraIDB = find(GraphB.frames==commonFrame);
    
    trA = find(GraphA.ObsIdx(cameraIDA,:)~=0);
    xyA = GraphA.ObsVal(:,GraphA.ObsIdx(cameraIDA,trA));
    
    trB = find(GraphB.ObsIdx(cameraIDB,:)~=0);
    xyB = GraphB.ObsVal(:,GraphB.ObsIdx(cameraIDB,trB));

    [xyCommon,iA,iB] = intersect(xyA',xyB','rows');
    xyCommon = xyCommon';
    
    % make the old track longer
    for i=1:size(xyCommon,2)
        idA = trA(iA(i));
        idB = trB(iB(i));
        
        for j=1:length(indexNewFramesFromB)
            BObsIdx = GraphB.ObsIdx(indexNewFramesFromB(j),idB);
            if BObsIdx~=0
                GraphAB.ObsVal(:,end+1) = GraphB.ObsVal(:,BObsIdx);
                GraphAB.ObsIdx(length(GraphA.frames)+j,idA) = size(GraphAB.ObsVal,2);            
            end
        end
    end
    
    % add the new tracks from common frame
    
    
    [xyNewFromB, iB] = setdiff(xyB',xyA','rows');
    xyNewFromB = xyNewFromB';
    
    for i=1:size(xyNewFromB,2)
        idB = trB(iB(i));
        
        GraphAB.ObsVal(:,end+1) = GraphB.ObsVal(:,GraphB.ObsIdx(cameraIDB,idB));
        GraphAB.ObsIdx(cameraIDA,end+1) = size(GraphAB.ObsVal,2);       
        GraphAB.Str(:,end+1) = GraphB.Str(:,idB);
        
        for j=1:length(indexNewFramesFromB)
            BObsIdx = GraphB.ObsIdx(indexNewFramesFromB(j),idB);
            if BObsIdx~=0
                GraphAB.ObsVal(:,end+1) = GraphB.ObsVal(:,BObsIdx);
                GraphAB.ObsIdx(length(GraphA.frames)+j,end) = size(GraphAB.ObsVal,2);            
            end
        end
    end    
    
end

% add the new tracks only among the completely new frames

newB = false(1,length(GraphB.frames));
newB(indexNewFramesFromB) = true;

tr2add = sum(GraphB.ObsIdx(~newB,:)~=0,1)==0 & sum(GraphB.ObsIdx(newB,:)~=0,1)>0;

if any(tr2add)
    
    ids = full(GraphB.ObsIdx(indexNewFramesFromB,tr2add));

    curValCnt = size(GraphAB.ObsVal,2);
    nonZerosID = find(ids(:)>0);

    GraphAB.ObsVal(:,(curValCnt+1):(curValCnt+length(nonZerosID))) = GraphB.ObsVal(:,ids(nonZerosID));

    idsNew = zeros(size(ids));
    idsNew(nonZerosID) = (curValCnt+1):(curValCnt+length(nonZerosID));

    GraphAB.ObsIdx(length(GraphA.frames)+1:end,size(GraphAB.ObsIdx,2)+1:size(GraphAB.ObsIdx,2)+size(idsNew,2)) = sparse(idsNew);

    GraphAB.Str(:,size(GraphAB.ObsIdx,2)+1:size(GraphAB.ObsIdx,2)+size(idsNew,2)) = GraphB.Str(:,tr2add);
end

return;



%{
    pointCount = size(MatchPairs{1}.matches,2);
    pointObservedValueCount = size(MatchPairs{1}.matches,2)*2;
    pointObservedValue(:,1:pointObservedValueCount) = [[MatchPairs{1}.matches(1:5,:) MatchPairs{1}.matches(6:10,:)]; -wTimePoints * ones(1,pointObservedValueCount)];
    pointObserved(1,1:pointCount)=1:pointCount;
    pointObserved(2,1:pointCount)=pointCount + (1:pointCount);
    previousIndex = 1:pointCount;
    
    pointCloud(:,1:pointCount) = MatchPairs{1}.matches(3:5,:);
    
    for frameID = 2:length(data.image)-1
        [~,iA,iB] = intersect(MatchPairs{frameID-1}.matches(6:7,:)',MatchPairs{frameID}.matches(1:2,:)','rows');
        
        
        alreadyExist = false(1,size(MatchPairs{frameID}.matches,2));
        alreadyExist(iB) = true;
        newCount = sum(~alreadyExist);
        
        
        currentIndex = zeros(1,size(MatchPairs{frameID}.matches,2));
        currentIndex(iB) = previousIndex(iA);
        currentIndex(~alreadyExist) = (pointCount+1):(pointCount+newCount);
        
        pointObservedValue(1:5,pointObservedValueCount+1:pointObservedValueCount+newCount+length(currentIndex)) = [MatchPairs{frameID}.matches(1:5,~alreadyExist) MatchPairs{frameID}.matches(6:10,:)];
        pointObservedValue(6,pointObservedValueCount+1:pointObservedValueCount+newCount+length(currentIndex)) = -wTimePoints;
        
        pointObserved(frameID  ,currentIndex(~alreadyExist)) = (pointObservedValueCount+1):(pointObservedValueCount+newCount);
        pointObservedValueCount = pointObservedValueCount + newCount;
        pointObserved(frameID+1,currentIndex) = (pointObservedValueCount+1):(pointObservedValueCount+length(currentIndex));
        pointObservedValueCount = pointObservedValueCount + length(currentIndex);
        
        
        pointCloud(:,pointCount+1:pointCount+newCount) = transformRT(MatchPairs{frameID}.matches(3:5,~alreadyExist), cameraRtC2W(:,:,frameID), false);
        
        pointCount = pointCount + newCount;
        
        previousIndex = currentIndex;
    end
%}