//
//  InputToolbar.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputToolbarDelegate<NSObject>
@required
-(void)sendButtonPressed:(NSString *)inputText;
-(void)contentTextChanged:(CGFloat)height;
@end

@interface InputToolbar : UIView<UITextViewDelegate>
{
    UIView *_customKeyborad;
}

@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UITextView *contentTextView;


@property (nonatomic, weak) id<InputToolbarDelegate> delegate;


@end
