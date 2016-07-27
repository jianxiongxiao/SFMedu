function rim = ReliableArea(im)

rim = max( max( abs(im-im([2:end 1],:)) , abs(im-im([end 1:end-1],:)) ), max( abs(im-im(:,[2:end 1])) , abs(im-im(:,[end 1:end-1])) ));
rim([1 end], :) = 0;
rim(:, [1 end]) = 0;
rim = ( rim < 0.01 );
rim = double(1-rim);
