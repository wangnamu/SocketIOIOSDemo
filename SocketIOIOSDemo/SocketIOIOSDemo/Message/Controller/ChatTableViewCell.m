//
//  ChatTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "DateUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup:(ChatBean *)bean {
    
    self.name.text = bean.Name;
    self.body.text = bean.Body;
    self.time.text = [DateUtils dateToShort:bean.Time];
    
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:bean.Img]];
}

@end
