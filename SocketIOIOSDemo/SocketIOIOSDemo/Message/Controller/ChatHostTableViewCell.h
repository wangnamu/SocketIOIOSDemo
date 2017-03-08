//
//  ChatHostTableViewCell.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
#import "InsetsLabel.h"

static  NSString* const ChatHostTableViewCellIdentifier = @"ChatHostTableViewCellIdentifier";
@interface ChatHostTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headPortrait;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *topTime;
@property (nonatomic,strong) UILabel *itemMsg;
@property (nonatomic,strong) UIActivityIndicatorView *progress;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) InsetsLabel *content;
@property (nonatomic,strong) UIImageView *contentImage;

- (void)setupWithModel:(ChatMessageModel*)model
               Current:(long)current
                  Last:(long)last
              Position:(NSInteger)position
               Elapsed:(NSInteger)elapsed;


@end
