//
//  ChatMessageModel.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/2.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageBean.h"

@interface ChatMessageModel : NSObject

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

- (ChatMessageBean*)toBean;

+ (ChatMessageModel*)fromBean:(ChatMessageBean*)bean;



@end
