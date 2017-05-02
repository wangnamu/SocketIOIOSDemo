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

- (instancetype)initWithView:(id<ContactViewProtocol>)view {
    self = [super init];
    if (self) {
        contactView = view;
        dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)loadData {
 
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    RLMResults<ChatBean*> *result = [[ChatMessageRepository sharedClient] getContact];
    for (ChatBean* bean in result) {
        [dataSource addObject:[ChatModel fromBean:bean]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(contactView) {
            [contactView refreshData];
        }
    });
    
    
}



@end




