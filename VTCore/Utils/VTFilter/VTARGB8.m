//
//  VTARGB8.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "VTARGB8.h"

@implementation VTARGB8


+(VTARGB8PointValue)pointValueFromData:(NSData *)imageData
                      pointIndex:(CGPoint)pointIndex
                       imageSize:(CGSize)imageSize
{
    NSInteger bitmapBytesPerRow = imageSize.width*4;
    
    NSUInteger index = pointIndex.x * 4 + (pointIndex.y * bitmapBytesPerRow);
    
    const unsigned char * bytes = (const unsigned char *)[imageData bytes];
    
    VTARGB8PointValue point = {0};
    point.alpha = bytes[index];
    point.red = bytes[index+1];
    point.green = bytes[index+2];
    point.blue = bytes[index+3];

    return point;
}

+(VTARGB8PointValue)pointValueFromData:(NSData *)imageData
                           index:(NSInteger)index
                       imageSize:(CGSize)imageSize
{
    NSInteger bitmapBytesPerRow = imageSize.width;
    
    NSInteger x = index % bitmapBytesPerRow;
    NSInteger y = index / bitmapBytesPerRow;
    
    return [VTARGB8 pointValueFromData:imageData pointIndex:CGPointMake(x,y) imageSize:imageSize];
}

@end
