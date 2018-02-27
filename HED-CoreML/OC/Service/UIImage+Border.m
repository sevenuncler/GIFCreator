//
//  UIImage+Border.m
//  HED-CoreML
//
//  Created by He on 2018/2/26.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "UIImage+Border.h"

@implementation UIImage (Border)

- (UIImage *)imageWithDashBorder {
    UIImage *result = nil;
    CGFloat width  = self.size.width;
    CGFloat height = self.size.height;
    
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [path setLineWidth:7];
    CGFloat options[] = {5,10};
    [path setLineDash:options count:2 phase:3];
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
