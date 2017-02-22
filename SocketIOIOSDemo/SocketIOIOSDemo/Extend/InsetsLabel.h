//
//  InsetsLabel.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/20.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end
