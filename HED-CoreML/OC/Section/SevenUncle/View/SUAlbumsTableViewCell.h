//
//  SUAlbumsTableViewCell.h
//  DreamOneByOne
//
//  Created by He on 2017/6/18.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUAlbumsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;

+ (instancetype)loadCell;

@end
