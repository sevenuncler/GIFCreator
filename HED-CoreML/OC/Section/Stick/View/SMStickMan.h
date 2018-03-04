//
//  SMStickMan.h
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMSticker.h"


@class SMHead;
@class SMBone;
@class SMBoneHand;
@class SMBoneFeet;
@class SMStickManItem;

@interface SMStickMan : SMSticker
@property(nonatomic, strong) SMHead *head; // 头
@property(nonatomic, strong) SMBone *neck; // 颈
@property(nonatomic, strong) SMBone *shoulder; // 肩膀

@property(nonatomic, strong) SMBone *leftArm; // 大臂
@property(nonatomic, strong) SMBone *leftForearm;  // 小臂
@property(nonatomic, strong) SMBoneHand *leftHand; // 手掌
@property(nonatomic, strong) SMBone *rightArm; // 大臂
@property(nonatomic, strong) SMBone *rightForearm;  // 小臂
@property(nonatomic, strong) SMBoneHand *rightHand; // 手掌

@property(nonatomic, strong) SMBone *backbone; // 脊椎

@property(nonatomic, strong) SMBone *leftShins; // 小腿
@property(nonatomic, strong) SMBone *leftThigh; // 大腿
@property(nonatomic, strong) SMBoneFeet *leftfeet;  // 脚
@property(nonatomic, strong) SMBone *rightShins; // 小腿
@property(nonatomic, strong) SMBone *rightThigh; // 大腿
@property(nonatomic, strong) SMBoneFeet *rightFeet;  // 脚

@property(nonatomic, strong) SMStickManItem *stickManItem;

- (instancetype)initWithItem:(SMStickManItem *)item;

@end
