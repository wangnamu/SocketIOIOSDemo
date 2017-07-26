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
#import "SocketIOResponse.h"

//static NSString* socketUrl = @"http://192.168.16.61:3000";
static NSString* socketUrl = @"http://192.168.19.84:3000";

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
        socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO, @"forceWebsockets": @YES}];
    }
    return self;
}

- (SocketIOClient*)getSocket {
    return socket;
}

- (BOOL)connect:(BOOL)checkStatus {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"deviceToken"];
    
    UserInfoBean *userInfoBean = [[UserInfoRepository sharedClient] currentUser];
    
    if (deviceToken == nil || userInfoBean == nil) {
        return NO;
    }
    
    if(socket != nil) {
        
        if (socket.status == SocketIOClientStatusConnected || socket.status == SocketIOClientStatusConnecting) {
            return NO;
        }
        
        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            NSLog(@"socket connecting");
            
            SocketIOUserInfo *model = [[SocketIOUserInfo alloc] init];
            model.SID = userInfoBean.SID;
            model.UserName = userInfoBean.UserName;
            model.NickName = userInfoBean.NickName;
            
            model.DeviceToken = deviceToken;
            model.CheckStatus = checkStatus;
            model.DeviceType = @"IOS";
            model.LoginTime = [[NSDate date] timeIntervalSince1970] * 1000;
            
            NSString* json = [model mj_JSONString];
            
            if (socket != nil) {
                
                [[socket emitWithAck:@"login" with:@[json]] timingOutAfter:30 callback:^(NSArray* args) {
                    NSLog(@"socket connecting");
                    if (args != nil && args.count > 0) {
                        NSLog(@"login callback ->%@",args);
                        if ([[args firstObject] isEqualToString:@"NO ACK"]) {
                            [socket reconnect];
                        }
                        else {
                            
                            NSDictionary *dic = [[args firstObject] mj_JSONObject];
                            SocketIOResponse *socketIOResponse = [SocketIOResponse mj_objectWithKeyValues:dic];
                            
                            if (socketIOResponse.IsSuccess) {
                                NSLog(@"login success");
                            } else {
                                NSLog(@"login error msg->%@",socketIOResponse.Message);
                                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Socketio_Kickoff object:socketIOResponse.Message];
                            }
                            
                        }
                    }
                }];
 
            }
            
        }];
        
        [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"disconnect---%@",data);
        }];
        
        [socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"reconnect---%@",data);
        }];
        
        [socket on:@"kickoff" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"kickoff---%@",data);
            
            NSDictionary *dic = [[data objectAtIndex:0] mj_JSONObject];
            SocketIOResponse *resp = [SocketIOResponse mj_objectWithKeyValues:dic];
            
            NSLog(@"kickoff msg---%@",resp.Message);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Socketio_Kickoff object:resp.Message];
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
            
            if ([msg.OthersType isEqualToString:OthersTypeMessage]) {
                
                [ChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"SID" : @"SID",
                             @"SenderID" : @"SenderID",
                             @"SenderDeviceToken":@"SenderDeviceToken",
                             @"Title" : @"Title",
                             @"Body" : @"Body",
                             @"Time" : @"Time",
                             @"MessageType" : @"MessageType",
                             @"NickName" : @"NickName",
                             @"HeadPortrait" : @"HeadPortrait",
                             @"ChatID" : @"ChatID",
                             @"Thumbnail" : @"Thumbnail",
                             @"Original" : @"Original",
                             };
                }];
                
                
                ChatMessageModel *chatMessageModel = [ChatMessageModel mj_objectWithKeyValues:msg.Others];
                [[MyChat sharedClient] receiveChatMessage:chatMessageModel];
            }
            
        }];

        [socket connect];
        
        return YES;
    }
    return NO;
}

- (BOOL)disconnect {
    if(socket != nil) {
        [socket disconnect];
        [socket removeAllHandlers];
    }
    return YES;
}

- (void)loginOff {
    UserInfoBean *userInfoBean = [[UserInfoRepository sharedClient] currentUser];
    
    if (userInfoBean == nil) {
        return;
    }
    
    if (socket == nil) {
        return;
    }
    
    SocketIOUserInfo *model = [[SocketIOUserInfo alloc] init];
    model.SID = userInfoBean.SID;
    model.DeviceType = @"IOS";
    
    NSString *json = [model mj_JSONString];
    [socket emit:@"logoff" with:@[json]];
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
