function graph=triangulate(graph,frames)

nPts = size(graph.Str,2);

X = zeros(4,nPts);

for i=1:nPts
    
    validCamera = find(full(graph.ObsIdx(:,i)~=0))';

    P=cell (1,length(validCamera));
    x=zeros(2,length(validCamera));
    cnt = 0;
    
    for c=validCamera
        cnt = cnt + 1;
        % x (2-by-K matrix)
        x(:,cnt) = graph.ObsVal(:,graph.ObsIdx(c,i));
        
        % P (K-cell of 3-by-4 matrices)
        P{cnt} = f2K(graph.f) * graph.Mot(:,:,c);
    end
    
    X(:,i) = vgg_X_from_xP_nonlin(x,P,repmat([frames.imsize(2);frames.imsize(1)],1,length(P)));
    
end

%X(isnan(X(:)))=1;

graph.Str = X(1:3,:) ./ X([4 4 4],:);