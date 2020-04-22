function repmat_array = repmat_array_len_list_times(list,array)
%create cell with multiple array entries
repmat_array={repmat(array,length(list),1)};
end

