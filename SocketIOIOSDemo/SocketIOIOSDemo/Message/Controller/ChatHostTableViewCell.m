//
//  ChatHostTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatHostTableViewCell.h"
#import "DateUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "UITableView+FDTemplateLayoutCell.h"

@implementation ChatHostTableViewCell
@synthesize headPortrait,name,topTime,itemMsg,progress;
@synthesize cellHeight;
@synthesize content,contentImage;

static CGFloat const contentPadding = 8.0f;
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
    
        headPortrait = [[UIImageView alloc] init];
        [self.contentView addSubview:headPortrait];
        
        progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        progress.hidesWhenStopped = YES;
        [self.contentView addSubview:progress];
        
        itemMsg = [[UILabel alloc] init];
        itemMsg.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:itemMsg];
        
        
        content = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(contentPadding,contentPadding,contentPadding,contentPadding)];
        content.font = [UIFont systemFontOfSize:16.0f];
        content.numberOfLines = 0;
        [self.contentView addSubview:content];
        [content setHidden:YES];
        
        contentImage = [[UIImageView alloc] init];
        [self.contentView addSubview:contentImage];
        [contentImage setHidden:YES];

    }
    return self;
}

- (void)setup:(MessageBean*)bean {
    
    topTime.text = [DateUtils stringFromLong:bean.Time];
    name.text = bean.NickName;
   
    CGFloat padding_H = 16.0f;
    CGFloat padding_B = 16.0f;
    CGFloat progressW = 24.0f;
    CGFloat nameW = 80.0f;
    CGFloat marginBottom = 4.0f;
    CGFloat contentMargin = 10.0f;
  
    topTime.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    
    CGFloat headPortraitW = 40.0f;
    CGFloat headPortraitY = CGRectGetMaxY(topTime.frame);
    CGFloat headPortraitX = SCREEN_WIDTH - headPortraitW - padding_H;
    headPortrait.frame = CGRectMake(headPortraitX, headPortraitY, headPortraitW, headPortraitW);
    
    name.textAlignment = NSTextAlignmentRight;
   
    CGFloat nameY = CGRectGetMaxY(topTime.frame);
    CGFloat nameX = SCREEN_WIDTH - headPortraitW - padding_H - nameW - contentMargin;

    name.frame = CGRectMake(nameX, nameY, nameW, 12.0f);
    
    CGRect contentFrame;
    CGFloat contentX,contentY;
    
    if ([bean.MessageType isEqualToString:MessageTypeText]) {
        
        content.text = bean.Body;
        [content setHidden:NO];
        
        CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH - 2*padding_H - headPortraitW - progressW - 2*contentMargin - 2*contentPadding, MAXFLOAT);
        CGSize textRealSize = [bean.Body boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
        
        CGSize contentSize = CGSizeMake(textRealSize.width + 2*contentPadding, textRealSize.height + 2*contentPadding);
        
        contentX = SCREEN_WIDTH - padding_H - headPortraitW - contentMargin - contentSize.width;
        contentY = CGRectGetMaxY(name.frame) + marginBottom;
        contentFrame = (CGRect){{contentX,contentY},contentSize};
        content.frame = contentFrame;
        
        content.backgroundColor = COLOR_FROM_RGB(0x81cbd9);
        content.layer.cornerRadius = 8.0f;
        content.layer.masksToBounds = YES;
        
    }
    else if ([bean.MessageType isEqualToString:MessageTypeImage]) {
        
        [contentImage setHidden:NO];
        
        [contentImage sd_setShowActivityIndicatorView:YES];
        [contentImage sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [contentImage sd_setImageWithURL:[NSURL URLWithString:bean.Thumbnail]];
        
        CGFloat imgMaxheight = 150.0f;
        
        contentX = SCREEN_WIDTH - padding_H - headPortraitW - contentMargin - imgMaxheight;
        contentY = CGRectGetMaxY(name.frame) + marginBottom;
        contentFrame = (CGRect){{contentX,contentY},{imgMaxheight, imgMaxheight}};
        contentImage.frame = contentFrame;
        
        contentImage.layer.cornerRadius = 8.0f;
        contentImage.layer.masksToBounds = YES;
    }
    else {
        
    }
    

    CGFloat progressX = contentX - progressW - contentMargin;
    CGFloat progressY = CGRectGetMidY(contentFrame) - progressW/2;
    progress.frame = CGRectMake(progressX, progressY, progressW, progressW);
    
    if (bean.SendStatusType == SendStatusTypeSending) {
        if (progress.isHidden) [progress setHidden:NO];
        [progress startAnimating];
    }
    else {
        [progress stopAnimating];
    }
    
    itemMsg.textAlignment = NSTextAlignmentRight;
    CGFloat itemMsgX = contentX;
    CGFloat itemMsgY = CGRectGetMaxY(contentFrame) + marginBottom;
    itemMsg.frame = CGRectMake(itemMsgX, itemMsgY, contentFrame.size.width, 10.0f);
    
    if (bean.SendStatusType == SendStatusTypeError) {
        itemMsg.text = @"2017-01-01 下午2:20 发送失败";
        itemMsg.textColor = [UIColor redColor];
        [itemMsg setHidden:NO];
    }
    else if (bean.SendStatusType == SendStatusTypeReaded) {
        itemMsg.text = @"2017-01-01 下午2:20 已读";
        itemMsg.textColor = [UIColor darkGrayColor];
        [itemMsg setHidden:NO];
    }
    else {
        [itemMsg setHidden:YES];
    }
    
    CGFloat iconMaxY = itemMsg.isHidden ? CGRectGetMaxY(headPortrait.frame) : CGRectGetMaxY(itemMsg.frame);
    CGFloat textMaxY = itemMsg.isHidden ? CGRectGetMaxY(contentFrame) : CGRectGetMaxY(itemMsg.frame);
    cellHeight = MAX(iconMaxY, textMaxY) + padding_B;
    
    headPortrait.layer.cornerRadius = headPortraitW / 2;
    headPortrait.layer.masksToBounds = YES;
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:bean.HeadPortrait] placeholderImage:nil];
    
    
    
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
