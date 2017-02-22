//
//  LoginPresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewProtocol.h"
#import "LoginPresenterProtocol.h"

@interface LoginPresenter : NSObject<LoginPresenterProtocol>

@property (nonatomic,weak) id<LoginViewProtocol> loginView;

- (instancetype)initWithView:(id<LoginViewProtocol>)view;

- (void)loginUserName:(NSString *)username PassWord:(NSString *)password;

@end
