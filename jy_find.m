function index = jy_find(x,vector)
%JY_FIND binary search
%Return index when vector(index)<=x
%vector should be a sorted list
if x>vector(end)
    disp('The value exceeds the right boundry!')
    index = length(vector);
    return
elseif x<vector(1)
    disp('The value exceeds the left boundry!')
    index = 1;
    return
end
ihigh = numel(vector);
ilow = 1;
for i=1:numel(vector)
    j = floor( (ilow+ihigh)/2 );  % middle index of searching range
    if x == vector(j) || ihigh-ilow<=1
        index = j;
        return
    end
    if x < vector(j)
        ihigh = j;
    else
        ilow = j;
    end
end