//
//  SMKnee.h
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSticker.h"

@interface SMKnee : SMSticker

@property(nonatomic, strong) CAShapeLayer *kneeLayer;

- (instancetype)initWithPoint:(CGPoint)point radium:(CGFloat)radius;

@end
