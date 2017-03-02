//
//  MyChat.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/2.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "MyChat.h"
#import "ChatMessageRepository.h"


@implementation MyChat
@synthesize queue;

+ (instancetype)sharedClient {
    static MyChat *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyChat alloc] init];
    });
    
    return _sharedClient;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
    }
    return self;
}


- (void)sendChat:(ChatModel *)model {
    //__weak ChatModel *weakModel = model;
    [queue addOperationWithBlock:^{
        //__strong ChatModel *chatModel = weakModel;
        ChatBean *bean = [model toBean];
        [[ChatMessageRepository sharedClient] createOrUpdateChat:bean];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Send_Chat object:model];
        });
    }];
}

- (void)receiveChat:(ChatModel *)model {
    //__block ChatModel *chatModel = model;
    [queue addOperationWithBlock:^{
        //__strong ChatModel *chatModel = weakModel;
        ChatBean *bean = [model toBean];
        [[ChatMessageRepository sharedClient] createOrUpdateChat:bean];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Receive_Chat object:model];
           // chatModel = nil;
        });
    }];

}

@end
