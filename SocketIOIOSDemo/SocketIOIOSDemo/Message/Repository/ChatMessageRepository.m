//
//  ChatMessageRepository.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/23.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatMessageRepository.h"

@implementation ChatMessageRepository

+ (instancetype)sharedClient {
    static ChatMessageRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ChatMessageRepository alloc] init];
    });
    
    return _sharedClient;
}


- (void)createOrUpdateChat:(ChatBean *)chatBean {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults<ChatBean*> *result = [ChatBean objectsWhere:@"SID = %@",chatBean.SID];
    if (result.count > 0) {
        chatBean.DisplayInRecently = result.firstObject.DisplayInRecently;
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:chatBean];
        [realm commitWriteTransaction];
    }
    else {
        [realm beginWriteTransaction];
        [realm addObject:chatBean];
        [realm commitWriteTransaction];
    }
    
}


- (RLMResults<ChatBean*>*)getChat {
    RLMResults<ChatBean*> *beans = [[ChatBean objectsWhere:@"DisplayInRecently = YES"] sortedResultsUsingKeyPath:@"Time" ascending:NO];
    return beans;
}

- (RLMResults<ChatMessageBean*>*)getChatMessage {
    RLMResults<ChatMessageBean*> *beans = [[ChatMessageBean allObjects] sortedResultsUsingKeyPath:@"Time" ascending:NO];
    return beans;
}

- (RLMResults<ChatBean*>*)getContact {
    RLMResults<ChatBean*> *beans = [[ChatBean allObjects] sortedResultsUsingKeyPath:@"Name" ascending:YES];
    return beans;
}


- (RLMResults<ChatMessageBean*>*)getChatMessageByChatID:(NSString *)chatID {
    RLMResults<ChatMessageBean*> *beans = [[ChatMessageBean objectsWhere:@"ChatID = %@",chatID] sortedResultsUsingKeyPath:@"Time" ascending:YES];
    return beans;
}


- (void)createChatMessage:(NSArray*)chatMessageBeans {
    
    NSMutableArray *chatMessageArray = [[NSMutableArray alloc] init];
    
    NSMutableSet *set = [NSMutableSet set];
    [chatMessageBeans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [set addObject:obj[@"ChatID"]];
    }];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ChatID = %@", obj];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Time" ascending:NO];
        
        NSArray *group = [chatMessageBeans filteredArrayUsingPredicate:predicate];
        NSArray *top = [group sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [chatMessageArray addObject:[top firstObject]];
    }];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    for (ChatMessageBean *chatMessageItem in chatMessageArray) {
        RLMResults<ChatBean*> *chatBeanResult = [ChatBean objectsWhere:@"SID = %@",chatMessageItem.ChatID];
        if (chatBeanResult.count > 0) {
            
            ChatBean *chatBean = chatBeanResult.firstObject;
            
            /*-test-*/
            
            RLMResults<ChatMessageBean*> *messageBeanResult = [[ChatMessageBean objectsWhere:@"ChatID = %@",chatMessageItem.ChatID] sortedResultsUsingKeyPath:@"Time" ascending:NO];
            
            if (messageBeanResult.count > 0) {
                
                ChatMessageBean* chatMessageBeanOldest = messageBeanResult.firstObject;
                
                if (chatMessageItem.Time < chatMessageBeanOldest.Time) {
                    if ([chatBean.ChatType isEqualToString:ChatTypeSingle]) {
                        chatBean.Body = chatMessageBeanOldest.Body;
                        chatBean.Time = chatMessageBeanOldest.Time;
                        chatBean.DisplayInRecently = YES;
                    }
                    else if ([chatBean.ChatType isEqualToString:ChatTypeGroup]) {
                        chatBean.Body = [NSString stringWithFormat:@"%@:%@",chatMessageBeanOldest.NickName,chatMessageBeanOldest.Body];
                        chatBean.Time = chatMessageBeanOldest.Time;
                        chatBean.DisplayInRecently = YES;
                    }
                }
                else {
                    if ([chatBean.ChatType isEqualToString:ChatTypeSingle]) {
                        chatBean.Body = chatMessageItem.Body;
                        chatBean.Time = chatMessageItem.Time;
                        chatBean.DisplayInRecently = YES;
                    }
                    else if ([chatBean.ChatType isEqualToString:ChatTypeGroup]) {
                        chatBean.Body = [NSString stringWithFormat:@"%@:%@",chatMessageItem.NickName,chatMessageItem.Body];
                        chatBean.Time = chatMessageItem.Time;
                        chatBean.DisplayInRecently = YES;
                    }
                }
            }
            else {
                
                if ([chatBean.ChatType isEqualToString:ChatTypeSingle]) {
                    chatBean.Body = chatMessageItem.Body;
                    chatBean.Time = chatMessageItem.Time;
                    chatBean.DisplayInRecently = YES;
                }
                else if ([chatBean.ChatType isEqualToString:ChatTypeGroup]) {
                    chatBean.Body = [NSString stringWithFormat:@"%@:%@",chatMessageItem.NickName,chatMessageItem.Body];
                    chatBean.Time = chatMessageItem.Time;
                    chatBean.DisplayInRecently = YES;
                }
                
            }
            
            /*--*/
            
//            if ([chatBean.ChatType isEqualToString:ChatTypeSingle]) {
//                chatBean.Body = chatMessageItem.Body;
//                chatBean.Time = chatMessageItem.Time;
//                chatBean.DisplayInRecently = YES;
//            }
//            else if ([chatBean.ChatType isEqualToString:ChatTypeGroup]) {
//                chatBean.Body = [NSString stringWithFormat:@"%@:%@",chatMessageItem.NickName,chatMessageItem.Body];
//                chatBean.Time = chatMessageItem.Time;
//                chatBean.DisplayInRecently = YES;
//            }
  
            
        }
        else {
            
//            ChatBean *chatBean = [[ChatBean alloc] init];
//            chatBean.SID = item.ChatID;
//            chatBean.SenderID = item.SenderID;
//            chatBean.Name = item.NickName;
//            chatBean.Img = item.ChatHeadPortrait;
//            chatBean.Time = item.Time;
//            chatBean.Body = item.Body;
//            chatBean.ChatType = item.ChatType;
//            
//            [realm addObject:chatBean];
        }
    }
    
    [realm addOrUpdateObjectsFromArray:chatMessageBeans];
    
    [realm commitWriteTransaction];
    
}

@end
