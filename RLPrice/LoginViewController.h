//
//  LoginViewController.h
//  RLPrice
//
//  Created by Mikola Dyachok on 9/12/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end
