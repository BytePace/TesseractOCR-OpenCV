//
//  OpenCVWrapper.h
//  Tesseract
//
//  Created by Velichkin Nikita on 25/01/2019.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (UIImage *) grayscale: (UIImage *)image;
+ (UIImage *) resize: (UIImage *)image;
+ (UIImage *) dilate: (UIImage *)image;
+ (UIImage *) erode: (UIImage *)image;
+ (UIImage *) threshold: (UIImage *)image;
+ (UIImage *) blur: (UIImage *)image;
+ (UIImage *) adaptiveThreshold: (UIImage *)image;
+ (UIImage *) medianBlur: (UIImage *)image;
+ (UIImage *) morphologyEx: (UIImage *)image;
+ (UIImage *) findContours: (UIImage *)image;

@end

NS_ASSUME_NONNULL_END
