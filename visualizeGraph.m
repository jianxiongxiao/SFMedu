function visualizeGraph(graph,frames)

%figure
plot3(graph.Str(1,:),graph.Str(2,:),graph.Str(3,:),'.r')
axis equal

nCam=length(graph.frames);
for i=1:nCam
    drawCamera(graph.Mot(:,:,i), frames.imsize(2), frames.imsize(1), graph.f, 0.001,1); %i*2-1);
end
axis tight

%view(-180,-60);
