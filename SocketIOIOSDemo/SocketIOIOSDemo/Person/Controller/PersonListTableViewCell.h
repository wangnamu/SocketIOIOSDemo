//
//  PersonListTableViewCell.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonBean.h"

static  NSString* const PersonListTableViewCellNib = @"PersonListTableViewCell";
static  NSString* const PersonListTableViewCellIdentifier = @"PersonListTableViewCellIdentifier";
static CGFloat const PersonListTableViewCellHeight = 56.0f;

@interface PersonListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;

- (void)setup:(PersonBean*) bean;

@end
