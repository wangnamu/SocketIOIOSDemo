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

static NSString* const Notification_Socketio_Kickoff = @"socketio_kickoff";
static NSString* const Notification_Socketio_Notifyotherplatforms = @"socketio_notifyotherplatforms";
//static NSString* const Notification_Socketio_News = @"socketio_news";


static NSString* const OthersTypeChat = @"chat";
static NSString* const OthersTypeMessage = @"message";


@interface SocketIOManager : NSObject

@property (nonatomic,strong) SocketIOClient* socket;

+ (instancetype)sharedClient;

- (SocketIOClient*)getSocket;

- (BOOL)connect:(BOOL)checkStatus;
- (BOOL)disconnect;

- (void)loginOff;

- (void)notifyOtherPlatforms:(SocketIONotify*)notify;
- (void)sendNews:(SocketIOMessage*)msg;

@end
