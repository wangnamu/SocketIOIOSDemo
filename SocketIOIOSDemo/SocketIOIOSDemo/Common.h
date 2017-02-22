//
//  Common.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/10.
//  Copyright © 2017年 ufo. All rights reserved.
//

#ifndef Common_h
#define Common_h


#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAV_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

//判断当前系统版本
#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//获取系统版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//弱引用/强引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//获取屏幕宽度与高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//获取屏幕分辨率
#define RESOLUTION_WIDTH SCREEN_WIDTH * [UIScreen mainScreen].scale
#define RESOLUTION_HEIGHT SCREEN_HEIGHT * [UIScreen mainScreen].scale

//RGB颜色转换（16进制->10进制）
#define COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//设置RGB颜色
#define COLOR_WITH_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//设置RGBA颜色
#define COLOR_WITH_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//获取当前语言
#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//判断是否横屏
#define IS_LANDSCAPE  (DEVICE_HEIGHT < DEVICE_WIDTH) ? YES : NO

//判断对象是否为空
#define IS_NULL(obj) obj == nil ? YES : (obj == (id)[NSNull null] ? YES : NO)
#define IS_NOT_NULL(obj) obj != nil ? (obj != (id)[NSNull null] ? YES : NO) : NO


#endif /* Common_h */
