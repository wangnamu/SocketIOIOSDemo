//
//  ChatBean.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatBean : RLMObject

@property (nonatomic,strong) NSString* SID;
@property (nonatomic,strong) NSString* SenderID;
@property (nonatomic,strong) NSString* Name;
@property (nonatomic,strong) NSString* ReceiverIDS;
@property (nonatomic,strong) NSString* Img;
@property (nonatomic,assign) long Time;
@property (nonatomic,strong) NSString* Body;
@property (nonatomic,strong) NSString* ChatType;

@end
