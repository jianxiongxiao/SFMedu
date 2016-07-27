function outputPly(PLYfilename,plyPoint,plyColor)

% SFMedu: Structrue From Motion for Education Purpose
% Written by Jianxiong Xiao (MIT License)


count = size(plyPoint,2);

fprintf('Writing ply point cloud file: ');
file = fopen(PLYfilename,'w');
fprintf (file, 'ply\n');
fprintf (file, 'format binary_little_endian 1.0\n');
fprintf (file, 'element vertex %d\n', count);
fprintf (file, 'property float x\n');
fprintf (file, 'property float y\n');
fprintf (file, 'property float z\n');
fprintf (file, 'property uchar red\n');
fprintf (file, 'property uchar green\n');
fprintf (file, 'property uchar blue\n');
fprintf (file, 'end_header\n');

    
for i=1:size(plyPoint,2)
    fwrite(file, plyPoint(1,i),'float');
    fwrite(file, plyPoint(2,i),'float');
    fwrite(file, plyPoint(3,i),'float');
    fwrite(file, plyColor(1,i),'uint8');
    fwrite(file, plyColor(2,i),'uint8');
    fwrite(file, plyColor(3,i),'uint8');
end

    
fprintf('done \n');
fclose(file);
