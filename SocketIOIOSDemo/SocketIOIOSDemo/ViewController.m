//
//  ViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/11.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ViewController.h"
#import "SocketIOManager.h"
#import "MJExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 140)];
    [btn1 setTitle:@"notifyOtherPlatforms" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blackColor]];
    [btn1 addTarget:self action:@selector(notify:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNews:) name:Notification_Socketio_News object:nil];
    
}

- (void)notify:(id)sender {
    SocketIONotify* socketIONotify = [[SocketIONotify alloc] init];
    [socketIONotify setUserID:@"001"];
    [socketIONotify setSourceDeviceType:@"IOS"];
    [[SocketIOManager sharedClient] notifyOtherPlatforms:socketIONotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNews:(NSNotification*)notification {
    NSLog(@"1-%@",notification);
    
    NSDictionary *dic = [[notification userInfo] mj_JSONObject];
    NSLog(@"2-%@",dic);
    
    SocketIOMessage *msg = [SocketIOMessage mj_objectWithKeyValues:dic];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg.Title message:msg.Body delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
