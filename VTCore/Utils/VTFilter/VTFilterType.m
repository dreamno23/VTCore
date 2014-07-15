//
//  VTFilterType.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "VTFilterType.h"

@implementation VTFilterType
@synthesize m_imageData = m_imageData_;
-(void)dealloc
{
}
-(id)initWithImageData:(NSData *)imageData imageSize:(CGSize)imageSize paramValue:(void *)aParam
{
    if (imageData == nil) {
        return nil;
    }
    if (self = [super init]) {
        m_imageData_ = imageData;
        m_imageSize_ = imageSize;
        param = aParam;
    }
    return self;
}

- (NSData *)newImageData
{
    return nil;
}

@end

@implementation VTFilterInReverse

- (NSData *)newImageData
{
    const unsigned char *rawDataBytes = (const unsigned char *)[m_imageData_ bytes];
    NSMutableData * newData = [[NSMutableData alloc] init];
    for (int i = 0 ; i<[m_imageData_ length]; i=i+4) {
        Byte a = rawDataBytes[i];
        Byte r = rawDataBytes[i+1];
        Byte g = rawDataBytes[i+2];
        Byte b = rawDataBytes[i+3];
        
        Byte rr = 255^r;
        Byte gg = 255^g;
        Byte bb = 255^b;
        
        [newData appendBytes:&a length:sizeof(char)];
        [newData appendBytes:&rr length:sizeof(char)];
        [newData appendBytes:&gg length:sizeof(char)];
        [newData appendBytes:&bb length:sizeof(char)];
        
    }
    return newData;
}

@end

@implementation VTFilterSmooth
//必须奇数
#define Matrix_Num 3
-(VTARGB8PointValue)getSmoothPoint:(int)index
{
    int bitmapBytesPerRow = m_imageSize_.width;
    int bitmapRow = m_imageSize_.height;
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    int matrixHalf = Matrix_Num/2;
    //点在图片边上
    //行
    if (x<matrixHalf || x > bitmapBytesPerRow - matrixHalf ||
        y<matrixHalf || y > bitmapRow - matrixHalf) {
        return [VTARGB8 pointValueFromData:m_imageData_ index:index imageSize:m_imageSize_];
    }
    
    //矩阵中各值之和
    int t_r = 0;
    int t_g = 0;
    int t_b = 0;
    Byte a = 0;
    for (int i = x - matrixHalf; i<= x + matrixHalf; i++) {
        for (int j = y - matrixHalf; j<= y + matrixHalf; j++) {
            VTARGB8PointValue point = [VTARGB8 pointValueFromData:m_imageData_
                                                 pointIndex:CGPointMake(i, j)
                                                  imageSize:m_imageSize_];
            t_r +=point.red;
            t_g +=point.green;
            t_b +=point.blue;
            if (i == x && j == y) {
                a = point.alpha;
            }
        }
    }
    VTARGB8PointValue newPoint;
    newPoint.alpha = a;
    newPoint.red = t_r/(Matrix_Num * Matrix_Num);
    newPoint.green = t_g/(Matrix_Num * Matrix_Num);
    newPoint.blue = t_b/(Matrix_Num * Matrix_Num);
    return newPoint;
}
- (NSData *)newImageData
{
    NSMutableData * newData = [[NSMutableData alloc] init];
    for (int i = 0 ; i<m_imageSize_.width * m_imageSize_.height; i++) {
        VTARGB8PointValue point = [self getSmoothPoint:i];
        [newData appendBytes:&point.alpha length:sizeof(char)];
        [newData appendBytes:&point.red length:sizeof(char)];
        [newData appendBytes:&point.green length:sizeof(char)];
        [newData appendBytes:&point.blue length:sizeof(char)];
    }
    return newData;
}

@end

