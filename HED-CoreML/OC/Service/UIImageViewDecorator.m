//
//  UIImageViewDecorator.m
//  HED-CoreML
//
//  Created by He on 2018/2/26.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "UIImageViewDecorator.h"
#import "UIView+Layout.h"

@implementation UIImageViewDecorator

- (instancetype)initWithImageView:(UIImageView *)imageView {
    if(self = [super initWithFrame:imageView.bounds]) {
        self.imageView = imageView;
        [self addSubview:imageView];
        [self addSubview:self.removeButton];
        [self addSubview:self.scaleButton];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
    
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineDash(context, 3, options, 2);
    CGContextSetLineWidth(context, 7);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.removeButton.size = CGSizeMake(20, 20);
    self.removeButton.center = CGPointMake(-5, -5);
    
    self.scaleButton.size = CGSizeMake(20, 20);
    self.scaleButton.center = CGPointMake(self.size.width+5, self.size.height+5);
    
    self.imageView.size = self.size;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if(!result) {
        CGPoint scalePoint = [self convertPoint:point toView:self.scaleButton];
        CGPoint removePoint = [self convertPoint:point toView:self.removeButton];

        if([self.scaleButton pointInside:scalePoint withEvent:event]) {
            result = self.scaleButton;
        }else if([self.removeButton pointInside:removePoint withEvent:event]) {
            result = self.removeButton;
        }
    }
    return result;
}

- (UIButton *)removeButton {
    if(!_removeButton) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeButton.backgroundColor = [UIColor orangeColor];
    }
    return  _removeButton;
}

- (UIButton *)scaleButton {
    if(!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scaleButton.backgroundColor = [UIColor orangeColor];
    }
    return _scaleButton;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}


@end
