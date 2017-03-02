//
//  ChatModel.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/1.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (ChatBean*)toBean {
    ChatBean* bean = [[ChatBean alloc] init];
    bean.SID = self.SID;
    bean.Users = self.Users;
    bean.Name = self.Name;
    bean.Img = self.Img;
    bean.Time = self.Time;
    bean.Body = self.Body;
    bean.ChatType = self.ChatType;
    return bean;
}

+ (ChatModel *)fromBean:(ChatBean *)bean {
    ChatModel* model = [[ChatModel alloc] init];
    model.SID = bean.SID;
    model.Users = bean.Users;
    model.Name = bean.Name;
    model.Img = bean.Img;
    model.Time = bean.Time;
    model.Body = bean.Body;
    model.ChatType = bean.ChatType;
    return model;
}

@end
