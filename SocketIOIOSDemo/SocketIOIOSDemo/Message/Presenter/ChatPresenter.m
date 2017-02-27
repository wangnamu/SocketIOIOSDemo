//
//  ChatPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatPresenter.h"
#import "ChatBean.h"
#import "ChatMessageBean.h"
#import "ChatRepository.h"
#import "ChatMessageRepository.h"

@implementation ChatPresenter
@synthesize chatView,dataSource;

- (instancetype)initWithView:(id<ChatViewProtocol>)view {
    self = [super init];
    if (self) {
        chatView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData {
    
       
}

- (void)createChatSenderID:(NSString*)senderID
                ReceiverID:(NSString*)receiverID {
    
    NSDictionary *params = @{ @"receiverID":receiverID,@"senderID":senderID };
    
    [[AFNetworkingClient sharedClient] POST:@"createChat" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (chatView) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *res = (NSDictionary *)responseObject;
                
                [ChatMessageBean mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"sid",
                             @"SenderID" : @"senderID",
                             @"Title" : @"title",
                             @"Body" : @"body",
                             @"Time" : @"time",
                             @"MessageType" : @"messageType",
                             @"NickName":@"nickName",
                             @"HeadPortrait":@"headPortrait",
                             @"ChatID":@"chatID",
                             @"Thumbnail":@"thumbnail",
                             @"Original":@"original",
                             @"ChatHeadPortrait":@"chatHeadPortrait",
                             @"ChatType":@"chatType"
                             };
                }];
                
                ChatMessageBean *chatMessageBean = [ChatMessageBean mj_objectWithKeyValues:res];
                
                NSArray *array = [NSArray arrayWithObjects:chatMessageBean, nil];
                [[ChatMessageRepository sharedClient] add:array];
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (chatView) {
                        [chatView chatPushTo];
                    }
                });
                
            });
            
            
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

@end
