//
//  OpenCVWrapper.m
//  Tesseract
//
//  Created by Velichkin Nikita on 25/01/2019.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

+ (UIImage *) grayscale: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    if (imageMat.channels() == 1) return image;
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, cv::COLOR_BGR2GRAY);
    return MatToUIImage(grayMat);
}

+ (UIImage *) resize: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat resizeMat;
    cv::resize(imageMat, resizeMat, cv::Size(), 1.5, 1.5, cv::INTER_CUBIC);
    return MatToUIImage(resizeMat);
}

+ (UIImage *) erode: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat erodeMat;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT,cv::Size(3,3));
    cv::erode(imageMat, erodeMat, element);
    return MatToUIImage(erodeMat);
}

+ (UIImage *) dilate: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat delateMat;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT,cv::Size(2,3));
    cv::dilate(imageMat, delateMat, element);
    return MatToUIImage(delateMat);
}

+ (UIImage *) morphologyEx: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image,imageMat);
    cv::Mat morphMat;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(15, 15));
    cv::Mat element2 = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5, 5));
    cv::morphologyEx(imageMat, morphMat, cv::MORPH_OPEN, element);
    return MatToUIImage(morphMat);
}

+ (UIImage *) adaptiveThreshold: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat thMat;
    cv::adaptiveThreshold(imageMat, thMat, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 69, 30); //Calculate
    return MatToUIImage(thMat);
}

+ (UIImage *) blur: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat thMat;
    cv::blur(imageMat, thMat, cv::Size(3,3));
    return MatToUIImage(thMat);
}

+ (UIImage *) threshold: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat thMat;
    cv::threshold(imageMat, thMat, 125, 255, cv::THRESH_BINARY + cv::THRESH_OTSU);
    return MatToUIImage(thMat);
}

+ (UIImage *) medianBlur: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat mMat;
    cv::GaussianBlur(imageMat, mMat, cv::Size(3,3), 0);
    return MatToUIImage(mMat);
}

+ (UIImage *) findContours: (UIImage *)image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::Mat contourOutput = imageMat.clone();
    std::vector<std::vector<cv::Point> > contours;
    cv::findContours( contourOutput, contours, cv::RETR_TREE, cv::CHAIN_APPROX_NONE );
    int largest_area=0;
    int largest_contour_index=0;
    for( int i = 0; i< contours.size(); i++ )
    {
        double a=contourArea( contours[i],false);
        if(a>largest_area){
            largest_area=a;std::cout<<i<<" area  "<<a<<std::endl;
            largest_contour_index=i;
            
        }
    }
    
    cv::Scalar color;
    color = cv::Scalar(0, 0, 255, 0);
    cv::Canny(imageMat, contourOutput, 155, 255);
    cv::drawContours(contourOutput, contours, largest_contour_index, color);
    return MatToUIImage(contourOutput);
}


@end
