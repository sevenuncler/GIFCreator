//
//  SUTopBarView.h
//  DreamOneByOne
//
//  Created by He on 2017/6/13.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUTopBarViewDelegate <NSObject>



@end

@interface SUTopBarView : UIView

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *centerBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

+ (instancetype)topBar;
- (IBAction)onLeftClicked:(id)sender;
- (IBAction)onCenterClicked:(id)sender;
- (IBAction)onRightClicked:(id)sender;

@end
