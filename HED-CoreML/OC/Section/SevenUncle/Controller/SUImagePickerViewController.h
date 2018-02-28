//
//  SUImagePickerViewController.h
//  DreamOneByOne
//
//  Created by Fanghe on 2017/5/8.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completionHandler)(NSArray *);

@interface SUImagePickerViewController : UIViewController
@property   (weak, nonatomic) UIViewController  *parentVC;
@property   (copy, nonatomic) completionHandler completionHandler;
@end
