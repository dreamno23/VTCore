//
//  VTCommonDef.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#ifdef DEBUG
#define VTLog( s, ... )  NSLog( @"%@",[NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define VTLog( s, ... )
#endif



#ifdef  __cplusplus
extern "C" {
#endif
//function
#ifdef  __cplusplus
}
#endif


typedef void (^VTBlockVoid)(void);
typedef void (^VTBlockParam)(id aParam);
typedef void (^VTBlockBool)(BOOL isTrue);


//是否ios7
#define ISIOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define ISiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//颜色值
#define vtColor255(x,y,z)       vtColor255a(x,y,z,1.0f)
//颜色值
#define vtColor255a(x,y,z,a)    [UIColor colorWithRed:(float)x/255.0f green:(float)y/255.0f blue:(float)z/255.0f alpha:a]

//eg:0xFFFFFF代表白色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbaValue & 0xFF))/255.0]

//字体大小
#define VTBoldSystemFontOfSize(x)   [UIFont boldSystemFontOfSize:x*1.1]
#define VTSystemFontOfSize(x)       [UIFont systemFontOfSize:x*1.1]

#define VTAbstractInterface  interface//抽象类

//图片设置
#define vtImageWithName(aName) [UIImage imageNamed:aName]

#define vtImageAlloc(aName,aType) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aName ofType:aType]]

#define vtImagePath(pic,type) [[NSBundle mainBundle] pathForResource:pic ofType:type]

//TARGET_IPHONE_SIMULATOR  TARGET_OS_IPHONE  __IPHONE_7_0  __IPHONE_OS_VERSION_MAX_ALLOWED
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000