//
//  TabBarViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/12/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()


@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int x=1; x < [[self.tabBar items] count]; x++) {
        [[[self.tabBar items] objectAtIndex:x]setEnabled:FALSE];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
