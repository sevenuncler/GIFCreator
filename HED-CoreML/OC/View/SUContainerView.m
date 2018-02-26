//
//  SUContainerView.m
//  HED-CoreML
//
//  Created by He on 2018/2/26.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SUContainerView.h"

@implementation SUContainerView

- (void)drawRect:(CGRect)rect {
    CGFloat lengths[] = {3,3};
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextStrokePath(context);
}

@end
