//
//  PersonListTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "PersonListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PersonListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup:(PersonBean*) bean {
    
    self.text.text = bean.NickName;
    
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:bean.HeadPortrait]];
    
}

@end
