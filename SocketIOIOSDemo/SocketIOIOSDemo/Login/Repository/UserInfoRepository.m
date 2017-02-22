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
//    RLMResults<UserInfoBean*> *beans = [UserInfoBean objectsWhere:@"InUse == YES"];
//    if (beans.count > 0) {
//        return [beans firstObject];
//    }
//    return nil;
    
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
    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm transactionWithBlock:^{
//        [realm addOrUpdateObject:bean];
//    }];
    
}

- (void)logoff {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"currentUser"];
    
//    RLMResults<UserInfoBean*> *beans = [UserInfoBean objectsWhere:@"InUse == YES"];
//    
//    if (beans.count > 0) {
//        UserInfoBean* bean = [beans firstObject];
//        
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm transactionWithBlock:^{
//            bean.InUse = NO;
//        }];
//
//    }
    
}

//- (void)del:(UserInfoBean *)bean {
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm transactionWithBlock:^{
//        [realm deleteObject:bean];
//    }];
//}
//
//- (void)clear {
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm transactionWithBlock:^{
//        [realm deleteAllObjects];
//    }];
//}




@end
