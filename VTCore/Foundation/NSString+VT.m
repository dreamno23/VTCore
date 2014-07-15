//
//  NSString+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "NSString+VT.h"
#import "RegexKitLite.h"
#import "NSData+Base64.h"

@implementation NSString (VT)


- (id)initWithGBKBytes:(const char *)bytes length:(NSUInteger)len
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self initWithBytes:bytes length:len encoding:enc];
}

- (id)initWithUTF16LittleEndBytes:(const void *)bytes length:(NSUInteger)len
{
    return [self initWithBytes:bytes length:len + len encoding:NSUTF16LittleEndianStringEncoding];
}

- (CGSize)sizeWithFont:(UIFont *)aFont onWidth:(CGFloat)aWidth;
{
    if ([self length] == 0) {
        return CGSizeZero;
    }
    CGSize size;
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
        NSDictionary *boundDic = @{NSFontAttributeName:aFont};
        size = [self boundingRectWithSize:CGSizeMake(aWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:boundDic context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:aFont
                constrainedToSize:CGSizeMake(aWidth, 10000)
                    lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
//    NSDictionary *boundDic = @{NSFontAttributeName:aFont};
//    size = [self boundingRectWithSize:CGSizeMake(aWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:boundDic context:nil].size;
//#else
//    size = [self sizeWithFont:aFont
//                   constrainedToSize:CGSizeMake(aWidth, 10000)
//                       lineBreakMode:NSLineBreakByCharWrapping];
//#endif
    return size;
}

- (const char *)cGBKBytes
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self cStringUsingEncoding:enc];
}

- (NSDate *)dateWithFormat:(NSString *)aFormat
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:aFormat];
    NSDate *date = [timeFormat dateFromString:self];
    return date;
}

- (CGFloat)calculateToTime:(NSString *)str1
{
    NSDate *date1 = [self dateWithFormat:FTTimeFormat];
    NSDate *date2 = [str1 dateWithFormat:FTTimeFormat];
    NSString *str = [NSString stringWithFormat:@"%f",[date1 timeIntervalSinceDate:date2]/(24*60*60)];
    NSArray *arr = [str componentsSeparatedByString:@"."];
    NSString *day = [arr objectAtIndex:0];
    CGFloat a = [str floatValue] - [day floatValue];
    CGFloat b = 0.166666; 
    if (a <= b) { //小于或等于4小时 按小时算
        NSString *minute = [NSString stringWithFormat:@"%.1f",(a*24/10)];
        return [day floatValue] + [minute floatValue];
    } else { //大于4小时按1天算
        return [day floatValue] + 1;
    }
}

- (NSUInteger)unicodeSize
{
    NSUInteger  len = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            len++;
        }
        else {
            p++;
        }
    }
    return len;
}
//特殊转移字符处理
- (NSString *)encodeWithURLFormat
{
    NSString *newString = (__bridge NSString *)((__bridge CFTypeRef)((NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                                           kCFAllocatorDefault,
                                                                                                                                           (CFStringRef)self, NULL, CFSTR(":?/#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                                                                                           kCFStringEncodingUTF8))));
    if (newString) {
        return newString;
    }
    return @"";
}
//判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    BOOL sc = [scan scanInteger:&val];
    BOOL end = [scan isAtEnd];
    return sc && end;
}

+ (NSStringEncoding)gbkEncoding
{
    return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSString *)pureString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#define CHINA_ID_MAX_LENGTH 18 //中国公民身份证号码最大长度
#define CHINA_ID_MIN_LENGTH 15 //中国公民身份证号码最小长度

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
- (BOOL)isValidIdentityCard
{
    NSString *sPaperId = self;
    //判断位数
    if ([sPaperId length] != CHINA_ID_MIN_LENGTH && [sPaperId length] != CHINA_ID_MAX_LENGTH) {
        return NO;
    }
    NSString *carid = sPaperId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == CHINA_ID_MIN_LENGTH) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    //判断是否在地区码内
    NSString * sProvince = [carid substringToIndex:2];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    if ([dic objectForKey:sProvince] == nil) {
        return NO;
    }
    //判断年月日是否有效
    //年份
    int strYear = [[carid substringWithRange:NSMakeRange(6, 4)] intValue];
    //月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10, 2)] intValue];
    //日
    int strDay = [[carid substringWithRange:NSMakeRange(12, 2)] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    //检验长度
    if( CHINA_ID_MAX_LENGTH != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<CHINA_ID_MAX_LENGTH; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    return YES;
}

//判断是否是电话号码
- (BOOL)isValidPhoneNumber
{
    if ([self length] == 0) {
        return NO;
    }
    if ([self isPureInt]) {
        if ([self isMatchedByRegex:@"^1[0-9]{10}$"]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

//判断是否是邮箱格式
- (BOOL)isValidEmail
{
    if ([self length] == 0) {
        return NO;
    }
    if ([self isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]) {
        NSArray *arr = [self componentsSeparatedByString:@"@"];
        if (arr && [arr count] > 1) {
            NSString *str = [arr objectAtIndex:1];
            arr = [str componentsSeparatedByString:@"."];
            if (arr && [arr count] > 2) {
                return NO;
            }
        }
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)conver2TimeString:(NSUInteger)aSec
{
    NSInteger mins = aSec/60;
    NSString *minStr = nil;
    if (mins <= 0) {
        return minStr;
    }
    NSInteger h = mins / 60;
    NSInteger min = mins % 60;
    if (h > 0 && min > 0) {
        minStr = [NSString stringWithFormat:@"%d小时%d分",h, min];
    } else if (h > 0){
        minStr = [NSString stringWithFormat:@"%d小时",h];
    } else {
        minStr = [NSString stringWithFormat:@"%d分钟",mins];
    }
    return minStr;
}
//特殊转移字符处理
+ (NSString *)encodeURLString:(NSString *)str
{
    CFStringRef ref = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)str, NULL, CFSTR(":?/#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8);
    NSString *newString = (__bridge NSString *)ref;
    NSString *retString = [[NSString alloc]initWithString:newString];
    CFRelease(ref);
    if (newString) {
        return retString;
    }
    return nil;
}

//Byte数组－>16进制数
-(NSString *)hexStringFromData:(NSData *)aData
{
    Byte *bytes = (Byte *)[aData bytes];
    NSMutableString *hexString = [[NSMutableString alloc]initWithCapacity:0];
    for(int i=0;i<[aData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",bytes[i]&0xff];///16进制数
        [hexString appendString:newHexStr];
    }
    return hexString;
}

//    16进制数－>Byte数组
- (NSData *)dataFromHexString
{
    ///// 将16进制数据转化成Byte 数组
    NSString *hexString = self; //16进制字符串
    int j=0;
    Byte bytes[self.length];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[self length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
//        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[self length]];
    return newData;
}
@end


@implementation NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}

@end
