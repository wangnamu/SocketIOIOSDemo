//
//  SocketIOManager.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIOUserInfo.h"
#import "SocketIONotify.h"
#import "SocketIOMessage.h"

@import SocketIO;

static NSString* Notification_Socketio_Kickoff = @"socketio_kickoff";
static NSString* Notification_Socketio_Notifyotherplatforms = @"socketio_notifyotherplatforms";
static NSString* Notification_Socketio_News = @"socketio_news";

@interface SocketIOManager : NSObject

@property (nonatomic,strong) SocketIOClient* socket;

+ (instancetype)sharedClient;

- (SocketIOClient*)getSocket;

- (BOOL)connect;
- (BOOL)disconnect;

- (void)notifyOtherPlatforms:(SocketIONotify*)notify;
- (void)sendNews:(SocketIOMessage*)msg;

@end
