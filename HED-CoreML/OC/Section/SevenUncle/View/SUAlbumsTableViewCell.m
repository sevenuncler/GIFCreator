//
//  SUAlbumsTableViewCell.m
//  DreamOneByOne
//
//  Created by He on 2017/6/18.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import "SUAlbumsTableViewCell.h"

@implementation SUAlbumsTableViewCell

+ (instancetype)loadCell {
    return [[NSBundle mainBundle] loadNibNamed:@"SUAlbumsTableViewCell" owner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
