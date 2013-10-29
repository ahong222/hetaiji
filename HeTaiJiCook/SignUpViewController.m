//
//  SignUpViewController.m
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userName.delegate=self;
    self.password.delegate=self;
    self.email.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed sign up view controller");
    }];
}

- (IBAction)signUp:(id)sender {
    NSString *userNameStr=self.userName.text;
    NSString *passWordStr=self.password.text;
    NSString *emailStr=self.email.text;
    
    //todo 为空验证
    
    PFUser *user=[PFUser user];
    user.username=userNameStr;
    user.password=passWordStr;
    user.email=emailStr;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded!=YES){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
//            UIAlertViewDelegate *alertDelegate=UIAlertViewD;
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"恭喜" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

//UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    
      if([self.userName isFirstResponder]){
          [self.password becomeFirstResponder];
          return NO;
      }else if([self.password isFirstResponder]){
          [self.email becomeFirstResponder];
          return NO;
      }else{
          [textField resignFirstResponder];
          return YES;
      }
    
}
@end
