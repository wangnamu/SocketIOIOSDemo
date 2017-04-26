//
//  MainViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/13.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "MainViewController.h"
#import "ChatViewController.h"
#import "ContactViewController.h"
#import "SettingViewController.h"
#import "SocketIOManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initControllers {
    
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    ContactViewController *contactViewController = [[ContactViewController alloc] init];
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    UINavigationController *nv_chat = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    UINavigationController *nv_contact = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    UINavigationController *nv_setting = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    nv_chat.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"message"] selectedImage:[UIImage imageNamed:@"message_selected"]];
    nv_contact.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"people"] selectedImage:[UIImage imageNamed:@"people_selected"]];
    nv_setting.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"setting"] selectedImage:[UIImage imageNamed:@"setting_selected"]];
    
    self.viewControllers = [NSArray arrayWithObjects:nv_chat,nv_contact,nv_setting,nil];
    
}



@end
