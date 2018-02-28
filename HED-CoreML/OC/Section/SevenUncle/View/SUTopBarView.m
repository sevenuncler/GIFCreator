//
//  SUTopBarView.m
//  DreamOneByOne
//
//  Created by He on 2017/6/13.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import "SUTopBarView.h"

@implementation SUTopBarView

+ (instancetype)topBar {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SUTopBarView class]) owner:self options:nil][0];
}

- (IBAction)onLeftClicked:(id)sender {
}

- (IBAction)onCenterClicked:(id)sender {
}

- (IBAction)onRightClicked:(id)sender {
}

@end
