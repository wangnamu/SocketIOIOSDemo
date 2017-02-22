//
//  ILoginPresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/10.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol LoginPresenterProtocol <NSObject>

@required
- (void) loginUserName:(NSString*)username
              PassWord:(NSString*)password;

@end

