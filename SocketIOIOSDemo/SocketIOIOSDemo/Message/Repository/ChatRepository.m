//
//  ChatRepository.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatRepository.h"

@implementation ChatRepository

+ (instancetype)sharedClient {
    static ChatRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ChatRepository alloc] init];
    });
    
    return _sharedClient;
}

@end
