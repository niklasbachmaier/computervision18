PT_matrix=[];
matches_12 = cell2mat(matches_8pr(1));
PT_matrix(1,:)=matches_12(3,:);
PT_matrix(2,:)=matches_12(6,:);

for i=2:18
    matches_image=cell2mat(matches_8pr(i));
    matches_prev_image= PT_matrix(i,:);
    append_vector_zeros=zeros(1,length(PT_matrix));
    PT_matrix=[PT_matrix; append_vector_zeros];
    for j = 1:length(matches_prev_image)
        for k = 1:length(matches_image(1,:))
            if matches_prev_image(j) == matches_image(3,k)
                PT_matrix(i+1,j) = matches_image(6,k);
            end
        end
    end
    [C ia] = setdiff(matches_image(3,:),matches_prev_image);
    for z = 1:length(ia)
    append_vector=[ zeros(i-1,1);matches_image(3,z);matches_image(6,z)];
                PT_matrix=[PT_matrix, append_vector];
    end
    
end
matches_image19=cell2mat(matches_8pr(19));
matches_prev_image= PT_matrix(1,:);
for j = 1:length(matches_prev_image)
        for k = 1:length(matches_image19(1,:))
            if matches_prev_image(j) == matches_image19(6,k)
                %find non zeros in column
                PT_matrix(19,j)= matches_image19(3,k);
            end
        end
end

for y=[19 18 17 16 15 14 13]
matches_image=cell2mat(matches_8pr(y-1));
matches_prev_image= PT_matrix(y,:);
for j = 1:length(matches_prev_image)
        for k = 1:length(matches_image(1,:))
            if matches_prev_image(j) == matches_image(6,k)
                %find non zeros in column
                PT_matrix(y-1,j)= matches_image(3,k);
            end
        end
end
end

      
        
        
    
    

    
    
    
    
    



