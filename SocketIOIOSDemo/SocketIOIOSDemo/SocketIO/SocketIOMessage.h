//
//  SocketIOMessage.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/25.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIOMessage : NSObject

@property (nonatomic,copy) NSString* SID;// 主键
@property (nonatomic,copy) NSString* SenderID;// 发送人ID
@property (nonatomic,strong) NSArray* ReceiverIDs;// 接收人ID
@property (nonatomic,copy) NSString* Title;// 标题
@property (nonatomic,copy) NSString* Body;//内容
@property (nonatomic,assign) long Time;// 时间
@property (nonatomic,copy) NSString* MessageType;// 消息类型(文字、图片、文件、链接、音频、视频、表情等)
@property (nonatomic,assign) BOOL IsAlert;// 提醒
@property (nonatomic,copy) NSString* Category;// 针对ios10和androidN的快捷回复功能

@property (nonatomic,strong) NSObject* object;// 自定义对象

@end
