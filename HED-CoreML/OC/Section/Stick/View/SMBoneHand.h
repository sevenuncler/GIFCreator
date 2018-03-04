//
//  SMBoneHand.h
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBone.h"

@class SMHandItem;

@interface SMBoneHand : SMBone
@property(nonatomic, strong) SMBoneItem *handItem;
- (instancetype)initWithItem:(SMHandItem *)item;
@end
