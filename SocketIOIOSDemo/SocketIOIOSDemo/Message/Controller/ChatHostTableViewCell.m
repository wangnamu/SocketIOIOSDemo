//
//  ChatHostTableViewCell.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatHostTableViewCell.h"
#import "DateUtils.h"
#import "ImageUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "UITableView+FDTemplateLayoutCell.h"

static CGFloat const contentPadding = 8.0f;
static CGFloat const padding_H = 16.0f;
static CGFloat const padding_B = 16.0f;
static CGFloat const progressW = 24.0f;
static CGFloat const nameW = 80.0f;
static CGFloat const marginBottom = 4.0f;
static CGFloat const contentMargin = 10.0f;
static CGFloat const cornerRadius = 8.0f;

static CGFloat const topTimeFontSize = 12.0f;
static CGFloat const nameFontSize = 12.0f;
static CGFloat const itemMsgFontSize = 10.0f;
static CGFloat const contentFontSize = 16.0f;

@implementation ChatHostTableViewCell
@synthesize headPortrait,name,topTime,itemMsg,progress;
@synthesize cellHeight;
@synthesize content,contentImage;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        topTime = [[UILabel alloc] init];
        topTime.textAlignment = NSTextAlignmentCenter;
        topTime.font = [UIFont systemFontOfSize:topTimeFontSize];
        [self.contentView addSubview:topTime];
        
        name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:nameFontSize];
        [self.contentView addSubview:name];
    
        headPortrait = [[UIImageView alloc] init];
        [self.contentView addSubview:headPortrait];
        
        progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        progress.hidesWhenStopped = YES;
        [self.contentView addSubview:progress];
        
        itemMsg = [[UILabel alloc] init];
        itemMsg.font = [UIFont systemFontOfSize:itemMsgFontSize];
        [self.contentView addSubview:itemMsg];
        
        content = [[InsetsLabel alloc] initWithInsets:UIEdgeInsetsMake(contentPadding,contentPadding,contentPadding,contentPadding)];
        content.font = [UIFont systemFontOfSize:contentFontSize];
        content.numberOfLines = 0;
        [self.contentView addSubview:content];
        
        contentImage = [[UIImageView alloc] init];
        [self.contentView addSubview:contentImage];
        
    }
    return self;
}

- (void)setupWithModel:(ChatMessageModel *)model
               Current:(long)current
                  Last:(long)last
                 Position:(NSInteger)position
                  Elapsed:(NSInteger)elapsed {
    
    [content setHidden:YES];
    [contentImage setHidden:YES];
    
    topTime.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    if (position == 0) {
        topTime.text = [DateUtils dateToShort:model.Time];
        [topTime setHidden:NO];
    } else if ([DateUtils inTimeCurrent:current Last:last Elapsed:elapsed]) {
        topTime.text = [DateUtils dateToShort:model.Time];
        [topTime setHidden:NO];
    } else {
        [topTime setHidden:YES];
        topTime.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }
   
    name.text = model.NickName;
    
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
    
    if ([model.MessageType isEqualToString:MessageTypeText]) {
        
        content.text = model.Body;
        [content setHidden:NO];
        
        CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH - 2*padding_H - headPortraitW - progressW - 2*contentMargin - 2*contentPadding, MAXFLOAT);
        CGSize textRealSize = [model.Body boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:contentFontSize]} context:nil].size;
        
        CGSize contentSize = CGSizeMake(textRealSize.width + 2*contentPadding, textRealSize.height + 2*contentPadding);
        
        contentX = SCREEN_WIDTH - padding_H - headPortraitW - contentMargin - contentSize.width;
        contentY = CGRectGetMaxY(name.frame) + marginBottom;
        contentFrame = (CGRect){{contentX,contentY},contentSize};
        content.frame = contentFrame;
        
        content.backgroundColor = COLOR_FROM_RGB(0x81cbd9);
        content.layer.cornerRadius = cornerRadius;
        content.layer.masksToBounds = YES;
        
    }
    else if ([model.MessageType isEqualToString:MessageTypeImage]) {
        
        [contentImage setHidden:NO];
        
        CGFloat imgMaxheight = 150.0f;
        
        UIImage *image = [UIImage imageNamed:model.Thumbnail];
        CGFloat scale = imgMaxheight / MAX(image.size.width, image.size.height);
        
        UIImage *thumb = [ImageUtils scaleImage:image toScale:scale];
        
        CGFloat thumbWidth = thumb.size.width;
        CGFloat thumbHeight = thumb.size.height;
        
        contentX = SCREEN_WIDTH - padding_H - headPortraitW - contentMargin - thumbWidth;
        contentY = CGRectGetMaxY(name.frame) + marginBottom;
        contentFrame = (CGRect){{contentX,contentY},{thumbWidth, thumbHeight}};
        contentImage.frame = contentFrame;
        
        [contentImage setImage:thumb];
       
        contentImage.layer.cornerRadius = cornerRadius;
        contentImage.layer.masksToBounds = YES;
    }
    else {
        
    }
    

    CGFloat progressX = contentX - progressW - contentMargin;
    CGFloat progressY = CGRectGetMidY(contentFrame) - progressW/2;
    progress.frame = CGRectMake(progressX, progressY, progressW, progressW);
    
    if (model.SendStatusType == SendStatusTypeSending) {
        if (progress.isHidden) [progress setHidden:NO];
        [progress startAnimating];
    }
    else {
        [progress stopAnimating];
    }
    
    itemMsg.textAlignment = NSTextAlignmentRight;
    CGFloat itemMsgX = SCREEN_WIDTH - padding_H - headPortraitW - contentMargin - 200.0f;
    CGFloat itemMsgY = CGRectGetMaxY(contentFrame) + marginBottom;
    itemMsg.frame = CGRectMake(itemMsgX, itemMsgY, 200.0f, 10.0f);
    
    if (model.SendStatusType == SendStatusTypeError) {
        itemMsg.text = @"2017-01-01 下午2:20 发送失败";
        itemMsg.textColor = [UIColor redColor];
        [itemMsg setHidden:NO];
    }
    else if (model.SendStatusType == SendStatusTypeReaded) {
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
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:model.HeadPortrait] placeholderImage:nil];
    
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
