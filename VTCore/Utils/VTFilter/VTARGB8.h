//
//  VTARGB8.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

// 获取图片的arbg值

#import <Foundation/Foundation.h>


typedef struct {
    unsigned char alpha;
    unsigned char red;
    unsigned char green;
    unsigned char blue;
}VTARGB8PointValue;

@interface VTARGB8 : NSObject

//取值按照argb取
+ (VTARGB8PointValue)pointValueFromData:(NSData *)imageData
                      pointIndex:(CGPoint)pointIndex
                       imageSize:(CGSize)imageSize;

//取值按照argb取
+ (VTARGB8PointValue)pointValueFromData:(NSData *)imageData
                           index:(NSInteger)index
                       imageSize:(CGSize)imageSize;
@end
