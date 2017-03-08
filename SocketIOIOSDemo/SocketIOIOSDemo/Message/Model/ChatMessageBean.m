//
//  MessageBean.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatMessageBean.h"
#import "UserInfoRepository.h"

@implementation ChatMessageBean

+ (NSString *)primaryKey {
    return @"SID";
}

- (BOOL)isHost {
    NSString *currentUserID = [[UserInfoRepository sharedClient] currentUser].SID;
    if ([currentUserID isEqualToString:self.SenderID]) {
        return YES;
    }
    return NO;
}

@end
