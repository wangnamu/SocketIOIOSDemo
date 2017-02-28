//
//  ChatMessageRepository.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/23.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageBean.h"
#import "ChatBean.h"
#import "MyQueue.h"

@interface ChatMessageRepository : NSObject

+ (instancetype)sharedClient;

- (void)add:(NSArray*)beans;

- (NSArray*)getChat;

- (void)createChat:(ChatBean*)bean;

@end
