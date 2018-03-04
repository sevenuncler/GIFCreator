//
//  SMHead.h
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMKnee.h"

@class SMHeadItem;

@interface SMHead : SMKnee

@property(nonatomic, strong) SMHeadItem *item;

- (instancetype)initWithItem:(SMHeadItem *)item;

@end
