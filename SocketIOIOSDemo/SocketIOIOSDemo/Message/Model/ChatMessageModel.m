//
//  ChatMessageModel.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/2.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatMessageModel.h"
#import "UserInfoRepository.h"

@implementation ChatMessageModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.SendStatusType = SendStatusTypeSended;
    }
    return self;
}

- (BOOL)isHost {
    if([[UserInfoRepository sharedClient] currentUser] != nil){
        NSString *currentUserID = [[UserInfoRepository sharedClient] currentUser].SID;
        if ([currentUserID isEqualToString:self.SenderID]) {
            return YES;
        }
    }
    return NO;
}


- (ChatMessageBean*)toBean {
    ChatMessageBean *bean = [[ChatMessageBean alloc] init];
    bean.SID = self.SID;
    bean.SenderID = self.SenderID;
    bean.Title = self.Title;
    bean.Body = self.Body;
    bean.Time = self.Time;
    bean.MessageType = self.MessageType;
    bean.NickName = self.NickName;
    bean.HeadPortrait = self.HeadPortrait;
    bean.ChatID = self.ChatID;
    bean.Thumbnail = self.Thumbnail;
    bean.Original = self.Original;
    bean.SendStatusType = self.SendStatusType;
    bean.LocalTime = self.LocalTime;
    return bean;
}

+ (ChatMessageModel*)fromBean:(ChatMessageBean*)bean {
    ChatMessageModel *model = [[ChatMessageModel alloc] init];
    model.SID = bean.SID;
    model.SenderID = bean.SenderID;
    model.Title = bean.Title;
    model.Body = bean.Body;
    model.Time = bean.Time;
    model.MessageType = bean.MessageType;
    model.NickName = bean.NickName;
    model.HeadPortrait = bean.HeadPortrait;
    model.ChatID = bean.ChatID;
    model.Thumbnail = bean.Thumbnail;
    model.Original = bean.Original;
    model.SendStatusType = bean.SendStatusType;
    model.LocalTime = bean.LocalTime;
    return model;
}


- (BOOL)isEqual:(id)object {
    if (self == object) {
        return true;
    }
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    
    ChatMessageModel* myObject = object;
    if ([self.SID isEqualToString:myObject.SID]) {
        return true;
    }
    
    return false;
}


@end
