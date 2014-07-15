//
//  VTUILabel.m
//  VTCore
//
//  Created by 黄莉萍 on 14-2-25.
//  Copyright (c) 2014年 Raxtone. All rights reserved.
//

#import "VTUILabel.h"

#define ISIOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0

@implementation UILabel (FN)

//
- (void)setAdjustHeightText:(NSString *)text
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGRect rect = [self frame];
    rect.size = [text sizeWithFont:[self font] constrainedToSize:CGSizeMake(rect.size.width, 1000.f) lineBreakMode:NSLineBreakByWordWrapping];
    #pragma clang diagnostic pop
//    rect = [text boundingRectWithSize:CGSizeMake(rect.size.width, 1000.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil]; ios7
    //    rect.size.width = [self frame].size.width;
    if (rect.size.height < [self frame].size.height) {
        rect.size.height = [self frame].size.height;
    }
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setFrame:rect];
    [self setText:text];
}

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize;
    if (ISIOS7) {
        contentSize = [self.text boundingRectWithSize:self.frame.size
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:attributes
                                             context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        contentSize = [self.text sizeWithFont:[self font]
         constrainedToSize:CGSizeMake(self.frame.size.width, 1000.f)
             lineBreakMode:self.lineBreakMode];
#pragma clang diagnostic pop
    }
    return contentSize;
}

- (void)setTwoLineText:(NSString *)text
{
    CGRect rect = [self frame];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    rect.size = [text sizeWithFont:[self font]
                 constrainedToSize:CGSizeMake(rect.size.width, 1000.f)
                     lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    if (rect.size.height < [self frame].size.height) {
        rect.size.height = [self frame].size.height;
    }
    [self setNumberOfLines:2];
    [self setLineBreakMode:NSLineBreakByTruncatingTail|NSLineBreakByTruncatingTail];
    [self setFrame:rect];
    [self setText:text];
    
}
+ (UILabel *)labelWithFrame:(CGRect)aF
{
    UILabel *labe  = [[UILabel alloc]initWithFrame:aF];
    [labe setBackgroundColor:[UIColor clearColor]];
    return labe;
}

+ (UILabel *)labelWithFrame:(CGRect)aF
                  textAlign:(NSTextAlignment)alig
                  textColor:(UIColor *)aTColor
                   textFont:(UIFont *)aFont
                    isBreak:(BOOL)aBreak
{
    UILabel *labe = [self labelWithFrame:aF];
    [labe setTextAlignment:alig];
    [labe setTextColor:aTColor];
    [labe setFont:aFont];
    if (aBreak) {
        [labe setNumberOfLines:0];
        [labe setLineBreakMode:NSLineBreakByWordWrapping];
    } else {
        [labe setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return labe;
}

- (void)initWithFont:(UIFont *)font andColor:(UIColor *)color
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextColor:color];
    [self setFont:font];
}

@end
@interface VTUILabel()
@property (nonatomic,assign) float animationDuration;

@property (nonatomic, assign) NSUInteger minSamples;
@property (nonatomic, assign) NSUInteger maxSamples;

@end

@implementation VTUILabel
@synthesize shadowBlur;
@synthesize innerShadowOffset;
@synthesize innerShadowColor;
@synthesize gradientColors;
@synthesize gradientStartPoint;
@synthesize gradientEndPoint;
@synthesize oversampling;
@synthesize minSamples;
@synthesize maxSamples;
@synthesize textInsets;

- (void)setDefaults
{
    gradientStartPoint = CGPointMake(0.5f, 0.0f);
    gradientEndPoint = CGPointMake(0.5f, 0.75f);
    minSamples = maxSamples = 1;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        minSamples = [UIScreen mainScreen].scale;
        maxSamples = 32;
    }
    oversampling = minSamples;
}
- (id)init
{
    if ((self = [super init]))
    {
        self.backgroundColor = nil;
        [self setDefaults];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = nil;
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setDefaults];
    }
    return self;
}
//

- (void)setInnerShadowOffset:(CGSize)offset
{
    if (!CGSizeEqualToSize(innerShadowOffset, offset))
    {
        innerShadowOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)setInnerShadowColor:(UIColor *)color
{
    if (innerShadowColor != color)
    {
        innerShadowColor = color;
        [self setNeedsDisplay];
    }
}

- (UIColor *)gradientStartColor
{
    return [gradientColors count]? [gradientColors objectAtIndex:0]: nil;
}

- (void)setGradientStartColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([gradientColors objectAtIndex:0] != color)
    {
        NSMutableArray *colors = [gradientColors mutableCopy];
        [colors replaceObjectAtIndex:0 withObject:color];
        self.gradientColors = colors;
    }
}

- (UIColor *)gradientEndColor
{
    return [gradientColors lastObject];
}

