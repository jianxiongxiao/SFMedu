function zncc = ZNCCpatch_all(im, HalfSizeWindow)

zncc = zeros(size(im,1),size(im,2), (2*HalfSizeWindow + 1)^2);

k = 1;
for x=-HalfSizeWindow:HalfSizeWindow
    for y=-HalfSizeWindow:HalfSizeWindow
        zncc( (HalfSizeWindow + 1):(end-HalfSizeWindow),(HalfSizeWindow + 1):(end-HalfSizeWindow),k) = ... 
            im((HalfSizeWindow+1+x):(end-HalfSizeWindow+x),(HalfSizeWindow+1+y):(end-HalfSizeWindow+y));
        k = k+1;
    end
end
zncc_mean = mean(zncc,3);   
zncc_deviation =  sqrt( sum(zncc .^ 2,3) - ( (2*HalfSizeWindow + 1) * zncc_mean) .^2 );
zncc = ( zncc - repmat(zncc_mean,[1 1 (2*HalfSizeWindow + 1)^2]) ) ./ repmat(zncc_deviation,[1 1 (2*HalfSizeWindow + 1)^2]);
