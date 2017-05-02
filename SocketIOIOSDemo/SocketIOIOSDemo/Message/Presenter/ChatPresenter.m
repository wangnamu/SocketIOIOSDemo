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

- (instancetype)initWithView:(id<ChatViewProtocol>)view {
    self = [super init];
    if (self) {
        chatView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)updateChat {
    
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    RLMResults<ChatBean*> *result = [[ChatMessageRepository sharedClient] getChat];
    for (ChatBean *bean in result) {
        [dataSource addObject:[ChatModel fromBean:bean]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(chatView) {
            [chatView refreshData];
        }
    });
    
}




@end
