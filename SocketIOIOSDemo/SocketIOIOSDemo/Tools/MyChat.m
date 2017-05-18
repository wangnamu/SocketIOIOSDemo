//
//  MyChat.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/2.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "MyChat.h"
#import "ChatMessageRepository.h"
#import "UserInfoRepository.h"
#import "DateUtils.h"


@implementation MyChat
@synthesize queue;

+ (instancetype)sharedClient {
    static MyChat *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyChat alloc] init];
    });
    
    return _sharedClient;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
    }
    return self;
}


- (void)getRecent {
    [queue addOperationWithBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Get_Recent_Begin object:nil];
        });
        
        
        long last = 0;
        long current = [DateUtils timeNow];
        RLMResults<ChatBean*> *chatBeans = [[ChatMessageRepository sharedClient] getChat];
        
        if (chatBeans.count > 0) {
            last = chatBeans.firstObject.CreateTime;
        }
       
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSMutableArray *dataChatMessage = [[NSMutableArray alloc] init];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        NSDictionary *chatlistParams = @{@"userID":[[UserInfoRepository sharedClient] currentUser].SID,@"last":@(last),@"current":@(current)};

        [[AFNetworkingClient sharedClient] GET:@"chatList" parameters:chatlistParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *res = (NSArray *)responseObject;
       
            for (NSDictionary *dic in res) {
                
                [ChatModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"sid",
                             @"Users" : @"users",
                             @"Name" : @"name",
                             @"Img" : @"img",
                             @"Time" : @"time",
                             @"CreateTime" : @"createTime",
                             @"Body" : @"body",
                             @"ChatType" : @"chatType"
                             };
                }];
                
                ChatModel *chatModel = [ChatModel mj_objectWithKeyValues:dic];
                [[ChatMessageRepository sharedClient] createOrUpdateChat:[chatModel toBean]];

            }
            
            dispatch_semaphore_signal(sem);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_semaphore_signal(sem);
        }];

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
        RLMResults<ChatMessageBean*> *chatMessageBeans = [[ChatMessageRepository sharedClient] getChatMessage];
        
        if (chatMessageBeans.count > 0) {
            last = chatMessageBeans.firstObject.Time;
        }
        else {
            last = [DateUtils timeNow];
        }
        
        NSDictionary *chatMessageListParams = @{@"userID":[[UserInfoRepository sharedClient] currentUser].SID,@"last":@(last),@"current":@(current)};
        
        [[AFNetworkingClient sharedClient] GET:@"chatMessageList" parameters:chatMessageListParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            NSArray *res = (NSArray *)responseObject;
            
            for (NSDictionary *dic in res) {
                
                [ChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"sid",
                             @"SenderID" : @"senderID",
                             @"Title" : @"title",
                             @"Body" : @"body",
                             @"Time" : @"time",
                             @"MessageType" : @"messageType",
                             @"NickName" : @"nickName",
                             @"HeadPortrait" : @"headPortrait",
                             @"ChatID" : @"chatID",
                             @"Thumbnail" : @"thumbnail",
                             @"Original" : @"original",
                             };
                }];
                
                
                ChatMessageModel *chatMessageModel = [ChatMessageModel mj_objectWithKeyValues:dic];
                chatMessageModel.LocalTime = [DateUtils timeNow];
                [dataChatMessage addObject:[chatMessageModel toBean]];
            }

            dispatch_semaphore_signal(sem);
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //SHOW_ERROR_PROGRESS([[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            dispatch_semaphore_signal(sem);
        }];
    
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 
        if(dataChatMessage.count > 0){
            [[ChatMessageRepository sharedClient] createChatMessage:dataChatMessage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Update_Contact object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Get_Recent_Finish object:nil];
        });
        
    }];

}


/*----------------废弃--------------------*/
//- (void)sendChat:(ChatModel *)model {
//    //__weak ChatModel *weakModel = model;
//    [queue addOperationWithBlock:^{
//        //__strong ChatModel *chatModel = weakModel;
//        ChatBean *bean = [model toBean];
//        [[ChatMessageRepository sharedClient] createOrUpdateChat:bean];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Send_Chat object:nil];
//        });
//    }];
//}
//
//- (void)receiveChat:(ChatModel *)model {
//    //__block ChatModel *chatModel = model;
//    [queue addOperationWithBlock:^{
//        //__strong ChatModel *chatModel = weakModel;
//        ChatBean *bean = [model toBean];
//        [[ChatMessageRepository sharedClient] createOrUpdateChat:bean];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Receive_Chat object:nil];
//           // chatModel = nil;
//        });
//    }];
//}


- (void)sendChatMessage:(ChatMessageModel *)model after:(void(^)(ChatMessageModel*))block {
    [queue addOperationWithBlock:^{
        ChatMessageBean *bean = [model toBean];
        bean.LocalTime = [DateUtils timeNow];
        [[ChatMessageRepository sharedClient] createChatMessage:[NSArray arrayWithObjects:bean, nil]];
        block(model);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Update_Chat object:nil];
        });
    }];
}

- (void)updateChatMessage:(ChatMessageModel *)model {
    
    [queue addOperationWithBlock:^{
        ChatMessageBean *bean = [model toBean];
        [[ChatMessageRepository sharedClient] updateChatMessage:bean];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Send_Message object:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Update_Chat object:nil];
        });
    }];
}

- (void)receiveChatMessage:(ChatMessageModel *)model {
    [queue addOperationWithBlock:^{
        ChatMessageBean *bean = [model toBean];
        bean.LocalTime = [DateUtils timeNow];
        [[ChatMessageRepository sharedClient] createChatMessage:[NSArray arrayWithObjects:bean, nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Receive_Message object:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Update_Chat object:nil];
        });
    }];
}


@end
