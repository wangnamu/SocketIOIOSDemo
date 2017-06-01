//
//  ChatPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatPresenter.h"
#import "ChatModel.h"
#import "ChatMessageBean.h"
#import "ChatMessageRepository.h"
#import "UserInfoRepository.h"
#import "SocketIOManager.h"
#import "MyChat.h"

@implementation ChatPresenter
@synthesize chatView,dataSource;
@synthesize queue,sem;

- (instancetype)initWithView:(id<ChatViewProtocol>)view {
    self = [super init];
    if (self) {
        chatView = view;
        dataSource = [[NSMutableArray alloc] init];
        
        queue = dispatch_queue_create("com.ufo.socketio.chatQueue", NULL);
        sem = dispatch_semaphore_create(0);
        
    }
    return self;
}

- (void)updateChat {
    
    dispatch_barrier_async(queue,^{
 
        NSArray *result = [[ChatMessageRepository sharedClient] getChat];
        
        if(chatView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataSource.count > 0) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:result];
                [chatView refreshData];
                
                dispatch_semaphore_signal(sem);
            });
        } else {
            dispatch_semaphore_signal(sem);
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    });
    
}




@end
