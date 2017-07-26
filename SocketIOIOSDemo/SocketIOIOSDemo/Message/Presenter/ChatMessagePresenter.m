//
//  ChatMessagePresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatMessagePresenter.h"
#import "ChatMessageRepository.h"
#import "ChatMessageModel.h"
#import "UserInfoRepository.h"
#import "MyChat.h"
#import "DateUtils.h"

@implementation ChatMessagePresenter
@synthesize chatMessageView,dataSource;
@synthesize pageSize,hasMore,isLoading;
@synthesize queue,sem;

- (instancetype)initWithView:(id<ChatMessageViewProtocol>)view {
    self = [super init];
    if (self) {
        chatMessageView = view;
        dataSource = [[NSMutableArray alloc] init];
        
        queue = dispatch_queue_create("com.ufo.socketio.chatMessageQueue", NULL);
        sem = dispatch_semaphore_create(0);
        
        pageSize = 10;
        hasMore = NO;
        isLoading = NO;
    }
    return self;
}

- (void)reloadDataWithChatID:(NSString *)chatID {
    
    dispatch_barrier_async(queue,^{
        
        isLoading = true;
        
        NSInteger totalCount = [[ChatMessageRepository sharedClient] getChatMessageSizeByChatID:chatID];
        
        NSInteger start = totalCount > pageSize ? totalCount - pageSize : 0;
        
        NSArray *array = [[ChatMessageRepository sharedClient] getChatMessageByChatID:chatID Begin:start End:totalCount];
        
        hasMore = start > 0;
        
        if (chatMessageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (dataSource.count > 0) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:array];
                [chatMessageView reloadDataComplete];
                isLoading = NO;
                
                dispatch_semaphore_signal(sem);
                
            });
        } else {
            dispatch_semaphore_signal(sem);
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    });

}

- (void)loadMoreDataWithChatID:(NSString *)chatID {
    
    NSInteger start = dataSource.count;
    
    NSInteger totalCount = [[ChatMessageRepository sharedClient] getChatMessageSizeByChatID:chatID];
    
    dispatch_barrier_async(queue,^{
        
        isLoading = YES;
        
        sleep(1);
        
       
        NSInteger length = totalCount - start > pageSize ? totalCount - start - pageSize : 0;
        
        NSArray *array = [[ChatMessageRepository sharedClient] getChatMessageByChatID:chatID Begin:length End:totalCount-start];
        
        hasMore = length > 0;
        
        if (chatMessageView) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (dataSource.count > 0) {
                    for (NSInteger i=array.count-1; i>=0; i--) {
                         [dataSource insertObject:array[i] atIndex:0];
                    }
                }
                [chatMessageView loadMoreDataComplete];
                isLoading = NO;

                dispatch_semaphore_signal(sem);
            });
            
        } else {
            dispatch_semaphore_signal(sem);
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    });
    
}




- (void)insertChatMessage:(ChatMessageModel *)model {
    
    dispatch_barrier_async(queue,^{
        
        if (chatMessageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [dataSource addObject:model];
                [chatMessageView updateChatMessageCell];
                
                dispatch_semaphore_signal(sem);
            });
        } else {
            dispatch_semaphore_signal(sem);
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    });
    
}

- (void)updateChatMessage:(ChatMessageModel *)model {
    
    dispatch_barrier_async(queue,^{
        
        if (chatMessageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataSource.count > 0 && [dataSource containsObject:model]) {
                    NSInteger index = [dataSource indexOfObject:model];
                    [dataSource replaceObjectAtIndex:index withObject:model];
                    [chatMessageView updateChatMessageCell];
                }
                dispatch_semaphore_signal(sem);
            });
        }
        else {
            dispatch_semaphore_signal(sem);
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    });
    
}

- (void)sendText:(NSString*)body
          ChatID:(NSString*)chatID {
    
    WS(ws);
    
    UserInfoBean *userInfoBean = [[UserInfoRepository sharedClient] currentUser];
  
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    
    if (userInfoBean == nil || deviceToken == nil) {
        return;
    }
    
    NSString *messageID = [[NSUUID UUID] UUIDString];
    ChatMessageModel *model = [[ChatMessageModel alloc] init];
    model.SID = messageID;
    model.SenderID = userInfoBean.SID;
    model.SenderDeviceToken = deviceToken;
    model.Title = userInfoBean.NickName;
    model.Body = body;
    model.Time = [DateUtils timeNow];
    model.MessageType = MessageTypeText;
    model.NickName = userInfoBean.NickName;
    model.HeadPortrait = userInfoBean.HeadPortrait;
    model.ChatID = chatID;
    model.SendStatusType = SendStatusTypeSending;
    [[MyChat sharedClient] sendChatMessage:model after:^(ChatMessageModel *m) {
        [ws insertChatMessage:m];
    }];
    
    NSDictionary *params = @{ @"chatID":chatID,@"body":body,@"messageID":messageID,@"senderID":userInfoBean.SID,@"senderDeviceToken":deviceToken };
    
    [[AFNetworkingClient sharedClient] POST:@"sendText" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *res = (NSDictionary *)responseObject;
        [ChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"SID" : @"sid",
                     @"SenderID" : @"senderID",
                     @"SenderDeviceToken":@"senderDeviceToken",
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
        ChatMessageModel *chatMessageModel = [ChatMessageModel mj_objectWithKeyValues:res];
        chatMessageModel.SendStatusType = SendStatusTypeSended;
        [[MyChat sharedClient] updateChatMessage:chatMessageModel];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
