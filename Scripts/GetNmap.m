function ind_map = GetNmap(rows,cols,W,nolp)
L = (2*W+1)^2 - 1;
ind_map = ones(nolp,L)*(nolp+1);
for i = 1:rows
    for j =1:cols
        
        cur_ind = (j-1)*rows + i; %find neighbour of this pixel
        counter = 1;
        for k = i-W:i+W
            for l = j-W:j+W
                
                if (k>=1 & k<=rows & l>=1 & l<=cols & (i~=k | j~=l))
                    int_ind = (l-1)*rows + k;
                    ind_map(cur_ind,counter) = int_ind;
                    counter = counter+1;
                end
            end
        end
    end
end