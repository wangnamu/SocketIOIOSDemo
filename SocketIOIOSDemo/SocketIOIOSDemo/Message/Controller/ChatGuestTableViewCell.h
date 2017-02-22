//
//  ChatGuestTableViewCell.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBean.h"
#import "InsetsLabel.h"

static  NSString* const ChatGuestTableViewCellIdentifier = @"ChatGuestTableViewCellIdentifier";
@interface ChatGuestTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headPortrait;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) InsetsLabel *content;
@property (nonatomic,strong) UILabel *topTime;
@property (nonatomic,strong) UILabel *itemMsg;
@property (nonatomic,strong) UIActivityIndicatorView *progress;

@property (nonatomic,assign) CGFloat cellHeight;

- (void)setup:(MessageBean*)bean;

@end
