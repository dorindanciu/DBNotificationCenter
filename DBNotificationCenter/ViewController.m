//
//  ViewController.m
//  DBNotificationCenter
//
//  Created by Dorin Danciu on 10/7/12.
//  Copyright (c) 2012 Dorin Danciu. All rights reserved.
//

#import "ViewController.h"
#import "NotificationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NotificationViewController *notif = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    [notif setIsSlideActionAvailable:YES];
    [self.view addSubview:notif.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
