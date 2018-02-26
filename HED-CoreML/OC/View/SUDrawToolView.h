//
//  SUDrawToolView.h
//  iOSOpenPose
//
//  Created by He on 2018/2/5.
//  Copyright © 2018年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_SIZE 20
@interface SUDrawToolView : UIView
@property(nonatomic, strong) UIButton *penButton;
@property(nonatomic, strong) UIButton *signPenButton;
@property(nonatomic, strong) UIButton *eraserButton;
@property(nonatomic, strong) UIButton *saveButton;
@end
