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


- (void)createOrUpdateChat:(ChatBean *)bean {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults<ChatBean*> *result = [ChatBean objectsWhere:@"SID = %@",bean.SID];
    if (result.count > 0) {
        bean.DisplayInRecently = result.firstObject.DisplayInRecently;
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:bean];
        [realm commitWriteTransaction];
    }
    else {
        [realm beginWriteTransaction];
        [realm addObject:bean];
        [realm commitWriteTransaction];
    }
    
}


- (RLMResults<ChatBean*>*)getChat {
    RLMResults<ChatBean*> *beans = [[ChatBean objectsWhere:@"DisplayInRecently = YES"] sortedResultsUsingKeyPath:@"Time" ascending:NO];
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


- (void)createChatMessage:(NSArray*)beans {
    
    NSMutableArray *chatArray = [[NSMutableArray alloc] init];
    
    NSMutableSet *set = [NSMutableSet set];
    [beans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [set addObject:obj[@"ChatID"]];
    }];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ChatID = %@", obj];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Time" ascending:NO];
        
        NSArray *group = [beans filteredArrayUsingPredicate:predicate];
        NSArray *top = [group sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [chatArray addObject:[top firstObject]];
    }];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    for (ChatMessageBean *item in chatArray) {
        RLMResults<ChatBean*> *result = [ChatBean objectsWhere:@"SID = %@",item.ChatID];
        if (result.count > 0) {
            ChatBean *chatBean = result.firstObject;
            
            if ([chatBean.ChatType isEqualToString:ChatTypeSingle]) {
                chatBean.Body = item.Body;
                chatBean.Time = item.Time;
                chatBean.DisplayInRecently = YES;
            }
            
            else if ([chatBean.ChatType isEqualToString:ChatTypeGroup]) {
                chatBean.Body = [NSString stringWithFormat:@"%@:%@",item.NickName,item.Body];
                chatBean.Time = item.Time;
                chatBean.DisplayInRecently = YES;
            }
            
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
    
    [realm addOrUpdateObjectsFromArray:beans];
    
    [realm commitWriteTransaction];
    
    
}

@end
