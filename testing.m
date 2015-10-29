clear;
close all;
clc;

imageName = 'TestImages\blob_2';
inputImage = imread(strcat(imageName, '.png'),'png');

area = myArea(inputImage, 255);
centroid = myCentroid(inputImage, 255);

rowMoment = myRowMoment(inputImage, 255);
colMoment = myColMoment(inputImage, 255);
mixMoment = myMixMoment(inputImage, 255);

[ objectMostInertia, theta_max ] = myMostInertia(inputImage, 255);
[ objectLeastInertia, theta_min ] = myLeastInertia(inputImage, 255);

erosionImage = myErosion(inputImage);
imwrite(erosionImage, strcat(imageName, '_erosion.png'), 'png');

borderImage = myBorder(inputImage);
imwrite(borderImage, strcat(imageName, '_border.png'), 'png');

circularity = myCircularity(inputImage, 255);

angleHistogram = myAngleHistogram(inputImage, 255);
    figure();
    x = linspace(1,360,360);
    bar(x, angleHistogram, 'r');
    axis([0 370 0 0.5]);
    set(gca,'XTick', 0:30:370)