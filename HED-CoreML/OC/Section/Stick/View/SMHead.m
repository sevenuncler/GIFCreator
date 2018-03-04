//
//  SMHead.m
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMHead.h"
#import "SMHeadItem.h"


@implementation SMHead

- (instancetype)initWithItem:(SMHeadItem *)item {
    if(self = [super initWithPoint:item.center radium:item.radium]) {
        self.item = item;
    }
    return self;
}

@end
