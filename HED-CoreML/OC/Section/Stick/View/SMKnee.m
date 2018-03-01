//
//  SMKnee.m
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMKnee.h"

@interface SMKnee ()

@property(nonatomic, strong) CAShapeLayer *kneeLayer;

@property(nonatomic, assign) CGFloat kneeRadium;
@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;


@end

@implementation SMKnee


- (instancetype)initWithPoint:(CGPoint)point radium:(CGFloat)radius {
    CGRect frame = CGRectMake(point.x - radius, point.y - radius, radius, radius);
    if(self = [super initWithFrame:frame]) {
        self.kneeRadium = radius;
        [self.layer addSublayer:self.kneeLayer];
    }
    return self;
}


- (CAShapeLayer *)kneeLayer {
    if(!_kneeLayer) {
        
        _kneeLayer = [CAShapeLayer layer];
        _kneeLayer.frame = CGRectMake(0, 0, self.kneeRadium*2, self.kneeRadium*2);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.kneeRadium, self.kneeRadium) radius:self.kneeRadium startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _kneeLayer.path = path.CGPath;
        
        _kneeLayer.fillColor = self.fillColor.CGColor;
        _kneeLayer.strokeColor = self.strokeColor.CGColor;
    }
    return _kneeLayer;
}

- (UIColor *)fillColor {
    if(!_fillColor) {
        _fillColor = [UIColor colorWithRed:arc4random()%9/9.f green:arc4random()%9/9.f blue:arc4random()%9/9.f alpha:1];
    }
    return _fillColor;
}

- (UIColor *)strokeColor {
    if(!_strokeColor) {
        _strokeColor = [UIColor colorWithRed:arc4random()%9/9.f green:arc4random()%9/9.f blue:arc4random()%9/9.f alpha:1];
    }
    return _strokeColor;
}

@end
