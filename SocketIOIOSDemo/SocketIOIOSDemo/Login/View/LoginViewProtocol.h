//
//  ILoginView.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol LoginViewProtocol <NSObject>

@required
- (void) loginSuccess;
- (void) loginFail:(NSString*)errorMsg;

@end
