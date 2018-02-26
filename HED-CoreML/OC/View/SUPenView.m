//
//  SUPenView.m
//  iOSOpenPose
//
//  Created by He on 2018/2/6.
//  Copyright © 2018年 Sevenuncle. All rights reserved.
//

#import "SUPenView.h"

@implementation SUPenView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.lineWidth = 3;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextStrokePath(context);
}

@end
