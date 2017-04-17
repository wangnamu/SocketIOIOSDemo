//
//  ChatMessageViewController.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageViewController : UIViewController

- (instancetype)initWithChatID:(NSString *)chatID
                          Name:(NSString *)name;

@end
