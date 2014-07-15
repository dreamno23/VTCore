//
//  VTFilter.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "VTFilter.h"
#import "VTFilterType.h"
#import "UIImage+VT.h"
@implementation VTFilter

//base function
+ (NSData *)dataFromImage:(UIImage *)aImage
{
    return [aImage argb8Data];
}

+ (UIImage *)imageFromData:(NSData *)aData imageSize:(CGSize)aImageSize
{
    return [UIImage imageWithArgb8Data:aData imageSize:aImageSize];
}

//function
+ (UIImage *)filterImage:(UIImage *)aImage withStype:(VTFilterStyle)aStype
{
    NSData *imgData = [self dataFromImage:aImage];
    CGSize imgSize = CGSizeMake(CGImageGetWidth(aImage.CGImage),
                                CGImageGetHeight(aImage.CGImage));
    VTFilterType *subFilter = nil;
    switch (aStype) {
        case kVTFilterStyleInverse:
            subFilter = [[VTFilterInReverse alloc]initWithImageData:imgData imageSize:imgSize paramValue:NULL];
            break;
        case kVTFilterStyleSmooth: {
            subFilter = [[VTFilterSmooth alloc]initWithImageData:imgData imageSize:imgSize paramValue:NULL];
            break;
        }
        case kVTFilterStyleRainbow: {
            subFilter = [[VTFilterRainbow alloc]initWithImageData:imgData imageSize:imgSize paramValue:NULL];
            break;
        }
        case kVTFilterStyleSharpen: {
            subFilter = [[VTFilterSharpen alloc]initWithImageData:imgData imageSize:imgSize paramValue:NULL];
            break;
        }
        default:
            break;
    }
    if (subFilter == nil) {
        return aImage;
    }
    NSData *newData = [subFilter newImageData];
    UIImage *newImg = [self imageFromData:newData imageSize:imgSize];
    return newImg;
}
@end
