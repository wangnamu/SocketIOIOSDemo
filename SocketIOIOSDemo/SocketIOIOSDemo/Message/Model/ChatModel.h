//
//  ChatModel.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/1.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBean.h"

@interface ChatModel : NSObject

@property (nonatomic,copy) NSString* SID;
@property (nonatomic,copy) NSString* Users;
@property (nonatomic,copy) NSString* Name;
@property (nonatomic,copy) NSString* Img;
@property (nonatomic,assign) long Time;
@property (nonatomic,assign) long CreateTime;
@property (nonatomic,copy) NSString* Body;
@property (nonatomic,copy) NSString* ChatType;

//custom in client
@property (nonatomic,assign) BOOL DisplayInRecently;

- (ChatBean*)toBean;

+ (ChatModel*)fromBean:(ChatBean*)bean;


@end
