%Jason Yang Feedforward lateral inhibition 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%smaller visual field of herman grid
pic1 = [ 0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;
            0 0 0 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 0 ;]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%herman grid
pic2 = [ 0 0 0 255 0 0 0 255;
          0 0 0 255 0 0 0 255;
          0 0 0 255 0 0 0 255;
          255 255 255 255 255 255 255 255;
          0 0 0 255 0 0 0 255;
          0 0 0 255 0 0 0 255;
          0 0 0 255 0 0 0 255;
          255 255 255 255 255 255 255 255;];
pic2 = repmat(pic2,2);
lside = ones(size(pic2,1) + 1,1) * 255;
ltop = ones(1,size(pic2,2) ) * 255;
pic2 = cat(2,lside, cat(1,ltop,pic2) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%input images: can accomadate larger image than the other code

 rawin = imread('castle.png'); %uncomment these two lines to try external img
  myimage = rgb2gray(rawin);

%myimage = pic2; %pic1 or pic2 are images coded in
%myimage = pic1;

I = 0.125;

myimage = im2double(myimage);
rows = size(myimage,1);
cols = size(myimage,2);
output = zeros(rows,cols);
input = cat(2,cat(2,zeros(rows+2,1), cat(1, zeros(1,cols) , cat(1,myimage,zeros(1,cols)))), zeros(rows+2,1));
%%%we pad the input with zeros around the border then calculate inhibition
%%%of the inner matrix otherwise we get out of bounds error.

permute = [1 0; 0 1; 1 1; -1 0; 0 -1; -1 -1; 1 -1; -1 1];
%%%permutate list of surrounding receptors

for i = 2:rows+1
    io = i-1;
    for j = 2:cols+1
        jo = j-1;
        sumneigh = 0;
        for q = 1:size(permute,1)
            sumneigh = sumneigh + input(i + permute(q,1),j + permute(q,2) ) ;
            %total inhibition of neighbor receptors
        end
        output(io,jo) = input(i,j) - I*(sumneigh); 
        %save calculation to output matrix  
    end
end

%assume that negative stimulus is black and extreme high values of stimulus is white
%matlab scales images from 0 to 255, black to white
output(output>255) = 255;
output(output<0) = 0;

%%%show image
subplot(2,1,1)
imshow(myimage,[])
title('Original')
subplot(2,1,2)
imshow(output,[]);
