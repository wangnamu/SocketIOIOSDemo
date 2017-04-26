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

@property (nonatomic,strong) NSString* SID;
@property (nonatomic,strong) NSString* Users;
@property (nonatomic,strong) NSString* Name;
@property (nonatomic,strong) NSString* Img;
@property (nonatomic,assign) long Time;
@property (nonatomic,strong) NSString* Body;
@property (nonatomic,strong) NSString* ChatType;

//custom in client
@property (nonatomic,assign) BOOL DisplayInRecently;

@end
