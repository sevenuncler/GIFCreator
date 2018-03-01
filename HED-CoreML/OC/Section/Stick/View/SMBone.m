//
//  SMBone.m
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBone.h"

@interface SMBone ()

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat kneeRadium;
@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;

@property(nonatomic, strong) CAShapeLayer *beginKnee;
@property(nonatomic, strong) CAShapeLayer *bone;
@property(nonatomic, strong) CAShapeLayer *endKnee;

@end

@implementation SMBone

- (instancetype)initWithBegin:(CGPoint)beginPoint end:(CGPoint)endPoint {
    CGFloat x = MIN(beginPoint.x, endPoint.x);
    CGFloat y = MIN(beginPoint.y, beginPoint.y);
    CGFloat width  = fabs(beginPoint.x - endPoint.x);
    CGFloat height = fabs(beginPoint.y - endPoint.y);
    if(self = [super initWithFrame:CGRectMake(x, y, width, height)]) {
        self.beginPoint = beginPoint;
        self.endPoint   = endPoint;
        self.kneeRadium = 7;
        self.lineWidth  = 5;
        [self.layer addSublayer:self.bone];
        [self.layer addSublayer:self.beginKnee];
        [self.layer addSublayer:self.endKnee];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (CAShapeLayer *)beginKnee {
    if(!_beginKnee) {
        CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
        CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
        _beginKnee = [CAShapeLayer layer];
        _beginKnee.frame = CGRectMake(0, 0, self.kneeRadium*2, self.kneeRadium*2);
        _beginKnee.position = CGPointMake(self.beginPoint.x - x, self.beginPoint.y - y);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.kneeRadium, self.kneeRadium) radius:self.kneeRadium startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _beginKnee.path = path.CGPath;
        
        _beginKnee.fillColor = self.fillColor.CGColor;
        _beginKnee.strokeColor = self.strokeColor.CGColor;
    }
    return _beginKnee;
}

- (CAShapeLayer *)bone {
    if(!_bone) {
        CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
        CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
        _bone = [CAShapeLayer layer];
        _bone.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.beginPoint.x - x, self.beginPoint.y - y)];
        [path addLineToPoint:CGPointMake(self.endPoint.x - x, self.endPoint.y - y)];
        _bone.path = path.CGPath;
        _bone.lineWidth = self.lineWidth;
        _bone.strokeColor = self.strokeColor.CGColor;
    }
    return _bone;
}

- (CAShapeLayer *)endKnee {
    if(!_endKnee) {
        CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
        CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
        _endKnee = [CAShapeLayer layer];
        _endKnee.frame = CGRectMake(0, 0, self.kneeRadium*2, self.kneeRadium*2);
        _endKnee.position = CGPointMake(self.endPoint.x - x, self.endPoint.y - y);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.kneeRadium, self.kneeRadium) radius:self.kneeRadium startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _endKnee.path = path.CGPath;
        
        _endKnee.fillColor = self.fillColor.CGColor;
        _endKnee.strokeColor = self.strokeColor.CGColor;
    }
    return _endKnee;
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