- (void)setGradientEndColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([gradientColors lastObject] != color)
    {
        NSMutableArray *colors = [gradientColors mutableCopy];
        [colors replaceObjectAtIndex:[colors count] - 1 withObject:color];
        self.gradientColors = colors;
    }
}

- (void)setGradientColors:(NSArray *)colors
{
    if (gradientColors != colors)
    {
        gradientColors = [colors copy];
        [self setNeedsDisplay];
    }
}

- (void)setOversampling:(NSUInteger)samples
{
    samples = MIN(maxSamples, MAX(minSamples, samples));
    if (oversampling != samples)
    {
		oversampling = samples;
        [self setNeedsDisplay];
    }
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(textInsets, insets))
    {
        textInsets = insets;
        [self setNeedsDisplay];
    }
}

- (void)getComponents:(CGFloat *)rgba forColor:(CGColorRef)color
{
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(color));
    const CGFloat *components = CGColorGetComponents(color);
    switch (model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            rgba[0] = components[0];
            rgba[1] = components[0];
            rgba[2] = components[0];
            rgba[3] = components[1];
            break;
        }
        case kCGColorSpaceModelRGB:
        {
            rgba[0] = components[0];
            rgba[1] = components[1];
            rgba[2] = components[2];
            rgba[3] = components[3];
            break;
        }
        default:
        {
            rgba[0] = 0.0f;
            rgba[1] = 0.0f;
            rgba[2] = 0.0f;
            rgba[3] = 1.0f;
            break;
        }
    }
}

- (UIColor *)color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self getComponents:aRGBA forColor:a];
    CGFloat bRGBA[4];
    [self getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]];
}

- (void)drawRect:(CGRect)rect
{
    //get drawing context
	if (oversampling > minSamples || (self.backgroundColor && ![self.backgroundColor isEqual:[UIColor clearColor]]))
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, oversampling);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply insets
    rect = self.bounds;
    rect.origin.x += textInsets.left;
    rect.origin.y += textInsets.top;
    rect.size.width -= (textInsets.left + textInsets.right);
    rect.size.height -= (textInsets.top + textInsets.bottom);
    
    //get label size
    CGRect textRect = rect;
    CGFloat fontSize = self.font.pointSize;
    if (self.adjustsFontSizeToFitWidth && self.numberOfLines == 1)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textRect.size = [self.text sizeWithFont:self.font
                                    minFontSize:self.minimumScaleFactor
                                 actualFontSize:&fontSize
                                       forWidth:rect.size.width
                                  lineBreakMode:self.lineBreakMode];
    }
    else
    {
        textRect.size = [self.text sizeWithFont:self.font
                              constrainedToSize:rect.size
                                  lineBreakMode:self.lineBreakMode];
    }
