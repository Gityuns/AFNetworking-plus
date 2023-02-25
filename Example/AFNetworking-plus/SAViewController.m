//
//  SAViewController.m
//  AFNetworking-plus
//
//  Created by acct<blob>=<NULL> on 01/05/2023.
//  Copyright (c) 2023 acct<blob>=<NULL>. All rights reserved.
//

#import "SAViewController.h"
#import "CCNetworkManager.h"
#import "SVProgressHUD.h"

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [CCNetworkManager defaultManager].configLoadingHUD = ^{
        [SVProgressHUD showWithStatus:nil];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
