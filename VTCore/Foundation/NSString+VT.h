//
//  NSString+VT.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FTTimeFormat @"yyyy-MM-dd HH:mm"

//@"yyyy-MM-dd HH:mm:ss"
@interface NSString (VT)
//gbk初始化
- (id)initWithGBKBytes:(const char *)bytes length:(NSUInteger)len;
//utf16初始化
- (id)initWithUTF16LittleEndBytes:(const void *)bytes length:(NSUInteger)len;

//bgk str
- (const char *)cGBKBytes;

//计算字符串在指定宽度下的大小
- (CGSize)sizeWithFont:(UIFont *)aFont onWidth:(CGFloat)aWidth;

#define kVTDateFormatAll @"yyyy-MM-dd HH:mm:ss"
//把日期转换为当前时区的时间
- (NSDate *)dateWithFormat:(NSString *)aFormat; //@"yyyy-MM-dd"

//计算两个时间的间隔
- (CGFloat)calculateToTime:(NSString *)str1;

//特殊转移字符处理
- (NSString *)encodeWithURLFormat;

//计算字符串的长度
- (NSUInteger)unicodeSize;

//是否是纯整形
- (BOOL)isPureInt;

+ (NSStringEncoding)gbkEncoding;

//去掉前后和换行的空格
- (NSString *)pureString;

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
- (BOOL)isValidIdentityCard;

//判断是否是电话号码
- (BOOL)isValidPhoneNumber;

//判断是否是邮箱格式
- (BOOL)isValidEmail;

+ (NSString *)conver2TimeString:(NSUInteger)aSec;
////特殊转移字符处理
+ (NSString *)encodeURLString:(NSString *)str;

//Byte数组－>16进制数
- (NSString *)hexStringFromData:(NSData *)aData;
- (NSData *)dataFromHexString;
@end


@interface NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end
