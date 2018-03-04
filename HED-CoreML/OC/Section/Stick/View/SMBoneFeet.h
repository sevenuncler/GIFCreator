//
//  SMBoneFeet.h
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBone.h"

@class SMFeetItem;

@interface SMBoneFeet : SMBone
@property(nonatomic, strong) SMFeetItem *feetItem;
- (instancetype)initWithItem:(SMFeetItem *)item;
@end
