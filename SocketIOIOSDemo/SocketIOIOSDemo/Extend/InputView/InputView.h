//
//  InputView.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolbarView.h"
#import "CustomView.h"

typedef enum {
    InputViewStatusNone = 0,
    InputViewStatusCustom = 1
} InputViewStatusTypeEnum;


@protocol InputViewDelegate<NSObject>
@required
-(void)doSend:(NSString *)inputText;
-(void)doCustomButtonPressed:(NSInteger)tag;
-(void)inputViewHeightChanged:(CGFloat)height;
@end


@interface InputView : UIView<ToolbarViewDelegate,CustomViewDelegate>

@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) CGFloat bottomHeight;
@property (nonatomic,assign) CGFloat toolbarHeight;

@property (nonatomic,strong) ToolbarView* toolbarView;
@property (nonatomic,strong) CustomView* customView;

@property (nonatomic,weak) id<InputViewDelegate> delegate;

- (void)resetStatus;

@end
