//
//  SMBoneHand.m
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBoneHand.h"
#import "SMKnee.h"
#import "SMBoneItem.h"

@implementation SMBoneHand

- (instancetype)initWithItem:(SMBoneItem *)item {
    if(self = [super initWithItem:item]) {
        self.handItem = item;
        self.endKneeView.hidden = YES;
    }
    return self;
}

- (instancetype)initWithBegin:(CGPoint)beginPoint end:(CGPoint)endPoint {
    if(self = [super initWithBegin:beginPoint end:endPoint]) {
        self.endKneeView.hidden = YES;
    }
    return self;
}

@end
