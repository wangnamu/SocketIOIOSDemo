//
//  ChatBean.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const ChatTypeSingle = @"singleChat";
static NSString* const ChatTypeGroup = @"groupChat";

@interface ChatBean : RLMObject

@property NSString* SID;
@property NSString* Users;
@property NSString* Name;
@property NSString* Img;
@property long Time;
@property long CreateTime;
@property NSString* Body;
@property NSString* ChatType;

//custom in client
@property (nonatomic,assign) BOOL DisplayInRecently;

@end
