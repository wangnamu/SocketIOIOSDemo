//
//  SocketIOLoginStatus.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/6/6.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "SocketIOLoginStatus.h"

@implementation SocketIOLoginStatus

+ (BOOL)isNeedToCheck {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL status = [userDefaults boolForKey:@"needToCheck"];
    return status;
}

+ (void)setNeedToCheck:(BOOL)status {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:status forKey:@"needToCheck"];
    [userDefaults synchronize];
}


@end
