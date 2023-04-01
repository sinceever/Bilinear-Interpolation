function Zp = jy_fit(X,Y,Z,Xp,Yp)
% JY_FIT return linear interpolation value
% X pressure x-coordinate column-wise
% Y temperature y-coordinate row-wise
% Z water density f(x,y)
% Xp pressure x-coordinate of prediction
% Yp temperature y-coordinate of prediction
% Zp water density pridiction g(x,y)≈f(x,y) -> output matrix
    m=length(Xp);
    n=length(Yp);
    Zq = zeros([n,m]);
    
    % check monotonicity on x-axis
    for i=1:length(X)
        % Axis is not monotonically increasing
        if i>1 && X(i) <= X(i-1)
            disp("Axis x is not monotonically increasing")
            return
        end
    end
    % check monotonicity on y-axis
    for i=1:length(Y)
        % Axis is not monotonically increasing
        if i>1 && Y(i) <= Y(i-1)
            disp("Axis y is not monotonically increasing")
            return
        end
    end

    % Loop over the query points
    for i = 1:m  % pressure = 1 column index
        for j = 1:n  % temperature 1:600 row index
            % Deal with boundary cases
            % X-axis
            if Xp(i) < X(1) || Xp(i) > X(end)  % Outside range
                disp("Point's pressure is out of range");
                if Xp(i) < X(1)
                    Xp(i) = X(1);
                else
                    Xp(i) = X(end);
                end
            elseif Xp(i)==X(1)   % first point
                x1 = X(1);
                ix1 = 1;
                x2 = X(2);
                ix2 = 2;
            elseif Xp(i)==X(end)  % last point
                ix1 = m-1;
                x1 = X(ix1);
                ix2 = m;
                x2 = X(ix2);
            else  % inbetween use self-defined binary search
                % find the index of the neighbouring lower index
                ix1 = jy_find(Xp(i),X(:));   % pressure x1 axis
                x1 = X(ix1);
                ix2 = ix1+1;
                x2 = X(ix2);
%                 iy1 = jy_find(Yp(j), Y(:));  % temperature y1 axis
            end

            % Y-axis
            if Yp(j) < Y(1) || Yp(j) > Y(end)  % Outside range
                disp("Point's temperature is out of range");
                if Yp(j) < Y(1)
                    Yp(j) = Y(1);
                else
                    Yp(j) = Y(end);
                end
            elseif Yp(j)==Y(1)   % first point
                y1 = Y(1);
                iy1 = 1;
                y2 = Y(2);
                iy2 = 2;
            elseif Yp(j)==Y(end)  % last point
                iy1 = n-1;
                y1 = Y(iy1);
                iy2 = n;
                y2 = Y(iy2);
            else  % inbetween use self-defined binary search
                % find the index of the neighbouring lower index
                iy1 = jy_find(Yp(j),Y(:));   % temperature y1 axis
                y1 = Y(iy1);
                iy2 = iy1+1;
                y2 = Y(iy2);
            end

            Q11 = Z(iy1, ix1);
            Q12 = Z(iy2, ix1);
            Q21 = Z(iy1, ix2);
            Q22 = Z(iy2, ix2);
            
            R1 = Q11*((x2-Xp(i))/(x2-x1)) + Q21*((Xp(i)-x1)/(x2-x1));
            R2 = Q12*((x2-Xp(i))/(x2-x1)) + Q22*((Xp(i)-x1)/(x2-x1));
            Zp(j,i) = R1*((y2-Yp(j))/(y2-y1)) + R2*((Yp(j)-y1)/(y2-y1)); 
        end
    end
end

