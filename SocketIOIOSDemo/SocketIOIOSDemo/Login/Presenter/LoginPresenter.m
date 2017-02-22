//
//  LoginPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "LoginPresenter.h"
#import "UserInfoRepository.h"
#import "ResultModel.h"

@implementation LoginPresenter
@synthesize loginView;

- (instancetype)initWithView:(id<LoginViewProtocol>)view {
    self = [super init];
    if (self) {
        loginView = view;
    }
    return self;

}

- (void)loginUserName:(NSString *)username
             PassWord:(NSString *)password {

    SHOW_PROGRESS;
    
    NSDictionary *params = @{@"username":username,@"password":password};
    
    [[AFNetworkingClient sharedClient] POST:@"login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *res = (NSDictionary *)responseObject;
        ResultModel *resultModel = [ResultModel mj_objectWithKeyValues:res];
        
        if (resultModel.IsSuccess) {
            
            if (loginView) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSDictionary *dic = (NSDictionary*)resultModel.Data;
                    
                    [UserInfoBean mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"SID" : @"sid",
                                 @"UserName" : @"userName",
                                 @"PassWord" : @"passWord",
                                 @"NickName" : @"nickName",
                                 @"HeadPortrait" : @"headPortrait",
                                 @"LoginTime" : @"loginTime",
                                 @"InUse":@"inUse"
                                 };
                    }];
                    
                    UserInfoBean *userInfoBean = [UserInfoBean mj_objectWithKeyValues:dic];
                    
                    [[UserInfoRepository sharedClient] login:userInfoBean];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        HIDE_PROGRESS;
                        
                        if (loginView) {
                            [loginView loginSuccess];
                        }
                    });
                });
            }
            
            
        }
        else {
            if (resultModel.ErrorMessage != nil ) {
                SHOW_ERROR_PROGRESS(resultModel.ErrorMessage);
                if (loginView) {
                     [loginView loginFail:resultModel.ErrorMessage];
                }
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SHOW_ERROR_PROGRESS([[error userInfo] objectForKey:@"NSLocalizedDescription"]);
        if (loginView) {
            [loginView loginFail:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
        }
    }];
}


@end
