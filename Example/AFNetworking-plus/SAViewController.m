//
//  SAViewController.m
//  AFNetworking-plus
//
//  Created by acct<blob>=<NULL> on 01/05/2023.
//  Copyright (c) 2023 acct<blob>=<NULL>. All rights reserved.
//

#import "SAViewController.h"
#import "CCNetworkManager.h"

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    for (NSInteger i=0; i<1000; i++) {
        [CCNetworkManager GET:@"https://m.baidu.com/sf/vsearch/image/user/logininfo?src=mobile&page=search" params:nil success:nil failure:nil];
    }
    NSLog(@"===================");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
