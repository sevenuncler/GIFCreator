//
//  SMStickManItem.m
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMStickManItem.h"
#import "SMHandItem.h"
#import "SMHeadItem.h"
#import "SMFeetItem.h"

@implementation SMStickManItem

- (CGRect)myFrame {
    CGFloat left    = 0;
    CGFloat top     = 0;
    CGFloat right   = 0;
    CGFloat botton  = 0;
    CGRect  rect;
    { // 头
        rect    = [self.head myFrame];
        left    = rect.origin.x;
        top     = rect.origin.y;
        right   = left + rect.size.width;
        botton  = top + rect.size.height;
//        return CGRectMake(left, top, right - left, botton - top);
    }
    { // 颈
        if(self.neck) {
            rect = [self.neck myFrame];
            if(rect.origin.x < left) {
                left = rect.origin.x;
            }
            if(rect.origin.y < top) {
                top = rect.origin.y;
            }
            if(rect.size.width+rect.origin.x> right) {
                right = rect.size.width + rect.origin.x;
            }
            if(rect.size.height + rect.origin.y > botton) {
                botton = rect.size.height + rect.origin.y;
            }
        }
        
    }
    { // 肩膀
        if(self.shoulder) {
            rect = [self.shoulder myFrame];
            if(rect.origin.x < left) {
            left = rect.origin.x;
            }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }
    { // 左手臂
        if(self.leftArm) {
        rect = [self.leftArm myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }
    { // 左小臂
        if(self.leftForearm) {
        rect = [self.leftForearm myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }
    { // 左小臂
        if(self.leftHand) {
        rect = [self.leftHand myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }{ // 右边小臂
        if(self.rightHand) {
        rect = [self.rightHand myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }{ // right forearm
        if(self.rightForearm) {
        rect = [self.rightForearm myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }{ // right arm
        if(self.rightArm) {
        rect = [self.rightArm myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
        }
    }{ // backbone
        rect = [self.backbone myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // leftThigh
        rect = [self.leftThigh myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // leftShins
        rect = [self.leftShins myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // 左小臂
        rect = [self.leftfeet myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // 左小臂
        rect = [self.rightThigh myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // 左小臂
        rect = [self.rightShins myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x> right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }{ // 左小臂
        rect = [self.rightFeet myFrame];
        if(rect.origin.x < left) {
            left = rect.origin.x;
        }
        if(rect.origin.y < top) {
            top = rect.origin.y;
        }
        if(rect.size.width+rect.origin.x > right) {
            right = rect.size.width + rect.origin.x;
        }
        if(rect.size.height + rect.origin.y > botton) {
            botton = rect.size.height + rect.origin.y;
        }
    }
    return CGRectMake(left, top, right - left, botton - top);
}

@end
