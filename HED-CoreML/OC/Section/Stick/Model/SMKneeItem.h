//
//  SMKneeItem.h
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 wuxia. All rights reserved.
//

#import "SUStickerItem.h"

@interface SMKneeItem : SUStickerItem

@property(nonatomic, assign) CGFloat kneeRadium;
@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;
@property(nonatomic, assign) CGPoint center;

@end
