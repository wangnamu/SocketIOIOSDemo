//
//  SocketIONotify.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/18.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIONotify : NSObject

@property (nonatomic,copy) NSString* UserID;//用户ID
@property (nonatomic,copy) NSString* SourceDeviceType;//发送方设备类型
@property (nonatomic,copy) NSObject* Others;//其它内容

@end
