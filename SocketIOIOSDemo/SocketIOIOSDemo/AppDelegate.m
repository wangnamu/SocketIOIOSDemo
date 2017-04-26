//
//  AppDelegate.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/11.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "AppDelegate.h"
#import "SocketIOManager.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "UserInfoRepository.h"
#import "MyChat.h"
#import "RealmConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initHUD];
    
    [self registerNotification];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UserInfoRepository sharedClient] currentUser] != nil) {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        self.window.rootViewController = mainViewController;
    }
    else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        self.window.rootViewController = loginViewController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[SocketIOManager sharedClient] disconnect];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UserInfoBean *bean = [[UserInfoRepository sharedClient] currentUser];
    if (bean != nil) {
        [RealmConfig setUp:bean.UserName];
        [[MyChat sharedClient] getRecent];
        [[SocketIOManager sharedClient] connect];
    }
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- 获取device Token

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken===========%@",deviceString);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"deviceToken"] == nil) {
        [userDefaults setObject:deviceString forKey:@"deviceToken"];
        [userDefaults synchronize];
        [[SocketIOManager sharedClient] connect];
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"receiveRemote:%@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    /*
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
        
    } else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    */
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    
    if ([categoryIdentifier isEqualToString:@"custom"]) {//识别需要被处理的拓展
        
        if ([response.actionIdentifier isEqualToString:@"reply"]) {//识别用户点击的是哪个 action
            
            //假设点击了输入内容的 UNTextInputNotificationAction 把 response 强转类型
            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
            //获取输入内容
            NSString *userText = textResponse.userText;
            //发送 userText 给需要接收的方法
            NSLog(@"%@",userText);
            
        }
        else {
            NSLog(@"not reply");
        }
        
    }

    completionHandler(); // 系统要求执行这个方法
    
}


- (void)registerNotification {
    
    if (SYSTEM_VERSION >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    if(SYSTEM_VERSION >= 10.0) {
        UNTextInputNotificationAction *action = [UNTextInputNotificationAction actionWithIdentifier:@"reply" title:@"回复" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"发送" textInputPlaceholder:@"请输入文字..."];
        
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"custom" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            //        if (!error && granted) {
            //            //用户点击允许
            //            NSLog(@"注册成功");
            //        } else {
            //            //用户点击不允许
            //            NSLog(@"注册失败");
            //        }
        }];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
}


- (void)initHUD {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
   
}


@end
