function comparisonMagOr( sigma )

figure

[zebraMag, zebraOr] = gradmag('zebra.png',sigma);
[pn1Mag, pn1Or] = gradmag('pn1.jpg',sigma);

subplot(2,5,1) 
imshow(zebraMag, [-pi,pi])
colormap(hsv)
colorbar
title(sprintf('Gradient magnitude, sigma %0.4f',sigma))

subplot(2,5,2) 
imshow(zebraOr, [-pi,pi])
colormap(hsv)
colorbar
title(sprintf('Gradient orientation, sigma %0.4f',sigma))

subplot(2,5,3)
quiver(zebraOr, zebraMag)
set(gca,'YDir','reverse')
title(sprintf('Quiver plot, sigma %0.4f',sigma))

subplot(2,5,4)
imshow(gaussianImage('zebra.png',sigma,sigma))
title('Blur image')

subplot(2,5,5)
imshow(imGrayscale('zebra.png'))
title('Original')

subplot(2,5,6) 
imshow(pn1Mag, [-pi,pi])
colormap(hsv)
colorbar

subplot(2,5,7) 
imshow(pn1Or, [-pi,pi])
colormap(hsv)
colorbar

subplot(2,5,8)
quiver(imread([],[],pn1Or, pn1Mag)
set(gca,'YDir','reverse')

subplot(2,5,9)
imshow(gaussianImage('pn1.jpg',sigma,sigma))

subplot(2,5,10)
imshow(imGrayscale('pn1.jpg'))

end