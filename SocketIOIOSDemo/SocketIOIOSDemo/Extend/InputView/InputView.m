//
//  InputView.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "InputView.h"


@implementation InputView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.bottomHeight = 0.0f;
    self.toolbarHeight = ToolbarHeight;
    self.status = InputViewStatusNone;
    
    self.toolbarView = [[ToolbarView alloc] init];
    self.toolbarView.delegate = self;
    self.customView = [[CustomView alloc] init];
    self.customView.delegate = self;
  
    
    [self addSubview:self.toolbarView];
    [self addSubview:self.customView];
    
    WS(ws);
    
    [self.toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.toolbarHeight));
        make.top.equalTo(ws.mas_top);
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
    }];
    
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.height.equalTo(@(0.0f));
        make.top.equalTo(ws.toolbarView.mas_bottom);
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    
}

- (void)addButtonPressed:(BOOL)selected {
    
    if (selected) {
        self.status = InputViewStatusCustom;
        self.bottomHeight = CustomViewHeight;
//        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(172.0f));
//        }];
    }
    else {
        self.status = InputViewStatusNone;
        self.bottomHeight = 0.0f;
//        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(0.0f));
//        }];
    }
    if ([self.toolbarView.contentTextView isFirstResponder]) {
        [self.toolbarView.contentTextView resignFirstResponder];
    }
    else {
        if ([delegate respondsToSelector:@selector(inputViewHeightChanged:)]) {
            [delegate inputViewHeightChanged:self.toolbarHeight + self.bottomHeight];
        }
    }
    
}


- (void)contentTextChanged:(CGFloat)height {
    
    self.toolbarHeight = height;
    if ([delegate respondsToSelector:@selector(inputViewHeightChanged:)]) {
        if (self.status == InputViewStatusNone) {
            [delegate inputViewHeightChanged:height];
        }
        else {
            [delegate inputViewHeightChanged:height + self.bottomHeight];
        }
    }
    
}

- (void)sendButtonPressed:(NSString *)inputText {
    if ([delegate respondsToSelector:@selector(doSend:)]) {
        [delegate doSend:inputText];
    }
}


- (void)resetStatus {
    [self.toolbarView.addButton setSelected:NO];
    self.status = InputViewStatusNone;
    self.bottomHeight = 0.0f;
//    [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(0.0f));
//    }];
}

- (void)customButtonPressed:(NSInteger)tag {
    if ([delegate respondsToSelector:@selector(doCustomButtonPressed:)]) {
        [delegate doCustomButtonPressed:tag];
    }
}


@end
