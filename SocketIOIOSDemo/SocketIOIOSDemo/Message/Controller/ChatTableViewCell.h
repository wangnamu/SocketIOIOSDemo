//
//  ChatTableViewCell.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

static  NSString* const ChatTableViewCellNib = @"ChatTableViewCell";
static  NSString* const ChatTableViewCellIdentifier = @"ChatTableViewCellIdentifier";
static CGFloat const ChatTableViewCellHeight = 72.0f;

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UILabel *time;

- (void)setup:(ChatModel*) model;


@end
