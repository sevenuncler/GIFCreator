//
//  SMBoneItem.h
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SUStickerItem.h"

@interface SMBoneItem : SUStickerItem

@property(nonatomic, assign) CGPoint beginPoint;
@property(nonatomic, assign) CGPoint endPoint;

@property(nonatomic, assign) CGFloat kneeRadium;
@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;

- (CGRect)myFrame;

@end
