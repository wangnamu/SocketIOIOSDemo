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

@property (nonatomic,copy) NSString* SID;// 主键
@property (nonatomic,copy) NSString* SenderID;// 发送人ID
@property (nonatomic,copy) NSString* Title;// 标题
@property (nonatomic,copy) NSString* Body;//内容
@property (nonatomic,assign) long Time;// 时间
@property (nonatomic,copy) NSString* MessageType;// 消息类型(文字、图片、文件、链接、音频、视频、表情等)

/*--------custom--------*/
@property (nonatomic,copy) NSString* NickName;// 真实姓名
@property (nonatomic,copy) NSString* HeadPortrait;// 头像
@property (nonatomic,copy) NSString* ChatID;// 会话ID
@property (nonatomic,copy) NSString* Thumbnail;//缩略图
@property (nonatomic,copy) NSString* Original;//原图

@property (nonatomic,assign) int SendStatusType;// 发送状态



- (BOOL)isHost;

- (void)fromA;

@end
