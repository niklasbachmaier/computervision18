PT_matrix=[]
matches_12 = cell2mat(matches_8pr{1});
PT_matrix(1,:)=matches_12(3,:);
PT_matrix(2,:)=matches_12(6,:);

for i=2:18
    matches_image=cell2mat(matches_8pr{i});
    matches_prev_image= PT_matrix(i,:);
    append_vector_zeros=zeros(length(PT_matrix));
    PT_matrix=[PT_matrix; append_vector_zeros];
    for j = 1:length(matches_prev_image)
        for k = 1:length(matches_image(1,:))
            if matches_prev_image(j) == matches_image(1,k)
                PT_matrix(i+1,j) = matches_image(2,k);
                
            else 
                append_vector=[ zeros(i-1,1);matches_image(:,k)];
                PT_matrix=[PT_matrix, append_vector];
            end
        end
    end
end
