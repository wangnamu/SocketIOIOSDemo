//
//  ChatMessageRepository.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/23.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageBean.h"
#import "ChatMessageModel.h"
#import "ChatBean.h"
#import "ChatModel.h"
#import "DateUtils.h"

@interface ChatMessageRepository : NSObject

+ (instancetype)sharedClient;

- (void)createChatMessage:(NSArray*)chatMessageBeans;
- (void)updateChatMessage:(ChatMessageBean*)chatMessageBean;
- (void)createOrUpdateChat:(ChatBean*)chatBean;

- (ChatModel*)getChatLast;
- (NSArray*)getChat;
- (ChatMessageModel*)getChatMessageLast;
- (NSArray*)getChatMessage;
- (NSArray*)getContact;
- (NSArray*)getChatMessageByChatID:(NSString*)chatID Begin:(NSInteger)begin End:(NSInteger)end;
- (NSInteger)getChatMessageSizeByChatID:(NSString*)chatID;


@end
