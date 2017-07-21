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

static NSString* const Notification_Update_Chat = @"update_chat";
static NSString* const Notification_Update_Contact = @"update_contact";
static NSString* const Notification_Send_Message = @"send_message";
static NSString* const Notification_Receive_Message = @"receive_message";
static NSString* const Notification_Get_Recent_Begin = @"get_recent_begin";
static NSString* const Notification_Get_Recent_Finish = @"get_recent_finish";


@interface MyChat : NSObject

@property (nonatomic,strong) NSOperationQueue *queue;

+ (instancetype)sharedClient;

/*----------------废弃--------------------*/
//- (void)sendChat:(ChatModel*)model;
//- (void)receiveChat:(ChatModel*)model;

- (void)updateChatMessage:(ChatMessageModel*)model;
- (void)sendChatMessage:(ChatMessageModel *)model after:(void(^)(ChatMessageModel*))block;
- (void)receiveChatMessage:(ChatMessageModel *)model;

- (void)getRecent:(void(^)(void))block;

@end
