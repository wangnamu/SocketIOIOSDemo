//
//  UserInfoRepository.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "UserInfoRepository.h"

@implementation UserInfoRepository

+ (instancetype)sharedClient {
    static UserInfoRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UserInfoRepository alloc] init];
    });
    
    return _sharedClient;
}

- (UserInfoBean*)currentUser {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"currentUser"];
    if (data!=nil) {
        UserInfoBean *bean = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return bean;
    }
    return nil;
}

- (void)login:(UserInfoBean*)bean {
    
    bean.InUse = YES;
    bean.LoginTime = (long)[[NSDate date] timeIntervalSince1970];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bean];
    [userDefaults setObject:data forKey:@"currentUser"];
    [userDefaults synchronize];
    
}

- (void)logoff {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"currentUser"];
    
}



@end
