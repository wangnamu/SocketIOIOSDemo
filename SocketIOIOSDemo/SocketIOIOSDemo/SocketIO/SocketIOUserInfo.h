//
//  SocketIOUserInfo.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIOUserInfo : NSObject

@property (nonatomic,copy) NSString* SID;// 主键
@property (nonatomic,copy) NSString* UserName;// 用户名
@property (nonatomic,copy) NSString* NickName;// 真实姓名
@property (nonatomic,assign) long LoginTime;// 最近一次登录时间
@property (nonatomic,copy) NSString* DeviceType;// 设备类型
@property (nonatomic,copy) NSString* DeviceToken;// 设备证书
@property (nonatomic,assign) BOOL CheckStatus;// 检查是否已经在其它移动设备上登录过

@end
