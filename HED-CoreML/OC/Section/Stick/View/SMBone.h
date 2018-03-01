//
//  SMBone.h
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMSticker.h"

@interface SMBone : SMSticker
@property(nonatomic, assign) CGPoint beginPoint;
@property(nonatomic, assign) CGPoint endPoint;

- (instancetype)initWithBegin:(CGPoint)beginPoint end:(CGPoint)endPoint;


@end
