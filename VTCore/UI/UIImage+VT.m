//
//  UIImage+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UIImage+VT.h"

#define SAWTOOTH_COUNT 10
#define SAWTOOTH_WIDTH_FACTOR 20

//rgba或者argb
/* alphaInfo :kCGImageAlphaPremultipliedLast /kCGImageAlphaPremultipliedFirst
 *
 */
CGContextRef vtCreateRGBABitmapContext (CGImageRef inImage,CGImageAlphaInfo alphaInfo)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space");
        return NULL;
    }
    // allocate the bitmap & create context
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     
                                     pixelsWide,
                                     
                                     pixelsHigh,
                                     
                                     8,
                                     
                                     bitmapBytesPerRow,
                                     
                                     colorSpace,
                                     
                                     kCGBitmapByteOrderDefault | alphaInfo);
    
    if (context == NULL){
        fprintf (stderr, "Context not created!");
    }
    free (bitmapData);
    CGColorSpaceRelease( colorSpace );
    return context;
}

/**画图并旋转
 *翻转坐标，旋转图片
 *
 */
void vtDrawImageByAngle(CGContextRef context, CGImageRef image , CGRect rect, CGFloat angle)
{
    //保存状态
    CGContextSaveGState(context);
    //移动
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);//4
    
    //旋转并移回到原处
    CGContextTranslateCTM(context, rect.size.width/2, rect.size.height/2);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -rect.size.width/2, -rect.size.height/2);
    
    //翻转
    CGContextTranslateCTM(context, 0, rect.size.height);//3
    CGContextScaleCTM(context, 1.0, -1.0);//2
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);//1
    CGContextDrawImage(context, rect, image);//画图
    
    CGContextRestoreGState(context);//恢复状态
}
//创建一个渐变图
CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
    
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}

//创建一个bitmapContext
CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

@implementation UIImage (VT)

//convert 2 argb8
- (NSData *)argb8Data
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    unsigned long             bitmapByteCount;
    unsigned long             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(self.CGImage);
    size_t pixelsHigh = CGImageGetHeight(self.CGImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    //malloc不初始化,calloc初始化,解决透明图片不正常问题
    bitmapData = calloc(sizeof(char), bitmapByteCount);
    //    bitmapData = malloc(bitmapByteCount);
    
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        //        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    CGRect rect = CGRectMake(0, 0,pixelsWide,pixelsHigh);
    CGContextDrawImage(context, rect, self.CGImage);
    void *data = CGBitmapContextGetData (context);
    CGContextRelease(context);
    if (!data)
        return nil;
    size_t dataSize = 4 * pixelsWide * pixelsHigh; // ARGB = 4 8-bit components
    NSData * newData = [NSData dataWithBytes:data length:dataSize];
    free(data);
    return newData;
}

//conver from argb8
+ (id)imageWithArgb8Data:(NSData *)aData imageSize:(CGSize)aSize
{
    void * bitmapData = (void *)[aData bytes];
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned long             bitmapByteCount;
    unsigned long             bitmapBytesPerRow;
    size_t pixelsWide = aSize.width;
    size_t pixelsHigh = aSize.height;
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
    }
    CGColorSpaceRelease( colorSpace );
    CGImageRef newnew = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage * newImg = [UIImage imageWithCGImage:newnew];
    CGImageRelease(newnew);
    return newImg;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (NO) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (UIImage*)imageWith32RGB:(unsigned char *)imgPixel width:(NSInteger)aWidth height:(NSInteger)aHeight
{
#if 0   //rgb 565转555
    for( int y = 0; y < pBmp->usHeight; y++ )
    {
        for( int x = 0; x < pBmp->usWidth; x++ )
        {
            usTmp = pSrc[x];
            usTmp = ((usTmp&0xFFC0)>>1)|(usTmp&0x1F); // 565 to 555
            pDec[x] = usTmp;
        }
        pSrc += pBmp->usWidth;
        pDec += pBmp->usWidth;
    }
#endif
    size_t dataLength = aWidth * aHeight * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * aWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate((size_t)aWidth, (size_t)aHeight,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
    
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}

- (unsigned char *)convertImagePixelData
{
    CGImageRef img = [self CGImage];
    CGSize size = [self size];
    CGContextRef cgctx = vtCreateRGBABitmapContext(img,kCGImageAlphaPremultipliedLast);
    if (cgctx == NULL)
        return NULL;
    CGRect rect = {{0,0},{size.width, size.height}};
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = (unsigned char *)CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    return data;
}

- (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, destW, destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4 * destW, CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (NSArray *)splitImageIntoTwoParts
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    CGFloat width,height,widthgap,heightgap;
    int piceCount = SAWTOOTH_COUNT;
    width = self.size.width;
    height = self.size.height;
    widthgap = width / SAWTOOTH_WIDTH_FACTOR;
    heightgap = height / piceCount;
    //    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextRef context;
    CGImageRef imageMasked;
    UIImage *leftImage,*rightImage;
    
    //part one
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, 0, 0);
    int a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, 0, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [self drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    leftImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:leftImage];
    UIGraphicsEndImageContext();
    
    //part two
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, width, 0);
    a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, width, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [self drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    rightImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:rightImage];
    UIGraphicsEndImageContext(); 
    return array;
}

- (UIImage *)reflectedFromBound:(CGRect)fromBounds withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromBounds.size.width, (int)height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, (int)height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromBounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, fromBounds, self.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}
@end
