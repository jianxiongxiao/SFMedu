function points2ply(PLYfilename, coordinate, rgb)
    % coordinate is 3 * n single matrix for n points
    % rgb        is 3 * n uint8  matrix for n points range [0, 255]

    if size(coordinate,2)==3 && size(coordinate,1)~=3
        coordinate = coordinate';
    end
    
    isValid = (~isnan(coordinate(1,:))) & (~isnan(coordinate(2,:))) & (~isnan(coordinate(3,:)));
    coordinate = coordinate(:,isValid);

    data = reshape(typecast(reshape(single(coordinate),1,[]),'uint8'),3*4,[]);

    if nargin>2
        if size(rgb,2)==3 && size(rgb,1)~=3
            rgb = rgb';
        end
        
        if ~isa(rgb,'uint8')
            if max(rgb(:))<=1
                rgb = rgb * 255;
            end
        end
        
        if isa(rgb,'double')
            rgb = uint8(rgb);
        end
        
        rgb = rgb(:,isValid);
        data = [data; rgb];
    end

    file = fopen(PLYfilename,'w');
    fprintf (file, 'ply\n');
    fprintf (file, 'format binary_little_endian 1.0\n');
    fprintf (file, 'element vertex %d\n', size(data,2));
    fprintf (file, 'property float x\n');
    fprintf (file, 'property float y\n');
    fprintf (file, 'property float z\n');
    if nargin>2
        fprintf (file, 'property uchar red\n');
        fprintf (file, 'property uchar green\n');
        fprintf (file, 'property uchar blue\n');
    end
    fprintf (file, 'end_header\n');

    fwrite(file, data,'uint8');
    fclose(file);

end
