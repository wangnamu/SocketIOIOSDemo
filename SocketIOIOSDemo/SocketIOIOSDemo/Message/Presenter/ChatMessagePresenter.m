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

@implementation ChatMessagePresenter
@synthesize chatMessageView,dataSource;

- (instancetype)initWithView:(id<ChatMessageViewProtocol>)view {
    self = [super init];
    if (self) {
        chatMessageView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadDataWithChatID:(NSString *)chatID {
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    RLMResults<ChatMessageBean*> *result = [[ChatMessageRepository sharedClient] getChatMessageByChatID:chatID];
    for (ChatMessageBean *bean in result) {
        [dataSource addObject:[ChatMessageModel fromBean:bean]];
    }
    [chatMessageView refreshData];
}

- (void)sendText:(NSString*)body
          ChatID:(id)chatID {
    
    NSDictionary *params = @{ @"chatID":chatID,@"body":body,@"senderID":[[UserInfoRepository sharedClient] currentUser].SID };
    
    //WS(ws);
    [[AFNetworkingClient sharedClient] POST:@"sendText" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (chatMessageView) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *res = (NSDictionary *)responseObject;
                
                [ChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"sid",
                             @"SenderID" : @"senderID",
                             @"Title" : @"title",
                             @"Body" : @"body",
                             @"Time" : @"time",
                             @"Body" : @"body",
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (chatMessageView) {
                       
                        //[ws loadDataWithChatID:chatID];
                    }
                });
                
            });
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
