//
//  SMStickManItem.h
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SUStickerItem.h"

@class SMBoneItem;
@class SMHandItem;
@class SMHeadItem;
@class SMFeetItem;


@interface SMStickManItem : SUStickerItem

@property(nonatomic, strong) SMHeadItem *head; // 头
@property(nonatomic, strong) SMBoneItem *neck; // 颈
@property(nonatomic, strong) SMBoneItem *shoulder; // 肩膀

@property(nonatomic, strong) SMBoneItem *leftArm; // 大臂
@property(nonatomic, strong) SMBoneItem *leftForearm;  // 小臂
@property(nonatomic, strong) SMHandItem *leftHand; // 手掌
@property(nonatomic, strong) SMBoneItem *rightArm; // 大臂
@property(nonatomic, strong) SMBoneItem *rightForearm;  // 小臂
@property(nonatomic, strong) SMHandItem *rightHand; // 手掌

@property(nonatomic, strong) SMBoneItem *backbone; // 脊椎

@property(nonatomic, strong) SMBoneItem *leftShins; // 小腿
@property(nonatomic, strong) SMBoneItem *leftThigh; // 大腿
@property(nonatomic, strong) SMFeetItem *leftfeet;  // 脚
@property(nonatomic, strong) SMBoneItem *rightShins; // 小腿
@property(nonatomic, strong) SMBoneItem *rightThigh; // 大腿
@property(nonatomic, strong) SMFeetItem *rightFeet;  // 脚

@end
