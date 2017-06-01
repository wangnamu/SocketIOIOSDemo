//
//  ContactPresenter.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ContactPresenter.h"
#import "UserInfoRepository.h"
#import "ChatMessageRepository.h"
#import "ChatModel.h"

@implementation ContactPresenter
@synthesize contactView,dataSource;
@synthesize queue,sem;

- (instancetype)initWithView:(id<ContactViewProtocol>)view {
    self = [super init];
    if (self) {
        contactView = view;
        dataSource = [[NSMutableArray alloc] init];
        
        queue = dispatch_queue_create("com.ufo.socketio.contactQueue", NULL);
        sem = dispatch_semaphore_create(0);
        
    }
    return self;
}


- (void)loadData {
 
    dispatch_barrier_async(queue,^{
        
        NSArray *result = [[ChatMessageRepository sharedClient] getContact];
        
        if(contactView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataSource.count > 0) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:result];
                [contactView refreshData];
                
                dispatch_semaphore_signal(sem);
            });
        } else {
            dispatch_semaphore_signal(sem);
        }

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    
}



@end




