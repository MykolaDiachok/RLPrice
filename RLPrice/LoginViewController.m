//
//  LoginViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/12/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface LoginViewController ()



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _txtLogin.text = [defaults valueForKey:@"login"];
    _txtPassword.text = [defaults valueForKey:@"password"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clkLogin {
    
    
    [PFUser logInWithUsernameInBackground:_txtLogin.text password:_txtPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"%@",@"Login YES");
                                            [PFConfig getConfigInBackground];
                                            PFUser *currentUser = [PFUser currentUser];
                                            if ((currentUser)&&(currentUser[@"Enable"])) {
                                                NSLog(@"%@",@"User Enable");
                                                [currentUser incrementKey:@"RunCount"];
                                                [currentUser saveInBackground];
												[PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
                                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                [userDefaults setValue:_txtPassword.text forKey:@"password"];
                                                [userDefaults setValue:_txtLogin.text forKey:@"login"];
                                                
                                                [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:YES];
                                                for (int x=1; x < [[[self.tabBarController tabBar] items] count]; x++) {
                                                    [[[[self.tabBarController tabBar]  items] objectAtIndex:x]setEnabled:TRUE];
                                                }
                                                NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:[self.tabBarController viewControllers]];
                                                [tbViewControllers removeObjectAtIndex:0];
                                                [self.tabBarController setViewControllers:tbViewControllers];
                                                
                                            } else {
                                                NSLog(@"%@",@"User Disable");
                                            }
                                            
                                        } else {
                                            NSLog(@"%@",@"Login NO");
                                        }
                                    }];
}



@end
