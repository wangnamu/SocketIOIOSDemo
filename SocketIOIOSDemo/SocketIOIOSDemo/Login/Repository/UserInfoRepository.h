//
//  UserInfoRepository.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoBean.h"

@interface UserInfoRepository : NSObject

+ (instancetype)sharedClient;

- (UserInfoBean*)currentUser;

- (void)login:(UserInfoBean*)bean;
- (void)logoff;

//- (void)del:(UserInfoBean*)bean;
//- (void)clear;

@end
