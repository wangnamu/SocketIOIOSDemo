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
#import "ChatMessageBean.h"

@interface ChatMessageRepository : NSObject

+ (instancetype)sharedClient;

- (void)createChatMessage:(NSArray*)chatMessageBeans;
- (void)createOrUpdateChat:(ChatBean*)chatBean;
- (RLMResults<ChatBean*>*)getChat;
- (RLMResults<ChatMessageBean*>*)getChatMessage;
- (RLMResults<ChatBean*>*)getContact;
- (RLMResults<ChatMessageBean*>*)getChatMessageByChatID:(NSString*)chatID;

@end
