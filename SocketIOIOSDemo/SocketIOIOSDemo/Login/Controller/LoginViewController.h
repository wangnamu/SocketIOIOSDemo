//
//  LoginViewController.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    BOOL _isKickedOff;
    NSString* _message;
}

- (instancetype)init;

- (instancetype)initWithIsKickedOff:(BOOL)isKickedOff
                            Message:(NSString*)message;

@end
