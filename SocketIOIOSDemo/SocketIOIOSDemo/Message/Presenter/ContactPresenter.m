//
//  ContactPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ContactPresenter.h"
#import "UserInfoRepository.h"
#import "ChatMessageRepository.h"
#import "ChatModel.h"

@implementation ContactPresenter
@synthesize contactView,dataSource;

- (instancetype)initWithView:(id<ContactViewProtocol>)view {
    self = [super init];
    if (self) {
        contactView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}


//- (void)loadDataFromRemote {
//    
//    NSDictionary *params = @{@"userID":[[UserInfoRepository sharedClient] currentUser].SID,
//                             @"last":@(0),
//                             @"current":@(0)
//                             };
//    
//    [[AFNetworkingClient sharedClient] GET:@"chatList" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (contactView) {
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                NSArray *res = (NSArray *)responseObject;
//                
//                if (res.count > 0) {
//                    if (dataSource.count > 0) {
//                        [dataSource removeAllObjects];
//                    }
//                    for (NSDictionary *dic in res) {
//                        
//                        [ChatModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//                            return @{
//                                     @"SID" : @"sid",
//                                     @"Users" : @"users",
//                                     @"Name" : @"name",
//                                     @"Img" : @"img",
//                                     @"Time" : @"time",
//                                     @"Body" : @"body",
//                                     @"ChatType" : @"chatType"
//                                     };
//                        }];
//                        
//                        ChatModel *chatModel = [ChatModel mj_objectWithKeyValues:dic];
//                        
//                        [dataSource addObject:chatModel];
//                    }
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (contactView) {
//                        [contactView refreshData];
//                    }
//                });
//                
//            });
//            
//            
//            
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //        SHOW_ERROR_PROGRESS([[error userInfo] objectForKey:@"NSLocalizedDescription"]);
//        //        if (loginView) {
//        //            [loginView loginFail:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
//        //        }
//    }];
//    
//    
//}

- (void)loadData {
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
        
        RLMResults<ChatBean*> *result = [[ChatMessageRepository sharedClient] getContact];
        for (ChatBean* bean in result) {
            [dataSource addObject:[ChatModel fromBean:bean]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(contactView) {
                [contactView refreshData];
            }
        });
        
    });
    
}



@end




