//
//  SignUpViewController.h
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
- (IBAction)backToLogin:(id)sender;
- (IBAction)signUp:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *email;

@end
