//
//  UITableView+VT.m
//  VTCore
//
//  Created by 黄莉萍 on 14-4-4.
//  Copyright (c) 2014年 Raxtone. All rights reserved.
//

#import "UITableView+VT.h"

@implementation UITableView (VT)
- (void)initStyle
{
    [self setBackgroundColor:UIColorFromRGB(0xe6f3e6)];
    [self setSeparatorColor:[UIColor clearColor]];
    [self setBackgroundView:nil];
}
@end
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        CGFloat cornerRadius = 4.f;
//        cell.backgroundColor = UIColor.clearColor;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 5, 0);
//        BOOL addLine = NO;
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//        } else if (indexPath.row == 0) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            addLine = YES;
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//        } else {
//            CGPathAddRect(pathRef, nil, bounds);
//            addLine = YES;
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //set the border color
//        layer.strokeColor = [UIColor lightGrayColor].CGColor;
//        //set the border width
//        layer.lineWidth = 1;
//        layer.fillColor = vtColor255(245, 246, 246).CGColor;
//        
//        
//        if (addLine == YES) {
//            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            [layer addSublayer:lineLayer];
//        }
//        
//        UIView *bg = [[UIView alloc] initWithFrame:bounds];
//        [bg.layer insertSublayer:layer atIndex:0];
//        bg.backgroundColor = UIColor.clearColor;
//        cell.backgroundView = bg;
//    }
//}
