//
//  ChatPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatPresenter.h"
#import "ChatModel.h"
#import "ChatMessageBean.h"
#import "ChatMessageRepository.h"
#import "UserInfoRepository.h"
#import "SocketIOManager.h"
#import "MyChat.h"

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

- (void)updateChat {
    
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    RLMResults<ChatBean*> *result = [[ChatMessageRepository sharedClient] getChat];
    for (ChatBean *bean in result) {
        [dataSource addObject:[ChatModel fromBean:bean]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(chatView) {
            [chatView refreshData];
        }
    });
    
}

//- (void)createChatWithType:(NSString *)chatType
//             ReceivePerson:(PersonBean *)person {
//    
//    NSDictionary *params = @{ @"chatType":chatType,@"receiverID":person.SID,@"senderID":[[UserInfoRepository sharedClient] currentUser].SID };
//    
//    [[AFNetworkingClient sharedClient] POST:@"createChat" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (chatView) {
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                NSDictionary *res = (NSDictionary *)responseObject;
//                
//                [ChatModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{
//                             @"SID" : @"sid",
//                             @"Users" : @"users",
//                             @"Name" : @"name",
//                             @"Img" : @"img",
//                             @"Time" : @"time",
//                             @"Body" : @"body",
//                             @"ChatType" : @"chatType"
//                             };
//                }];
//                
//                ChatModel *chatModel = [ChatModel mj_objectWithKeyValues:res];
//                
//                if ([chatType isEqualToString:ChatTypeSingle]) {
//                    chatModel.Name = person.NickName;
//                    chatModel.Body = @"hello";
//                    chatModel.Img = person.HeadPortrait;
//                }
//                
//                [[MyChat sharedClient] sendChat:chatModel];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (chatView) {
//                        [chatView chatPushTo:chatModel.SID Name:chatModel.Name];
//                    }
//                });
//                
//            });
//            
//            
//        }
//       
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//
//}





@end
