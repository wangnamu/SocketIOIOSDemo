//
//  MyQueue.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/28.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "MyQueue.h"

@implementation MyQueue

+ (instancetype)sharedClient {
    static MyQueue *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyQueue alloc] init];
        _sharedClient.maxConcurrentOperationCount = 1;
    });
    
    return _sharedClient;
}

@end
