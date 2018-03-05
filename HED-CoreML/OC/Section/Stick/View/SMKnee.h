//
//  SMKnee.h
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSticker.h"

@class SMKneeItem;
@protocol SMKneeDelegate;

@interface SMKnee : SMSticker
@property(nonatomic, strong) CAShapeLayer *kneeLayer;
@property(nonatomic, strong) SMKneeItem   *kneeItem;
@property(nonatomic, weak)   id<SMKneeDelegate> delegate;

- (instancetype)initWithPoint:(CGPoint)point radium:(CGFloat)radius;
- (instancetype)initWithItem:(SMKneeItem *)kneeItem;
@end

@protocol SMKneeDelegate <NSObject>

- (void)knee:(SMKnee *)knee moveToPoint:(CGPoint)center;

@end
