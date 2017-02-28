//
//  ChatPresenterProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//
#import "PersonBean.h"

@protocol ChatPresenterProtocol <NSObject>

@required

@property (nonatomic,strong) NSMutableArray *dataSource;

- (void)loadData;
- (void)createChatWithType:(NSString*)chatType
             ReceivePerson:(PersonBean*)person;
- (void)receiveNotification:(NSNotification*)notification;

@end
