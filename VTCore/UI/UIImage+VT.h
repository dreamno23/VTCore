//
//  UIImage+VT.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSData *UIImagePNGRepresentation(UIImage *image);                               // return image as PNG. May return nil if image has no CGImageRef or invalid bitmap format
UIKIT_EXTERN NSData *UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality);  // return image as JPEG. May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)

//rgba或者argb
/* alphaInfo :kCGImageAlphaPremultipliedLast /kCGImageAlphaPremultipliedFirst
 * 创建contexRef
 */
UIKIT_EXTERN CGContextRef vtCreateRGBABitmapContext(CGImageRef inImage,CGImageAlphaInfo alphaInfo);

/**画图并旋转
 *翻转坐标，旋转图片
 * angle:角度，M_PI
 */
UIKIT_EXTERN void vtDrawImageByAngle(CGContextRef context, CGImageRef image , CGRect rect, CGFloat angle);

@interface UIImage (VT)
//convert 2 argb8
- (NSData *)argb8Data;

//conver from argb8
+ (id)imageWithArgb8Data:(NSData *)aData imageSize:(CGSize)aSize;

//缩放剪切图片到指定大小
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

//旋转图片
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//rgb32位data转image
+ (UIImage *)imageWith32RGB:(unsigned char *)imgPixel width:(NSInteger)aWidth height:(NSInteger)aHeight;

//image转为rbg32 data
- (unsigned char *)convertImagePixelData;

//调整图片尺寸
- (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height;

//把一张图拉成两半,返回nil或者长度为2的uiimage
- (NSArray *)splitImageIntoTwoParts;

/*将当前图片制作一个投影图，
*fromBounds:当前图片原始imageView显示的bounds,
*height:投影的高度
 */
- (UIImage *)reflectedFromBound:(CGRect)fromBounds withHeight:(NSUInteger)height;
@end
