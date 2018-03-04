//
//  SMStickMan.m
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMStickMan.h"
#import "SMStickManItem.h"
#import "SMHead.h"
#import "SMBone.h"
#import "SMBoneHand.h"
#import "SMBoneFeet.h"
#import "SMStickManItem.h"

@interface SMStickMan()
@property(nonatomic, assign) CGRect xFrame;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat top;
@end

@implementation SMStickMan

- (instancetype)initWithItem:(SMStickManItem *)item {
    if(self = [super initWithFrame:[item myFrame]]) {
        self.stickManItem = item;
        [self addSubview:self.head];
        [self addSubview:self.neck];
        [self addSubview:self.shoulder];
        
        [self addSubview:self.leftArm];
        [self addSubview:self.leftForearm];
        [self addSubview:self.leftHand];
        
        [self addSubview:self.rightArm];
        [self addSubview:self.rightForearm];
        [self addSubview:self.rightHand];
        
        [self addSubview:self.backbone];
        
        [self addSubview:self.leftThigh];
        [self addSubview:self.leftShins];
        [self addSubview:self.leftfeet];
        
        [self addSubview:self.rightThigh];
        [self addSubview:self.rightShins];
        [self addSubview:self.rightFeet];
        
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CGRect)xFrame {
    if(CGRectEqualToRect(_xFrame, CGRectZero)) {
        _xFrame = [self.stickManItem myFrame];
    }
    return _xFrame;
}

- (SMHead *)head {
    if(!_head) {
        _head = [[SMHead alloc] initWithItem:self.stickManItem.head];
    }
    return _head;
}

- (SMBone *)neck {
    if(!_neck) {
        _neck = [[SMBone alloc] initWithItem:self.stickManItem.neck];
    }
    return _neck;
}

- (SMBone *)shoulder {
    if(!_shoulder) {
        _shoulder = [[SMBone alloc] initWithItem:self.stickManItem.shoulder];
    }
    return _shoulder;
}

- (SMBone *)leftArm {
    if(!_leftArm) {
        _leftArm = [[SMBone alloc] initWithItem:self.stickManItem.leftArm];;
    }
    return _leftArm;
}

- (SMBone *)leftForearm {
    if(!_leftForearm) {
        _leftForearm = [[SMBone alloc] initWithItem:self.stickManItem.leftForearm];
    }
    return _leftForearm;
}

- (SMBoneHand *)leftHand {
    if(!_leftHand) {
        _leftHand = [[SMBoneHand alloc] initWithItem:self.stickManItem.leftHand];
    }
    return _leftHand;
}

- (SMBone *)rightArm {
    if(!_rightArm) {
        _rightArm = [[SMBone alloc] initWithItem:self.stickManItem.rightArm];
    }
    return _rightArm;
}

- (SMBone *)rightForearm {
    if(!_rightForearm) {
        _rightForearm = [[SMBone alloc] initWithItem:self.stickManItem.rightForearm];
    }
    return _rightForearm;
}

- (SMBoneHand *)rightHand {
    if(!_rightHand) {
        _rightHand = [[SMBoneHand alloc] initWithItem:self.stickManItem.rightHand];
    }
    return _rightHand;
}

- (SMBone *)backbone {
    if(!_backbone) {
        _backbone = [[SMBone alloc] initWithItem:self.stickManItem.backbone];
    }
    return _backbone;
}


- (SMBone *)leftThigh {
    if(!_leftThigh) {
        _leftThigh = [[SMBone alloc] initWithItem:self.stickManItem.leftThigh];
    }
    return _leftThigh;
}

- (SMBone *)leftShins {
    if(!_leftShins) {
        _leftShins = [[SMBone  alloc] initWithItem:self.stickManItem.leftShins];
    }
    return _leftShins;
}

- (SMBoneFeet *)leftfeet {
    if(!_leftfeet) {
        _leftfeet = [[SMBoneFeet alloc] initWithItem:self.stickManItem.leftfeet];
    }
    return _leftfeet;
}

- (SMBone *)rightThigh {
    if(!_rightThigh) {
        _rightThigh = [[SMBone alloc] initWithItem:self.stickManItem.rightThigh];
    }
    return _rightThigh;
}

- (SMBone *)rightShins {
    if(!_rightShins) {
        _rightShins = [[SMBone  alloc] initWithItem:self.stickManItem.rightShins];
    }
    return _rightShins;
}

- (SMBoneFeet *)rightFeet {
    if(!_rightFeet) {
        _rightFeet = [[SMBoneFeet alloc] initWithItem:self.stickManItem.rightFeet];
    }
    return _rightFeet;
}



- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)top {
    return self.frame.origin.y;
}


@end
