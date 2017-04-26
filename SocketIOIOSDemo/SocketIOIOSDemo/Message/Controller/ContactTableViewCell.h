//
//  ContactTableViewCell.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

static NSString* const ContactTableViewCellNib = @"ContactTableViewCell";
static NSString* const ContactTableViewCellIdentifier = @"ContactTableViewCellIdentifier";
static CGFloat const ContactTableViewCellHeight = 56.0f;

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;

- (void)setup:(ChatModel*) model;

@end
