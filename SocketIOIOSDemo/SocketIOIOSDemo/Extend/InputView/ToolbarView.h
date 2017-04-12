//
//  ToolbarView.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ToolbarHeight 44.0f

@protocol ToolbarViewDelegate<NSObject>
@required
-(void)sendButtonPressed:(NSString *)inputText;
-(void)addButtonPressed:(BOOL)selected;
-(void)contentTextChanged:(CGFloat)height;
@end

@interface ToolbarView : UIView<UITextViewDelegate>

@property (nonatomic,strong) UIButton *addButton;
//@property (nonatomic,strong) UIButton *soundButton;
//@property (nonatomic,strong) UIButton *emojiButton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UITextView *contentTextView;

@property (nonatomic, weak) id<ToolbarViewDelegate> delegate;

@end