#pragma clang diagnostic pop
    //set font
    UIFont *font = [self.font fontWithSize:fontSize];
    
    //set color
    UIColor *highlightedColor = self.highlightedTextColor ?: self.textColor;
    UIColor *textColor = self.highlighted? highlightedColor: self.textColor;
    textColor = textColor ?: [UIColor clearColor];
    
    //set position
    switch (self.textAlignment)
    {
        case NSTextAlignmentCenter:
        {
            textRect.origin.x = rect.origin.x + (rect.size.width - textRect.size.width) / 2.0f;
            break;
        }
        case NSTextAlignmentRight:
        {
            textRect.origin.x = textRect.origin.x + rect.size.width - textRect.size.width;
            break;
        }
        default:
        {
            textRect.origin.x = rect.origin.x;
            break;
        }
    }
    switch (self.contentMode)
    {
        case UIViewContentModeTop:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        {
            textRect.origin.y = rect.origin.y;
            break;
        }
        case UIViewContentModeBottom:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            textRect.origin.y = rect.origin.y + rect.size.height - textRect.size.height;
            break;
        }
        default:
        {
            textRect.origin.y = rect.origin.y + (rect.size.height - textRect.size.height)/2.0f;
            break;
        }
    }
    
    BOOL hasShadow = self.shadowColor &&
    ![self.shadowColor isEqual:[UIColor clearColor]] &&
    (shadowBlur > 0.0f || !CGSizeEqualToSize(self.shadowOffset, CGSizeZero));
    
    BOOL hasInnerShadow = innerShadowColor &&
    ![self.innerShadowColor isEqual:[UIColor clearColor]] &&
    !CGSizeEqualToSize(innerShadowOffset, CGSizeZero);
    
    BOOL hasGradient = [gradientColors count] > 1;
    
    BOOL needsMask = hasInnerShadow || hasGradient;
    
    CGImageRef alphaMask = NULL;
    if (needsMask)
    {
        //draw mask
        CGContextSaveGState(context);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
#pragma clang diagnostic pop
        CGContextRestoreGState(context);
        
        // Create an image mask from what we've drawn so far
        alphaMask = CGBitmapContextCreateImage(context);
        
        //clear the context
        CGContextClearRect(context, textRect);
    }
    
    if (hasShadow)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //set up shadow
        CGContextSaveGState(context);
        CGFloat textAlpha = CGColorGetAlpha(textColor.CGColor);
        CGContextSetShadowWithColor(context, self.shadowOffset, shadowBlur, self.shadowColor.CGColor);
        [needsMask? [self.shadowColor colorWithAlphaComponent:textAlpha]: textColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
        CGContextRestoreGState(context);
    }
    else if (!needsMask)
    {
        //just draw the text
        [textColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    }
#pragma clang diagnostic pop
    if (needsMask)
    {
        //clip the context
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, rect, alphaMask);
        
        if (hasInnerShadow)
        {
            //fill inner shadow
            [innerShadowColor setFill];
            CGContextFillRect(context, textRect);
            
            //clip to unshadowed part
            CGContextTranslateCTM(context, innerShadowOffset.width, -innerShadowOffset.height);
            CGContextClipToMask(context, rect, alphaMask);
        }
        
        if (hasGradient)
        {
            //create array of pre-blended CGColors
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[gradientColors count]];
            for (UIColor *color in gradientColors)
            {
                UIColor *blended = [self color:color.CGColor blendedWithColor:textColor.CGColor];
                [colors addObject:(id)blended.CGColor];
            }
            
            //draw gradient
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -rect.size.height);
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, (CFArrayRef)colors, NULL);
            CGPoint startPoint = CGPointMake(textRect.origin.x + gradientStartPoint.x * textRect.size.width,
                                             textRect.origin.y + gradientStartPoint.y * textRect.size.height);
            CGPoint endPoint = CGPointMake(textRect.origin.x + gradientEndPoint.x * textRect.size.width,
                                           textRect.origin.y + gradientEndPoint.y * textRect.size.height);
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(gradient);
        }
        else
        {
            //fill text
            [textColor setFill];
            CGContextFillRect(context, textRect);
        }
        
        //end clipping
        CGContextRestoreGState(context);
        CGImageRelease(alphaMask);
    }
    
    if (oversampling)
    {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [image drawInRect:rect];
    }
}
@end

@implementation VTDrawLabel
- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (array) {
            _dataArray = [array copy];
        }
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)setText:(NSString *)atext
{
    [super setText:atext];
    [memText_ setString:self.text];
    [self setNeedsDisplay];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        memText_ = [[NSMutableString alloc]initWithCapacity:0];
    }
    return self;
}

- (void)setDataArray:(NSArray *)adataArray
{
    _dataArray = [adataArray copy];
    if (adataArray) {
        if (self.text) {
            [memText_ setString:self.text];
        }
        self.text = @"";
    } else {
        self.text = memText_;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if ([self.text length] > 0) {
        [super drawRect:rect];
        return;
    }
    if (self.dataArray.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat totalWidth = 0.0;
    CGFloat maxHeight = 0.0;
    for (VTDrawLabelData *data in self.dataArray) {
        totalWidth += data.size.width;
        maxHeight = MAX(maxHeight, data.size.height);
    }
    CGFloat offset = rect.size.width - totalWidth;
    
    CGFloat originx = 0.0;
    CGFloat originy = 0.0;
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:
            originx = 0;
            break;
        case NSTextAlignmentCenter:
            originx = offset / 2.0;
            break;
        case NSTextAlignmentRight:
            originx = offset;
            break;
        default:
            break;
    }
    CGFloat passedWidth = 0.0;
    for (VTDrawLabelData *data in self.dataArray) {
        originy = (rect.size.height - maxHeight)/2.0 + maxHeight - data.size.height;
        CGRect subFrame = (CGRect){{originx + passedWidth,originy},data.size};
        CGContextSetShadowWithColor(context, self.shadowOffset, 0.0, self.shadowColor.CGColor);
        [data.fontColor setFill];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [data.drawStr drawInRect:subFrame withFont:data.font];
#pragma clang diagnostic pop
        passedWidth += data.size.width;
    }
}

@end
@implementation VTDrawLabelData
+ (VTDrawLabelData *)labelDataWithFont:(UIFont *)aFont
                                 color:(UIColor *)aColor
                                  text:(NSString *)aStr
{
    VTDrawLabelData *data = [[VTDrawLabelData alloc]init];
    [data setFont:aFont];
    [data setFontColor:aColor];
    [data setDrawStr:aStr];
    return data;
}
- (void)resize
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _size = [self.drawStr sizeWithFont:self.font];
#pragma clang diagnostic pop
}
- (void)setDrawStr:(NSString *)aDrawStr
{
    _drawStr = [aDrawStr copy];
    [self resize];
}
- (void)setFont:(UIFont *)afont
{
    _font = afont;
    [self resize];
}
@end
