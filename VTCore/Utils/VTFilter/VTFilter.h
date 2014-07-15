//
//  VTFilter.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum VTFilterStyle_ {
    kVTFilterStyleNone,    //默认
    kVTFilterStyleInverse, // 反色
    kVTFilterStyleSmooth,  //平滑
    kVTFilterStyleRainbow, //霓虹
    kVTFilterStyleSharpen, //锐化
}VTFilterStyle;


@interface VTFilter : NSObject

//base function --ARGB8
+ (NSData *)dataFromImage:(UIImage *)aImage;

//--argb8 data
+ (UIImage *)imageFromData:(NSData *)aData imageSize:(CGSize)aSize;

//function
+ (UIImage *)filterImage:(UIImage *)aImage withStype:(VTFilterStyle)aStype;

@end
