//
//  SMBone.m
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBone.h"
#import "SMKnee.h"
#import "SMBoneItem.h"

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

@property(nonatomic, assign) CGPoint beginPointInternal;
@property(nonatomic, assign) CGPoint endPointInternal;

@property(nonatomic, assign, getter=isNeedReDraw) BOOL needReDraw;

@end

@implementation SMBone

- (instancetype)initWithItem:(SMBoneItem *)item {
    CGFloat x = MIN(item.beginPoint.x, item.endPoint.x);
    CGFloat y = MIN(item.beginPoint.y, item.endPoint.y);
    CGFloat width  = fabs(item.beginPoint.x - item.endPoint.x);
    CGFloat height = fabs(item.beginPoint.y - item.endPoint.y);
    
    if(self = [self initWithFrame:CGRectMake(x, y, width, height)]) {
        _fillColor   = item.fillColor;
        _strokeColor = item.strokeColor;
        _beginPoint  = item.beginPoint;
        _endPoint    = item.endPoint;
        _lineWidth   = item.lineWidth;
        _kneeRadium  = item.kneeRadium;
        _needReDraw = YES;
        
        [self.layer addSublayer:self.bone];
        [self addSubview:self.beginKneeView];
        [self addSubview:self.endKneeView];
    }
    return self;
}

- (instancetype)initWithBegin:(CGPoint)beginPoint end:(CGPoint)endPoint {
    CGFloat x = MIN(beginPoint.x, endPoint.x);
    CGFloat y = MIN(beginPoint.y, endPoint.y);
    CGFloat width  = fabs(beginPoint.x - endPoint.x);
    CGFloat height = fabs(beginPoint.y - endPoint.y);
    if(self = [super initWithFrame:CGRectMake(x, y, width, height)]) {
        _beginPoint = beginPoint;
        _endPoint   = endPoint;
        _kneeRadium = 8;
        _lineWidth  = 10;
        _needReDraw = YES;

        [self.layer addSublayer:self.bone];
        [self addSubview:self.beginKneeView];
        [self addSubview:self.endKneeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
    CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
    CGFloat width  = fabs(self.beginPoint.x - self.endPoint.x);
    CGFloat height = fabs(self.beginPoint.y - self.endPoint.y);
    
    self.frame = CGRectMake(x, y, width, height);
    self.beginKneeView.center = self.beginPointInternal;
    self.endKneeView.center   = self.endPointInternal;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    CGPoint covertPoint  = [self convertPoint:point toView:self.beginKneeView];
    CGPoint covertPoint2 = [self convertPoint:point toView:self.endKneeView];
    if(view == nil) {
        if([self.beginKneeView pointInside:covertPoint withEvent:event]){
            view = self.beginKneeView;
        }else if([self.endKneeView pointInside:covertPoint2 withEvent:event]) {
            view = self.endKneeView;
        }
    }
    return view;
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
    if(!_bone){
        _bone = [CAShapeLayer layer];
    }
       
    if(self.isNeedReDraw) {
        _bone.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:self.beginPointInternal];
        [path addLineToPoint:self.endPointInternal];
        _bone.path = path.CGPath;
        _bone.lineWidth = self.lineWidth;
        _bone.strokeColor = self.strokeColor.CGColor;
        _needReDraw = NO;
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

- (SMKnee *)beginKneeView {
    if(!_beginKneeView) {
        _beginKneeView = [[SMKnee alloc] initWithPoint:self.beginPointInternal radium:self.kneeRadium];
    }
    return _beginKneeView;
}

- (CGPoint)beginPointInternal {
    CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
    CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
    _beginPointInternal = CGPointMake(self.beginPoint.x - x, self.beginPoint.y - y);
    return _beginPointInternal;
}

- (SMKnee *)endKneeView {
    if(!_endKneeView) {
        _endKneeView = [[SMKnee alloc] initWithPoint:self.endPointInternal radium:self.kneeRadium];
    }
    return _endKneeView;
}

- (CGPoint)endPointInternal {
    CGFloat x = MIN(self.beginPoint.x, self.endPoint.x);
    CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
    _endPointInternal = CGPointMake(self.endPoint.x - x, self.endPoint.y - y);
    return _endPointInternal;
}

- (void)setBeginPoint:(CGPoint)beginPoint {
    if(!CGPointEqualToPoint(beginPoint, _beginPoint)) {
        _beginPoint = beginPoint;
        self.needReDraw = YES;
        [self.bone setNeedsDisplay];
    }
}

- (void)setEndPoint:(CGPoint)endPoint {
    if(!CGPointEqualToPoint(endPoint, _endPoint)) {
        _endPoint = endPoint;
        self.needReDraw = YES;
        [self.bone setNeedsDisplay];
    }
}



@end
