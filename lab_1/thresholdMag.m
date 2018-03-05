function thresholdMag(sigma, image, t) 

[mag, ~] = gradmag(image, sigma);

cut = imbinarize(mag, t);

figure
imshow(cut, [])


end