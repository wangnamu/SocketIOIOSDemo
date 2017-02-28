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


- (NSArray*)getChat {
    RLMResults<ChatBean*> *beans = [ChatBean allObjects];
    if (beans.count > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ChatBean* bean in beans) {
            [array addObject:bean];
        }
        return array;
    }
//    [beans addNotificationBlock:^(RLMResults<ChatBean *> * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
//        
//    }]
    return nil;
}

- (void)createChat:(ChatBean *)bean {
    
    [[MyQueue sharedClient] addOperationWithBlock:^{
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        [realm addObject:bean];
        
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_CreateChat" object:self];
        });
        
        
        
    }];

}


- (void)add:(NSArray*)beans {
    
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //        RLMRealm *realm = [RLMRealm defaultRealm];
        //        [realm transactionWithBlock:^{
        //            [realm addObjects:beans];
        //        }];
        
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

                chatBean.SenderID = item.SenderID;
                chatBean.Name = item.NickName;
                chatBean.Body = item.Body;
                chatBean.Img = item.ChatHeadPortrait;
                chatBean.Time = item.Time;
                chatBean.ChatType = item.ChatType;
            }
            else {
                
                ChatBean *chatBean = [[ChatBean alloc] init];
                chatBean.SID = item.ChatID;
                chatBean.SenderID = item.SenderID;
                chatBean.Name = item.NickName;
                chatBean.Img = item.ChatHeadPortrait;
                chatBean.Time = item.Time;
                chatBean.Body = item.Body;
                chatBean.ChatType = item.ChatType;
                
                [realm addObject:chatBean];
            }
        }
        
        [realm addObjects:beans];
        
        [realm commitWriteTransaction];
        
    });
    */
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    [queue addOperationWithBlock:^{
        
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
                
                chatBean.SenderID = item.SenderID;
                chatBean.Name = item.NickName;
                chatBean.Body = item.Body;
                chatBean.Img = item.ChatHeadPortrait;
                chatBean.Time = item.Time;
                chatBean.ChatType = item.ChatType;
            }
            else {
                
                ChatBean *chatBean = [[ChatBean alloc] init];
                chatBean.SID = item.ChatID;
                chatBean.SenderID = item.SenderID;
                chatBean.Name = item.NickName;
                chatBean.Img = item.ChatHeadPortrait;
                chatBean.Time = item.Time;
                chatBean.Body = item.Body;
                chatBean.ChatType = item.ChatType;
                
                [realm addObject:chatBean];
            }
        }
        
        [realm addObjects:beans];
        
        [realm commitWriteTransaction];
        
    }];
     */
    
}

@end
