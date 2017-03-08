//
//  SocketIOManager.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "SocketIOManager.h"
#import "UserInfoRepository.h"
#import "MyChat.h"

static NSString* socketUrl = @"http://192.168.19.86:3000";

@implementation SocketIOManager
@synthesize socket;

+ (instancetype)sharedClient {
    
    static SocketIOManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURL* url = [[NSURL alloc] initWithString:socketUrl];
        socket = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
        
        [socket on:@"kickoff" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"kickoff---%@",data);
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Socketio_Kickoff object:nil];
        }];
        
        [socket on:@"notifyotherplatforms" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"notifyotherplatforms---%@",data);
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Socketio_Notifyotherplatforms object:[data objectAtIndex:0]];
        }];
        
        [socket on:@"news" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"news---%@",data);
            if (ack) {
                [ack with:@[@"success"]];
            }
            
            NSDictionary *dic = [[data objectAtIndex:0] mj_JSONObject];
            SocketIOMessage *msg = [SocketIOMessage mj_objectWithKeyValues:dic];
            
            if ([msg.OthersType isEqualToString:OthersTypeChat]) {
                ChatModel *chatModel = [ChatModel mj_objectWithKeyValues:msg.Others];
                [[MyChat sharedClient] receiveChat:chatModel];
            }
            else if ([msg.OthersType isEqualToString:OthersTypeMessage]) {
                ChatMessageModel *chatMessageModel = [ChatMessageModel mj_objectWithKeyValues:msg.Others];
                [[MyChat sharedClient] receiveChatMessage:chatMessageModel];
            }
            
        }];


    }
    return self;
}

- (SocketIOClient*)getSocket {
    return socket;
}

- (BOOL)connect {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"deviceToken"];
    
    UserInfoBean *userInfoBean = [[UserInfoRepository sharedClient] currentUser];
    
    if (deviceToken == nil || userInfoBean == nil) {
        return NO;
    }
    
    
    if(socket != nil) {
        
        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            SocketIOUserInfo *model = [[SocketIOUserInfo alloc] init];
            model.SID = userInfoBean.SID;
            model.UserName = userInfoBean.UserName;
            model.NickName = userInfoBean.NickName;
            
            model.DeviceToken = deviceToken;
            model.Project = @"SocketIODemo";
            model.DeviceType = @"IOS";
            model.LoginTime = (long)[[NSDate date] timeIntervalSince1970];
            
            NSString* json = [model mj_JSONString];
            
            if (socket != nil) {
                [[socket emitWithAck:@"login" with:@[json]] timingOutAfter:30 callback:^(NSArray* args) {
                    NSLog(@"%@",args);
                }];
            }
            
        }];
        
        [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"disconnect---%@",data);
        }];
        
        [socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"reconnect---%@",data);
        }];
        
               

        [socket connect];
        return YES;
    }
    return NO;
}

- (BOOL)disconnect {
    if(socket != nil) {
        [socket disconnect];
    }
    return YES;
}

- (void)notifyOtherPlatforms:(SocketIONotify*)notify {
    if(socket != nil && socket.status == SocketIOClientStatusConnected) {
        NSString* json = [notify mj_JSONString];
        [socket emit:@"notifyotherplatforms" with:@[json]];
    }
}

- (void)sendNews:(SocketIOMessage*)msg {
    if(socket != nil && socket.status == SocketIOClientStatusConnected) {
        NSString* json = [msg mj_JSONString];
        [socket emit:@"news" with:@[json]];
    }
}


@end
