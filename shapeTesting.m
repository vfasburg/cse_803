clear;
close all;
clc;

imageName = 'TestImages\blob_6';
inputImage = imread(strcat(imageName, '.png'),'png');

area = getArea(inputImage, 255);
centroid = getCentroid(inputImage, 255);

rowMoment = getRowMoment(inputImage, 255);
colMoment = getColMoment(inputImage, 255);
mixMoment = getMixMoment(inputImage, 255);

[ objectMostInertia, theta_max ] = getMostInertia(inputImage, 255);
[ objectLeastInertia, theta_min ] = getLeastInertia(inputImage, 255);

erosionImage = getErosion(inputImage);
imwrite(erosionImage, strcat(imageName, '_erosion.png'), 'png');

borderImage = getBorder(inputImage);
imwrite(borderImage, strcat(imageName, '_border.png'), 'png');

circularity = getCircularity(inputImage, 255);

angleHistogram = getAngleHistogram(inputImage, 255, 5);
    figure();
    x = linspace(1,8,8);
    bar(x, angleHistogram, 'r');
    axis([0 9 0 1]);
    set(gca,'XTick', 0:1:8)