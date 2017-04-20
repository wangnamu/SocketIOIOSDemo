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

- (instancetype)initWithView:(id<ChatMessageViewProtocol>)view {
    self = [super init];
    if (self) {
        chatMessageView = view;
        dataSource = [[NSMutableArray alloc] init];
        
        pageSize = 10;
        hasMore = NO;
        isLoading = NO;
    }
    return self;
}

- (void)reloadDataWithChatID:(NSString *)chatID {
    
    isLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMResults<ChatMessageBean*> *result = [[ChatMessageRepository sharedClient] getChatMessageByChatID:chatID];
        
        @synchronized (dataSource) {
            
            if (dataSource.count > 0) {
                [dataSource removeAllObjects];
            }
            
            NSInteger start = result.count > pageSize ? result.count - pageSize : 0;
        
            for (NSInteger i = start; i < result.count; i++) {
                ChatMessageBean *bean = result[i];
                [dataSource addObject:[ChatMessageModel fromBean:bean]];
            }
            
            hasMore = start > 0 ? YES : NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(chatMessageView) {
                [chatMessageView reloadDataComplete];
                isLoading = NO;
            }
        });
        
    });
}

- (void)loadMoreDataWithChatID:(NSString *)chatID {
    
    isLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        
        RLMResults<ChatMessageBean*> *result = [[ChatMessageRepository sharedClient] getChatMessageByChatID:chatID];
        
        @synchronized (dataSource) {
            
            NSInteger start = dataSource.count + 1;
            
            NSInteger length = result.count - start > pageSize ? result.count - start - pageSize : -1;
        

            for (NSInteger i = result.count - start; i > length; i--) {
                ChatMessageBean *bean = result[i];
                [dataSource insertObject:[ChatMessageModel fromBean:bean] atIndex:0];
            }

            
            hasMore = length > 0 ? YES : NO;

        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(chatMessageView) {
                [chatMessageView loadMoreDataComplete];
                isLoading = NO;
            }
        });
        
    });
    
}


- (void)insertChatMessage:(ChatMessageModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (dataSource) {
            [dataSource addObject:model];
        }
        if (chatMessageView) {
            [chatMessageView insertChatMessageToCell:dataSource.count-1];
        }
    });
}

- (void)updateChatMessage:(ChatMessageModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (dataSource.count > 0 && [dataSource containsObject:model]) {
            NSInteger index = [dataSource indexOfObject:model];
            @synchronized (dataSource) {
                [dataSource replaceObjectAtIndex:index withObject:model];
            }
            if (chatMessageView) {
                [chatMessageView updateChatMessageForCell:index];
            }
        }
    });
}

- (void)sendText:(NSString*)body
          ChatID:(id)chatID {
    
    WS(ws);
    
    NSString *messageID = [[NSUUID UUID] UUIDString];
    ChatMessageModel *model = [[ChatMessageModel alloc] init];
    model.SID = messageID;
    model.SenderID = [[UserInfoRepository sharedClient] currentUser].SID;
    model.Title = [[UserInfoRepository sharedClient] currentUser].NickName;
    model.Body = body;
    model.Time = [DateUtils timeNow];
    model.MessageType = MessageTypeText;
    model.NickName = [[UserInfoRepository sharedClient] currentUser].NickName;
    model.HeadPortrait = [[UserInfoRepository sharedClient] currentUser].HeadPortrait;
    model.ChatID = chatID;
    model.SendStatusType = SendStatusTypeSending;
    [[MyChat sharedClient] sendChatMessage:model after:^(ChatMessageModel *m) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws insertChatMessage:m];
        });
    }];
    
    NSDictionary *params = @{ @"chatID":chatID,@"body":body,@"messageID":messageID,@"senderID":[[UserInfoRepository sharedClient] currentUser].SID };
    
    
    [[AFNetworkingClient sharedClient] POST:@"sendText" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (chatMessageView) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //sleep(5);
                
                NSDictionary *res = (NSDictionary *)responseObject;
                
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
                
                ChatMessageModel *chatMessageModel = [ChatMessageModel mj_objectWithKeyValues:res];
                
                [[MyChat sharedClient] sendChatMessage:chatMessageModel];
                
            });
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
