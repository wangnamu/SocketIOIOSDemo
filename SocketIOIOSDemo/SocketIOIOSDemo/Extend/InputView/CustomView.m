//
//  CustomView.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    
    self.backgroundColor = COLOR_FROM_RGB(0xf3f3f5);
    
    UIButton *btn1 = [[UIButton alloc] init];
    UIButton *btn2 = [[UIButton alloc] init];
    UIButton *btn3 = [[UIButton alloc] init];
    UIButton *btn4 = [[UIButton alloc] init];
    UIButton *btn5 = [[UIButton alloc] init];
    UIButton *btn6 = [[UIButton alloc] init];
    UIButton *btn7 = [[UIButton alloc] init];
    
    self.buttonArray = [NSArray arrayWithObjects:btn1,btn2,btn3,btn4,btn5,btn6,btn7,nil];
    
    for (UIButton *button in self.buttonArray) {
        [self addSubview:button];
    }
    
}



- (void)updateConstraints {
    
    CGFloat w = 1.f;
    
    CALayer *layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, w);
    layerTop.backgroundColor = COLOR_FROM_RGB(0xdfdfdf).CGColor;
    [self.layer addSublayer:layerTop];

    [self layoutButtons:self.buttonArray inView:self width:72.0f row:2 column:4];
    
    [self remakeButton:[self.buttonArray objectAtIndex:0] ImageName:@"icon_camera" TitleText:@"拍照" Tag:CustomKeyboardButtonAudio];
    [self remakeButton:[self.buttonArray objectAtIndex:1] ImageName:@"icon_photo" TitleText:@"图片" Tag:CustomKeyboardButtonPhoto];
    [self remakeButton:[self.buttonArray objectAtIndex:2] ImageName:@"icon_audio" TitleText:@"视频" Tag:CustomKeyboardButtonCamera];
    [self remakeButton:[self.buttonArray objectAtIndex:3] ImageName:@"icon_qzone" TitleText:@"空间" Tag:CustomKeyboardButtonQzone];
    [self remakeButton:[self.buttonArray objectAtIndex:4] ImageName:@"icon_contact" TitleText:@"联系人" Tag:CustomKeyboardButtonContact];
    [self remakeButton:[self.buttonArray objectAtIndex:5] ImageName:@"icon_file" TitleText:@"文件" Tag:CustomKeyboardButtonFile];
    [self remakeButton:[self.buttonArray objectAtIndex:6] ImageName:@"icon_location" TitleText:@"位置" Tag:CustomKeyboardButtonLocation];
    
    [super updateConstraints];
}


- (void)layoutButtons:(NSArray *)buttons
               inView:(UIView *)containerView
                width:(CGFloat)width
                  row:(NSInteger)row
               column:(NSInteger)column {
    
    CGFloat pd_width = (SCREEN_WIDTH - column * width)/(column + 1);
    CGFloat pd_height = (CustomViewHeight - row * width)/(row + 1);
    
    for (int i=0;i<buttons.count;i++) {
        
        UIButton *btn = [buttons objectAtIndex:i];
        int r = i/4 == 0 ? 1 : i/4;
        CGFloat pdh = r*pd_height + (i/4)*(width+pd_height);
        
        if (i % 4 == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.height.equalTo(@(width));
                make.left.equalTo(containerView.mas_left).with.offset(pd_width);
                make.top.equalTo(containerView.mas_top).with.offset(pdh);
            }];
        }
        else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.height.equalTo(@(width));
                make.left.equalTo([[buttons objectAtIndex:i-1] mas_right]).with.offset(pd_width);
                make.centerY.equalTo([[buttons objectAtIndex:i-1] mas_centerY]);
            }];
        }
        
    }
  
}


- (void)remakeButton:(UIButton*)button
           ImageName:(NSString*)imageName
           TitleText:(NSString*)titleText
                 Tag:(NSInteger)tag {

    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:titleText forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    CGSize imageSize = button.imageView.frame.size;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(-12.0f, (button.frame.size.width -imageSize.width)/2, 0, 0);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height + 12.0f , -imageSize.width, 0, 0);
    
    [button setTag:tag];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
}

- (void)btnClick:(UIButton*)sender {
    if ([delegate respondsToSelector:@selector(customButtonPressed:)]) {
        [delegate customButtonPressed:sender.tag];
    }
}


@end
