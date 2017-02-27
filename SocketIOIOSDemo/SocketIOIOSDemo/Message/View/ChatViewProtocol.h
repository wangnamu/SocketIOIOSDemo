//
//  ChatViewProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol ChatViewProtocol <NSObject>

@required
- (void) refreshData;

@optional
- (void)chatPushTo;

@end
