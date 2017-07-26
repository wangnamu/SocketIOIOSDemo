//
//  MessageBean.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SendStatusTypeError = -1,
    SendStatusTypeSending = 0,
    SendStatusTypeSended = 1,
    SendStatusTypeReaded = 2
} SendStatusTypeEnum;

static NSString* const MessageTypeText = @"text";
static NSString* const MessageTypeImage = @"image";
static NSString* const MessageTypeFile = @"file";
static NSString* const MessageTypeUrl = @"url";
static NSString* const MessageTypeSound = @"sound";
static NSString* const MessageTypeMovie = @"movie";
static NSString* const MessageTypeEmoji = @"emoji";


@interface ChatMessageBean : RLMObject

@property NSString* SID;// 主键
@property NSString* SenderID;// 发送人ID
@property NSString* SenderDeviceToken;// 发送人设备编号
@property NSString* Title;// 标题
@property NSString* Body;//内容
@property long Time;// 时间
@property NSString* MessageType;// 消息类型(文字、图片、文件、链接、音频、视频、表情等)

/*--------custom--------*/
@property NSString* NickName;// 真实姓名
@property NSString* HeadPortrait;// 头像
@property NSString* ChatID;// 会话ID
@property NSString* Thumbnail;//缩略图
@property NSString* Original;//原图

@property int SendStatusType;// 发送状态

/*--------local--------*/
@property long LocalTime;

@end
