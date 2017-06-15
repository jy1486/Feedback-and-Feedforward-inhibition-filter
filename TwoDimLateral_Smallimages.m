%Jason Yang FeedForward and Backward, solving systems of linear equations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% small visual field of herman grid
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% entire herman grid
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rawin = imread('images.jpg');
%myimage = rgb2gray(rawin); 

%%input images:Note that matrix size becomes
%%(Width*Height)^2 therefore it can only accommodate very small images.


myimage = pic1;

I = 0.45; %inhibition coefficient
fwd = true; %%forward or back propagation, fwd means forward


%%%%%%%%%%%%%%%%

r = size(myimage,1);
c = size(myimage,2);

myimage = im2double(myimage);

mymatrix = diag(ones(r*c,1) ,0);

if fwd == true
    I = -I;
end

%%%setting the very large matrix below is based on equation sheet

%%% eq. 7 or 16 (feedforward or feedback, depends if I or -I) 
mymatrix(1,2) = I;
mymatrix(1,c+1) = I;
mymatrix(1,c+2) = I;

%%% eq. 8 or 17
mymatrix(c,c - 1) = I;
mymatrix(c,(2*c)-1) = I;
mymatrix(c,(2*c)) = I;

%%% eq. 9 or 18
mymatrix(((r-1)*c)+1,((r-1)*c) + 2) = I;
mymatrix(((r-1)*c)+1,((r-2)*c) + 1) = I;
mymatrix(((r-1)*c)+1,((r-2)*c) + 2) = I;

%%% eq. 10 or 19
mymatrix(r*c,(r*c)-1) = I;
mymatrix(r*c,((r-1)*c)-1) = I;
mymatrix(r*c,(r-1)*c) = I;

%%% eq. 11 or 20
for e = 2:c-1
   mymatrix(e,e-1) = I;
   mymatrix(e,e+1) = I;
   mymatrix(e,c+(e-1)) = I;
   mymatrix(e,c+e) = I;
   mymatrix(e,c+(e+1)) = I;
end

%%% eq. 12 or 21
for e = (((r-1)*c)+2):((r*c)-1)
    mymatrix(e,e-1) = I;
    mymatrix(e,e+1) = I;
    mymatrix(e,(e-c)-1) = I;
    mymatrix(e,(e-c)) = I;
    mymatrix(e,(e-c)+1) = I;
end

%%% eq. 13 or 22
for ee = 1:r-2
   e = (ee*c)+1;
   mymatrix(e,e+1) = I;
   mymatrix(e,e-c) = I;
   mymatrix(e,e-c+1) = I;
   mymatrix(e,e+c) = I;
   mymatrix(e,e+c+1) = I;
end

%%% eq. 14 or 23
for ee = 2:r-1
   e = ee*c;
   mymatrix(e,e-1) = I;
   mymatrix(e,e-c) = I;
   mymatrix(e,e-c-1) = I;
   mymatrix(e,e+c) = I;
   mymatrix(e,e+c-1) = I;
end

%%% eq. 15 or 24
for i = 1:r-2
    for j = 2:c-1
        e = (i*c)+j;
        mymatrix(e,e-c-1) = I;
        mymatrix(e,e-c) = I;
        mymatrix(e,e-c+1) = I;
        mymatrix(e,e-1) = I;
        mymatrix(e,e+1) = I;
        mymatrix(e,e+c-1) = I;
        mymatrix(e,e+c) = I;
        mymatrix(e,e+c+1) = I;
        
    end
end

image1D = reshape(myimage',[r*c,1]); %%turn image into 1D array for matrix multiplication

%solving systems of linear equations 
if fwd == true
    output1D = mymatrix * image1D;

else
    output1D = mymatrix^(-1) * image1D;
end


output = reshape(output1D,[c,r])'; %%turn 1D array output into matrix to view image
%assume that visual lower bound is black and visual upper bound is white
%otherwise matlab 

output(output>255) = 255; %assume we process negative stimuli as black and we percieve stimuli "greater than white" as white
output(output<0) = 0;

%showing images
subplot(2,1,1)
imshow(myimage,[])
title('Original')
subplot(2,1,2)
imshow(output,[]);
