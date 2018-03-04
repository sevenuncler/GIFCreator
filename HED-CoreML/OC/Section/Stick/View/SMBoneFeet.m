
//
//  SMBoneFeet.m
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBoneFeet.h"
#import "SMFeetItem.h"
#import "SMKnee.h"

@implementation SMBoneFeet

- (instancetype)initWithItem:(SMFeetItem *)item {
    if(self = [super initWithItem:item]) {
        self.feetItem = item;
        self.endKneeView.hidden = YES;
    }
    return self;
}

@end
