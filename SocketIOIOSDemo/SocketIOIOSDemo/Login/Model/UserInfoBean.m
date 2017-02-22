//
//  UserInfoBean.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "UserInfoBean.h"

@implementation UserInfoBean

//+ (NSString *)primaryKey {
//    return @"SID";
//}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.SID forKey:@"SID"];
    [aCoder encodeObject:self.UserName forKey:@"UserName"];
    [aCoder encodeObject:self.PassWord forKey:@"PassWord"];
    [aCoder encodeObject:self.NickName forKey:@"NickName"];
    [aCoder encodeObject:self.HeadPortrait forKey:@"HeadPortrait"];
    [aCoder encodeObject:@(self.LoginTime) forKey:@"LoginTime"];
    [aCoder encodeObject:@(self.InUse) forKey:@"InUse"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.SID = [aDecoder decodeObjectForKey:@"SID"];
        self.UserName = [aDecoder decodeObjectForKey:@"UserName"];
        self.PassWord = [aDecoder decodeObjectForKey:@"PassWord"];
        self.NickName = [aDecoder decodeObjectForKey:@"NickName"];
        self.HeadPortrait = [aDecoder decodeObjectForKey:@"HeadPortrait"];
        self.LoginTime = [[aDecoder decodeObjectForKey:@"LoginTime"] longValue];
        self.InUse = [[aDecoder decodeObjectForKey:@"InUse"] boolValue];
    }
    return self;
}

@end
