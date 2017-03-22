//
//  InputToolbar.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "InputToolbar.h"

#define MAX_HEIGHT 110.0f

@implementation InputToolbar
@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 24.0f;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = COLOR_FROM_RGB(0xcdccce).CGColor;
    self.layer.borderWidth = 0.5f;

}

- (void)setUp {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.addButton = [[UIButton alloc] init];
    [self.addButton setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"keyboard_normal"] forState:UIControlStateSelected];
    
    [self.addButton addTarget:self action:@selector(doChangeKeyborad:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:14.0f];
    self.contentTextView.delegate = self;
    self.contentTextView.returnKeyType = UIReturnKeySend;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    
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
        make.left.equalTo(ws.mas_left).offset(16.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-13.0f);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(24.0f));
        make.width.equalTo(@(24.0f));
        make.right.equalTo(ws.mas_right).offset(-16.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-13.0f);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.addButton.mas_right).offset(8.0f);
        make.right.equalTo(ws.sendButton.mas_left).offset(-8.0f);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-7.5f);
        make.height.equalTo(@(35.0f));
    }];
    
}


- (void)textViewDidChange:(UITextView *)textView {

    CGFloat txtheight = ceilf([textView sizeThatFits:CGSizeMake(textView.bounds.size.width, MAXFLOAT)].height);

    CGFloat height = txtheight + 2.0f + 2*7.5f;
    
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

    if (sender.selected) {
        if (_customKeyborad == nil) {
            _customKeyborad = [self makeCustomKeyborad];
        }
        _customKeyborad.hidden = NO;
        self.contentTextView.inputView = _customKeyborad;
        [self.contentTextView reloadInputViews];
    }
    else {
        self.contentTextView.inputView = nil;
        [self.contentTextView reloadInputViews];
    }
    
    [self.contentTextView becomeFirstResponder];
    
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

- (UIView*)makeCustomKeyborad {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, 0)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *v1 = [[UIButton alloc] init];
    v1.backgroundColor = [UIColor redColor];
    UIButton *v2 = [[UIButton alloc] init];
    v2.backgroundColor = [UIColor greenColor];
    UIButton *v3 = [[UIButton alloc] init];
    v3.backgroundColor = [UIColor yellowColor];
    UIButton *v4 = [[UIButton alloc] init];
    v4.backgroundColor = [UIColor blueColor];
    UIButton *v5 = [[UIButton alloc] init];
    v5.backgroundColor = [UIColor orangeColor];
    UIButton *v6 = [[UIButton alloc] init];
    v6.backgroundColor = [UIColor purpleColor];
    
    NSArray *array = [NSArray arrayWithObjects:v1,v2,v3,v4,v5,v6, nil];
    
    CGFloat height = [self makeEqualWidthViews:array inView:view lrPadding:16.0f viewPadding:16.0f column:4];
    
    view.frame = CGRectMake(0, self.superview.frame.size.height - height, self.superview.frame.size.width, height);
    
    return view;
}

- (CGFloat)makeEqualWidthViews:(NSArray *)views
                     inView:(UIView *)containerView
                  lrPadding:(CGFloat)lrPadding
                viewPadding:(CGFloat)viewPadding
                     column:(NSInteger)column {

    int width = containerView.frame.size.width - 2*lrPadding;
    int cellWH = (width - (column-1)*viewPadding) / column;
    
    int row = 0;
    int col = 0;
    
    for (int i=0; i<views.count; i++) {
        
        row = 0;
        col = i;
        
        if (col > column-1) {
            col = i % column;
            row += 1;
        }
        
        int x = lrPadding + col*cellWH + col*viewPadding;
        int y = row*cellWH + (row+1)*viewPadding;
        
        
        [[views objectAtIndex:i] setFrame:CGRectMake(x, y, cellWH, cellWH)];
        [containerView addSubview:[views objectAtIndex:i]];
    }
    
    return viewPadding*2 + (row+1)*cellWH + row*viewPadding;
}



@end
