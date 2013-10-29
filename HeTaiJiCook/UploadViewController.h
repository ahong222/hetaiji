//
//  UploadViewController.h
//  HeTaiJiCook
//
//  Created by apple on 13-10-12.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationItem *inavItem;

- (IBAction)upload:(id)sender;
@end
