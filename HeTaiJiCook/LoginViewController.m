//
//  LoginViewController.m
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    SignUpViewController *signUpViewController=[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:signUpViewController animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    NSString *userNameStr=self.userName.text;
    NSString *passWordStr=self.password.text;
    
    //todo 输入框验证
    [PFUser logInWithUsernameInBackground:userNameStr password:passWordStr block:^(PFUser *user, NSError *error) {
        if(user){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"恭喜" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            //登陆失败
            NSString *message=[NSString stringWithFormat:@"登陆失败 错误原因:%@",[error localizedDescription]];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

//keyBoard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
