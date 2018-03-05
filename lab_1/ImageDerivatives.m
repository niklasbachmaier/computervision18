%img is image path or matrix if test specified, sigma used for kernel
%creation, type = ( ?x?, ?y?, ?xx?, ?yy?, ?xy?, ?yx?), test = 't' if
%testmode, img needs to be matrix then
function F=ImageDerivatives(img , sigma , type, test)

%first correctly read in image; if test specified img is a matrix which we
%use
if strcmp(test, 't')
    im = img;
else 
    imIn = imread (img);
    im = im2double(imIn);

    if size(im,3) == 3
        im = rgb2gray(im); 
    end
end

%do convolution dependent on specified type ( ?x?, ?y?, ?xx?, ?yy?, ?xy?, ?yx?)

G = gaussianFilter(sigma);

if strcmp(type,'x')
    
    Gx = gaussianFirst(G,sigma);
    F = conv2(1,Gx,im,'same');
    
elseif strcmp(type,'y')
    
    Gy = gaussianFirst(G,sigma);
    F = conv2(Gy,1,im,'same');
        
elseif strcmp(type, 'xx')
    
    Gxx = gaussianSec(G,sigma);
    F = conv2(1,Gxx,im,'same');
    
elseif strcmp(type, 'yy')
    
    Gyy = gaussianSec(G,sigma);
    F = conv2(Gyy,1,im,'same');
    
elseif strcmp(type, 'xy') || strcmp(type, 'yx')
    
    Gxy = gaussianFirst(G,sigma);
    F = conv2(Gxy,Gxy,im,'same');
    
else
    fprintf('Derivative type not supported\n'); 
end

%if test mode show image
if strcmp(test,'t')
    imshow(F)
end


end