//
//  ViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/1/11.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ViewController.h"
@import SocketIO;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.19.71:3000"];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
    
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSString *str = @"{\"DeviceToken\":\"3asd1053-fb9c-4f99-8bee-505e6da0c9d1\",\"DeviceType\":\"ios\",\"IsOnline\":false,\"LoginTime\":1482729320827,\"NickName\":\"ios\",\"Project\":\"IOSDemo\",\"SID\":\"3\",\"UserName\":\"ios\"}";
        
        if (socket != nil) {
            [[socket emitWithAck:@"login" with:@[str]] timingOutAfter:0 callback:^(NSArray* args) {
                NSLog(@"%@",args);
            }];
        }
        
    }];
    
    
    [socket connect];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
