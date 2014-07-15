//
//  VTUILabel.h
//  VTCore
//
//  Created by 黄莉萍 on 14-2-25.
//  Copyright (c) 2014年 Raxtone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FN)

- (void)setAdjustHeightText:(NSString *)text;
- (void)setTwoLineText:(NSString *)text;
- (CGSize)contentSize;
+ (UILabel *)labelWithFrame:(CGRect)aF;
+ (UILabel *)labelWithFrame:(CGRect)aF
                  textAlign:(NSTextAlignment)alig
                  textColor:(UIColor *)aTColor
                   textFont:(UIFont *)aFont
                    isBreak:(BOOL)aBreak;
- (void)initWithFont:(UIFont *)font andColor:(UIColor *)color;
@end

//UILabel 效果扩展
@interface VTUILabel : UILabel
@property (nonatomic, assign) CGFloat shadowBlur;           //发散阴影 offset
@property (nonatomic, assign) CGSize innerShadowOffset;     //内发散阴影 offset
@property (nonatomic, strong) UIColor *innerShadowColor;    //内发散阴影颜色
@property (nonatomic, strong) UIColor *gradientStartColor;  //起始渐变颜色值
@property (nonatomic, strong) UIColor *gradientEndColor;    //终点渐变颜色值
@property (nonatomic, copy) NSArray *gradientColors;        //渐变颜色数组
@property (nonatomic, assign) CGPoint gradientStartPoint;   //渐变颜色起点
@property (nonatomic, assign) CGPoint gradientEndPoint;     //渐变颜色终点
@property (nonatomic, assign) NSUInteger oversampling;      //文字采样率
@property (nonatomic, assign) UIEdgeInsets textInsets;      //文字inset
@end

@interface VTDrawLabelData : NSObject
@property (nonatomic, readonly) CGSize size;

@property (nonatomic,strong) UIFont *font;
@property(nonatomic, strong) UIColor *fontColor;
@property(nonatomic, copy) NSString *drawStr;
+ (VTDrawLabelData *)labelDataWithFont:(UIFont *)aFont
                                 color:(UIColor *)aColor
                                  text:(NSString *)aStr;
@end

@interface VTDrawLabel : UILabel {
    NSMutableString *memText_;
}

@property (nonatomic, copy)NSArray *dataArray;

- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)array;
@end