@implementation VTFilterRainbow
-(VTARGB8PointValue)getSmoothPoint:(int)index
{
    int bitmapBytesPerRow = m_imageSize_.width;
    int bitmapRow = m_imageSize_.height;
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    int matrixHalf = Matrix_Num/2;
    //点在图片边上
    //行
    if ( x > bitmapBytesPerRow - matrixHalf ||
        y > bitmapRow - matrixHalf) {
        return [VTARGB8 pointValueFromData:m_imageData_ index:index imageSize:m_imageSize_];
    }
    VTARGB8PointValue point = [VTARGB8 pointValueFromData:m_imageData_
                                         pointIndex:CGPointMake(x, y)
                                          imageSize:m_imageSize_];
    
    VTARGB8PointValue point1 = [VTARGB8 pointValueFromData:m_imageData_
                                          pointIndex:CGPointMake(x+1, y)
                                           imageSize:m_imageSize_];
    
    VTARGB8PointValue point2 = [VTARGB8 pointValueFromData:m_imageData_
                                          pointIndex:CGPointMake(x, y+1)
                                           imageSize:m_imageSize_];
    int r = 2*(int)sqrt((point.red - point1.red)*(point.red - point1.red) + (point.red - point2.red)*(point.red - point2.red));
    int g = 2*(int)sqrt((point.green - point1.green)*(point.green - point1.green) + (point.green - point2.green)*(point.green - point2.green));
    int b = 2*(int)sqrt((point.blue - point1.blue)*(point.blue - point1.blue) + (point.blue - point2.blue)*(point.blue - point2.blue));
    Byte a = point.alpha;

    VTARGB8PointValue newPoint;
    newPoint.alpha = a;
    newPoint.red = r;
    newPoint.green = g;
    newPoint.blue = b;
    
    return newPoint;
}
- (NSData *)newImageData
{
    NSMutableData * newData = [[NSMutableData alloc] init];
    for (int i = 0 ; i<m_imageSize_.width * m_imageSize_.height; i++) {
        VTARGB8PointValue point = [self getSmoothPoint:i];
        [newData appendBytes:&point.alpha length:sizeof(char)];
        [newData appendBytes:&point.red length:sizeof(char)];
        [newData appendBytes:&point.green length:sizeof(char)];
        [newData appendBytes:&point.blue length:sizeof(char)];
    }
    return newData;
}

@end

@implementation VTFilterSharpen
- (id)initWithImageData:(NSData *)imageData imageSize:(CGSize)imageSize paramValue:(void *)aParam
{
    self = [super initWithImageData:imageData imageSize:imageSize paramValue:aParam];
    if (self) {
        m_sharpNum = *(int *)aParam;
    }
    return self;
}
-(VTARGB8PointValue)getSmoothPoint:(int)index
{
    int bitmapBytesPerRow = m_imageSize_.width;
    //    int bitmapRow = m_imageSize.height;
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    int matrixHalf = 1;
    //点在图片边上
    //行
    if ( x < matrixHalf ||
        y < matrixHalf) {
        return [VTARGB8 pointValueFromData:m_imageData_ index:index imageSize:m_imageSize_];
    }
    VTARGB8PointValue point = [VTARGB8 pointValueFromData:m_imageData_
                                         pointIndex:CGPointMake(x, y)
                                          imageSize:m_imageSize_];
    
    VTARGB8PointValue point1 = [VTARGB8 pointValueFromData:m_imageData_
                                          pointIndex:CGPointMake(x-1, y-1)
                                           imageSize:m_imageSize_];

    int r = fabs(point.red - point1.red) * m_sharpNum + point.red;
    int g = fabs(point.green - point1.green) * m_sharpNum + point.green;
    int b = fabs(point.blue - point1.blue) * m_sharpNum + point.blue;
    Byte a = point.alpha;

    VTARGB8PointValue newPoint;
    newPoint.alpha = a;
    newPoint.red = r;
    newPoint.green = g;
    newPoint.blue = b;
    
    return newPoint;
}

- (NSData *)newImageData
{
    NSMutableData * newData = [[NSMutableData alloc] init];
    for (int i = 0 ; i<m_imageSize_.width * m_imageSize_.height; i++) {
        VTARGB8PointValue point = [self getSmoothPoint:i];
        [newData appendBytes:&point.alpha length:sizeof(char)];
        [newData appendBytes:&point.red length:sizeof(char)];
        [newData appendBytes:&point.green length:sizeof(char)];
        [newData appendBytes:&point.blue length:sizeof(char)];
    }
    return newData;
}
@end