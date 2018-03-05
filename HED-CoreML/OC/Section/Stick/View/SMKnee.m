//
//  SMKnee.m
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMKnee.h"
#import "SMKneeItem.h"

@interface SMKnee ()


@property(nonatomic, assign) CGFloat kneeRadium;
@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;


@end

@implementation SMKnee

- (instancetype)initWithPoint:(CGPoint)point radium:(CGFloat)radius {
    CGRect frame = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
    if(self = [super initWithFrame:frame]) {
        SMKneeItem *kneeItem = [SMKneeItem new];
        kneeItem.center = point;
        kneeItem.kneeRadium = radius;
        kneeItem.fillColor  = self.fillColor;
        kneeItem.strokeColor = self.strokeColor;
        self.kneeItem = kneeItem;
        [self.layer addSublayer:self.kneeLayer];
        [self setUpGestureRecoginzer];
    }
    return self;
}

- (instancetype)initWithItem:(SMKneeItem *)kneeItem {
    if(self = [self initWithPoint:kneeItem.center radium:kneeItem.kneeRadium]){
        self.kneeItem = kneeItem;
        [self.layer addSublayer:self.kneeLayer];
    }
    return self;
}

- (void)setUpGestureRecoginzer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
    [self addGestureRecognizer:pan];
    
}

- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self];
//    CGPoint center = CGPointMake(self.center.x + offset.x, self.center.y +offset.y );
    [sender setTranslation:CGPointZero inView:self];
    if(self.delegate && [self.delegate respondsToSelector:@selector(knee:moveToPoint:)]) {
        [self.delegate knee:self moveToPoint:offset];
    }
}

- (CAShapeLayer *)kneeLayer {
    if(!_kneeLayer) {
        
        _kneeLayer = [CAShapeLayer layer];
        CGFloat r = self.kneeItem.kneeRadium;
        _kneeLayer.frame = CGRectMake(0, 0, r*2, r*2);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(r, r) radius:r startAngle:0 endAngle:M_PI*2 clockwise:YES];
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
