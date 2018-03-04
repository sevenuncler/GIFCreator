//
//  SMBone.h
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMSticker.h"

@class SMKnee;
@class SMBoneItem;

@interface SMBone : SMSticker
@property(nonatomic, assign) CGPoint beginPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, strong) SMKnee  *beginKneeView;
@property(nonatomic, strong) SMKnee  *endKneeView;

- (instancetype)initWithBegin:(CGPoint)beginPoint end:(CGPoint)endPoint;
- (instancetype)initWithItem:(SMBoneItem *)item;
@end
