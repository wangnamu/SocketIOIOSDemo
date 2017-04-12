//
//  ToolbarView.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ToolbarView.h"

#define MAX_HEIGHT 100.0f

@implementation ToolbarView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat w = 1.f;
    
    CALayer *layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(0, 0, rect.size.width, w);
    layerTop.backgroundColor = COLOR_FROM_RGB(0xdfdfdf).CGColor;
    [self.layer addSublayer:layerTop];
    
    CALayer *layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, rect.size.height - 1.0f, rect.size.width,w);
    layerBottom.backgroundColor = COLOR_FROM_RGB(0xebebed).CGColor;
    [self.layer addSublayer:layerBottom];
}

- (void)setUp {
    
    self.backgroundColor = COLOR_FROM_RGB(0xf3f3f5);
    
    self.addButton = [[UIButton alloc] init];
    
    [self.addButton setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"keyboard_normal"] forState:UIControlStateSelected];

    [self.addButton addTarget:self action:@selector(doChangeKeyborad:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:14.0f];
    self.contentTextView.delegate = self;
    self.contentTextView.returnKeyType = UIReturnKeySend;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    
    self.contentTextView.layer.borderColor = COLOR_FROM_RGB(0xdcdcdc).CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.layer.cornerRadius = 5.0;
    
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setImage:[UIImage imageNamed:@"send_normal"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(doSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.addButton];
    [self addSubview:self.contentTextView];
    [self addSubview:self.sendButton];
    
    
    WS(ws);
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(24.0f));
        make.width.equalTo(@(24.0f));
        make.left.equalTo(ws.mas_left).offset(8.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-10.0f);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(24.0f));
        make.width.equalTo(@(24.0f));
        make.right.equalTo(ws.mas_right).offset(-8.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-10.0f);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.addButton.mas_right).offset(8.0f);
        make.right.equalTo(ws.sendButton.mas_left).offset(-8.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-5.5f);
        make.height.equalTo(@(32.0f));
    }];

    
}


- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat txtheight = ceilf([textView sizeThatFits:CGSizeMake(textView.bounds.size.width, MAXFLOAT)].height);
    
    CGFloat height = txtheight + 1.0f + 2*5.0f;
    
    if (height < MAX_HEIGHT) {
        [self.contentTextView setScrollEnabled:NO];
        [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(txtheight));
        }];
        
        if ([delegate respondsToSelector:@selector(contentTextChanged:)]) {
            [delegate contentTextChanged:height];
        }
    }
    else {
        [self.contentTextView setScrollEnabled:YES];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [self doSend:nil];
        return NO;
    }
    return YES;
}


- (void)doChangeKeyborad:(UIButton*)sender {
    sender.selected = !sender.selected;

    if ([delegate respondsToSelector:@selector(addButtonPressed:)]) {
        [delegate addButtonPressed:sender.selected];
    }
    
}


- (void)doSend:(UIButton*)sender {
    
    if([self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return;
    }
    
    if ([delegate respondsToSelector:@selector(sendButtonPressed:)]) {
        [delegate sendButtonPressed:self.contentTextView.text];
        self.contentTextView.text = nil;
        [self textViewDidChange:self.contentTextView];
    }
    
}


@end
