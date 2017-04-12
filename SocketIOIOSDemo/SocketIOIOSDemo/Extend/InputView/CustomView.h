//
//  CustomView.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/3/27.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CustomViewHeight 212.0f

typedef enum {
    CustomKeyboardButtonAudio = 0,
    CustomKeyboardButtonCamera = 1,
    CustomKeyboardButtonContact = 2,
    CustomKeyboardButtonFile = 3,
    CustomKeyboardButtonLocation = 4,
    CustomKeyboardButtonPhoto = 5,
    CustomKeyboardButtonQzone = 6
} CustomKeyboardButtonEnum;

@protocol CustomViewDelegate<NSObject>
@required
-(void)customButtonPressed:(NSInteger)tag;
@end


@interface CustomView : UIView

@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,weak) id<CustomViewDelegate> delegate;

@end
