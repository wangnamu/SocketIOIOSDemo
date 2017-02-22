//
//  PersonBean.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonBean : RLMObject

@property (nonatomic,copy) NSString* SID;// 主键
@property (nonatomic,copy) NSString* UserName;// 用户名
@property (nonatomic,copy) NSString* PassWord;// 密码
@property (nonatomic,copy) NSString* NickName;// 昵称
@property (nonatomic,copy) NSString* HeadPortrait;// 头像

@end
