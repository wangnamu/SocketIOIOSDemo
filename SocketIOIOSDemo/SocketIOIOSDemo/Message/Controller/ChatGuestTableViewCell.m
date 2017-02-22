//
//  ChatGuestTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatGuestTableViewCell.h"
#import "DateUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITableView+FDTemplateLayoutCell.h"

static const CGFloat contentPadding = 8.0f;
@implementation ChatGuestTableViewCell

@synthesize headPortrait,name,content,topTime,itemMsg,progress;
@synthesize cellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        topTime = [[UILabel alloc] init];
        topTime.textAlignment = NSTextAlignmentCenter;
        topTime.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:topTime];
        
        name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:name];
        
        content = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(contentPadding,contentPadding,contentPadding,contentPadding)];
        content.font = [UIFont systemFontOfSize:16.0f];
        content.textColor = [UIColor whiteColor];
        content.numberOfLines = 0;
        [self.contentView addSubview:content];
        
        headPortrait = [[UIImageView alloc] init];
        [self.contentView addSubview:headPortrait];
        
        progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:progress];
        
        itemMsg = [[UILabel alloc] init];
        itemMsg.font = [UIFont systemFontOfSize:10.0f];
        itemMsg.textColor = [UIColor redColor];
        [self.contentView addSubview:itemMsg];
        
    }
    return self;
}

- (void)setup:(MessageBean*)bean {
    
    topTime.text = [DateUtils stringFromLong:bean.Time];
    content.text = bean.Body;
    name.text = bean.NickName;
    itemMsg.text = @"2017-01-01 下午2:20 发送失败";
    
    CGFloat padding_H = 16.0f;
    CGFloat padding_B = 16.0f;
    CGFloat progressW = 24.0f;
    CGFloat nameW = 80.0f;
    CGFloat marginBottom = 4.0f;
    CGFloat contentMargin = 10.0f;
    
    topTime.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    
    CGFloat headPortraitW = 40.0f;
    CGFloat headPortraitY = CGRectGetMaxY(topTime.frame);
    CGFloat headPortraitX = padding_H;
    headPortrait.frame = CGRectMake(headPortraitX, headPortraitY, headPortraitW, headPortraitW);
    
    name.textAlignment = NSTextAlignmentLeft;
    
    CGFloat nameY = CGRectGetMaxY(topTime.frame);
    CGFloat nameX = padding_H + headPortraitW + contentMargin;
    
    name.frame = CGRectMake(nameX, nameY, nameW, 12.0f);
    
    
    CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH - 2*padding_H - headPortraitW - progressW - 2*contentMargin - 2*contentPadding, MAXFLOAT);
    CGSize textRealSize = [bean.Body boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    
    CGSize contentSize = CGSizeMake(textRealSize.width + 2*contentPadding, textRealSize.height + 2*contentPadding);
    
    CGFloat contentX = padding_H + headPortraitW + contentMargin;
    CGFloat contentY = CGRectGetMaxY(name.frame) + marginBottom;
    content.frame = (CGRect){{contentX,contentY},contentSize};
    
    CGFloat progressX = contentX + contentSize.width + contentMargin;
    CGFloat progressY = CGRectGetMidY(content.frame) - progressW/2;
    progress.frame = CGRectMake(progressX, progressY, progressW, progressW);
    [progress startAnimating];
    
    itemMsg.textAlignment = NSTextAlignmentLeft;
    CGFloat itemMsgX = contentX;
    CGFloat itemMsgY = CGRectGetMaxY(content.frame) + marginBottom;
    itemMsg.frame = CGRectMake(itemMsgX, itemMsgY, contentSize.width, 10.0f);
    
    
    CGFloat iconMaxY = itemMsg.isHidden ? CGRectGetMaxY(headPortrait.frame) : CGRectGetMaxY(itemMsg.frame);
    CGFloat textMaxY = CGRectGetMaxY(content.frame);
    cellHeight = MAX(iconMaxY, textMaxY) + padding_B;
    
    headPortrait.layer.cornerRadius = headPortraitW / 2;
    headPortrait.layer.masksToBounds = YES;
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:bean.HeadPortrait] placeholderImage:nil];
    
    content.backgroundColor = [UIColor blueColor];
    content.layer.cornerRadius = 8.0f;
    content.layer.masksToBounds = YES;
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(SCREEN_WIDTH, cellHeight);
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
