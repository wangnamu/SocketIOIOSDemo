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
#import "ChatMessageRepository.h"
#import "UserInfoRepository.h"
#import "SocketIOManager.h"

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
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    [dataSource addObjectsFromArray:[[ChatMessageRepository sharedClient] getChat]];
    [chatView refreshData];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [dataSource addObjectsFromArray:[[ChatMessageRepository sharedClient] getChat]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (chatView) {
//                [chatView refreshData];
//            }
//        });
//    });
}

- (void)createChatWithType:(NSString *)chatType
             ReceivePerson:(PersonBean *)person {
    
    NSDictionary *params = @{ @"chatType":chatType,@"receiverID":person.SID,@"senderID":[[UserInfoRepository sharedClient] currentUser].SID };
    
    [[AFNetworkingClient sharedClient] POST:@"createChat" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (chatView) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *res = (NSDictionary *)responseObject;
                
                [ChatBean mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"sid",
                             @"Users" : @"users",
                             @"Name" : @"name",
                             @"Img" : @"img",
                             @"Time" : @"time",
                             @"Body" : @"body",
                             @"ChatType" : @"chatType"
                             };
                }];
                
                ChatBean *chatBean = [ChatBean mj_objectWithKeyValues:res];
                
                if ([chatType isEqualToString:ChatTypeSingle]) {
                    chatBean.Name = person.NickName;
                    chatBean.Body = @"hello";
                    chatBean.Img = person.HeadPortrait;
                }
                
                [[ChatMessageRepository sharedClient] createChat:chatBean];
                
//                NSArray *array = [NSArray arrayWithObjects:chatMessageBean, nil];
//                [[ChatMessageRepository sharedClient] add:array];
               
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

- (void)receiveNotification:(NSNotification*)notification {
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [[notification userInfo] mj_JSONObject];
        
        SocketIOMessage *msg = [SocketIOMessage mj_objectWithKeyValues:dic];
        
        ChatBean *chatBean = [ChatBean mj_objectWithKeyValues:msg.Others];
    
    NSLog(@"chatBean->%@",chatBean);
    
        [[ChatMessageRepository sharedClient] createChat:chatBean];
        
    //});
    
    

}

@end
