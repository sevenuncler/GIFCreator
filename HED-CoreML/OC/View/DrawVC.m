//
//  DrawVC.m
//  iOSOpenPose
//
//  Created by He on 2018/2/4.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import "DrawVC.h"
#import <CoreFoundation/CoreFoundation.h>
#import "SUDrawView.h"

@interface DrawVC ()

@property(nonatomic, strong) SUDrawView *canvas;
@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@property(nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.canvas];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
    [self.canvas addGestureRecognizer:panGR];
}

- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.canvas];
    UIGestureRecognizerState state = sender.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:point];
            Shape *shape = [Shape new];
            shape.path = [path copy];
            shape.property = [ShapeProperty new];
            shape.property.color = [UIColor colorWithRed:arc4random()%9/9.f green:arc4random()%9/9.f blue:arc4random()%9/9.f alpha:1];
            shape.property.lineWidth = arc4random()%20;
            [self.canvas.shapes addObject:shape];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            Shape *shape = self.canvas.shapes.lastObject;
            [shape.path addLineToPoint:point];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            Shape *shape = self.canvas.shapes.lastObject;
            [shape.path addLineToPoint:point];
            break;
        }
        default:
            break;
    }
    [self.canvas setNeedsDisplay];
}

- (SUDrawView *)canvas {
    if(!_canvas) {
        _canvas = [[SUDrawView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _canvas.backgroundColor = [UIColor grayColor];
        _canvas.center = CGPointMake(self.view.frame.size.width/2.f, self.view.frame.size.height/2.f);
    }
    return _canvas;
}

- (CAShapeLayer *)shapeLayer {
    if(!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _shapeLayer.frame = self.canvas.bounds;
        _shapeLayer.lineWidth = 5;
        _shapeLayer.borderColor = [UIColor greenColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.backgroundColor = [UIColor blueColor].CGColor;
//        _shapeLayer.position = self.canvas.center;
    }
    return _shapeLayer;
}

- (UIBezierPath *)path {
    if(!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

@end
