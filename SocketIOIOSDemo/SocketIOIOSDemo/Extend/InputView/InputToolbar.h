//
//  InputToolbar.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/13.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

#define InputToolbarHeight 49.0f

@protocol InputToolbarDelegate<NSObject>
@required
-(void)sendButtonPressed:(NSString *)inputText;
-(void)contentTextChanged:(CGFloat)height;
-(void)customButtonPressed:(NSInteger)tag;
@end

@interface InputToolbar : UIView<UITextViewDelegate,CustomViewDelegate> {
    CALayer *_layerTop;
    CALayer *_layerBottom;
}

@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) CustomView *customView;

@property (nonatomic, weak) id<InputToolbarDelegate> delegate;

-(void)changeKeyboradNormal;

@end

