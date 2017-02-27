//
//  PersonListPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "PersonListPresenter.h"
#import "PersonBean.h"
#import "UserInfoRepository.h"

@implementation PersonListPresenter
@synthesize personListView,dataSource;

- (instancetype)initWithView:(id<PersonListViewProtocol>)view {
    self = [super init];
    if (self) {
        personListView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)loadDataFromUrl {
    
    [[AFNetworkingClient sharedClient] GET:@"userList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (personListView) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSArray *res = (NSArray *)responseObject;
             
                if (res.count > 0) {
                    if (dataSource.count > 0) {
                        [dataSource removeAllObjects];
                    }
                    for (NSDictionary *dic in res) {
                        
                        [PersonBean mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"SID" : @"sid",
                                     @"UserName" : @"userName",
                                     @"PassWord" : @"passWord",
                                     @"NickName" : @"nickName",
                                     @"HeadPortrait" : @"headPortrait"
                                     };
                        }];

                        PersonBean *person = [PersonBean mj_objectWithKeyValues:dic];
                        [dataSource addObject:person];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (personListView) {
                        [personListView refreshData];
                    }
                });
                
            });
            
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        SHOW_ERROR_PROGRESS([[error userInfo] objectForKey:@"NSLocalizedDescription"]);
//        if (loginView) {
//            [loginView loginFail:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
//        }
    }];

    
}

- (void)loadDataFromLocal {

}




@end
