//
//  ContactTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ContactTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup:(ChatModel*) model {
    
    self.text.text = model.Name;
    
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.Img]];
    
}

@end
