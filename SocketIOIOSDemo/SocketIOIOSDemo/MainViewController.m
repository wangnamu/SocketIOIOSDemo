//
//  MainViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/13.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "MainViewController.h"
#import "ChatViewController.h"
#import "PersonListViewController.h"
#import "SettingViewController.h"
#import "SocketIOManager.h"
#import "MyChat.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    
    [[MyChat sharedClient] getRecent];
    [[SocketIOManager sharedClient] connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initControllers {
    
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    PersonListViewController *personListViewController = [[PersonListViewController alloc] init];
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    UINavigationController *nv_chat = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    UINavigationController *nv_personList = [[UINavigationController alloc] initWithRootViewController:personListViewController];
    UINavigationController *nv_setting = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    nv_chat.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"ic_hidden"] selectedImage:[UIImage imageNamed:@"ic_hidden_selected"]];
    nv_personList.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"ic_hidden"] selectedImage:[UIImage imageNamed:@"ic_hidden_selected"]];
    nv_setting.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"ic_hidden"] selectedImage:[UIImage imageNamed:@"ic_hidden_selected"]];
    
    self.viewControllers = [NSArray arrayWithObjects:nv_chat,nv_personList,nv_setting,nil];
    
}



@end
