//
//  LoginViewController.h
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;

- (IBAction)signUp:(id)sender;
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end
