//
//  MyChat.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/2.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"
#import "ChatMessageModel.h"

static NSString* const Notification_Send_Chat = @"send_chat";
static NSString* const Notification_Receive_Chat = @"receive_chat";
static NSString* const Notification_Send_Message =@"send_message";
static NSString* const Notification_Receive_Message = @"receive_message";


@interface MyChat : NSObject

@property (nonatomic,strong) NSOperationQueue *queue;

+ (instancetype)sharedClient;

- (void)sendChat:(ChatModel*)model;
- (void)receiveChat:(ChatModel*)model;

- (void)sendChatMessage:(ChatMessageModel*)model;
- (void)sendChatMessage:(ChatMessageModel *)model after:(void(^)(ChatMessageModel*))block;
- (void)receiveChatMessage:(ChatMessageModel *)model;

@end
