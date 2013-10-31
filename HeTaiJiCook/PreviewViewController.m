//
//  UploadViewController.m
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import "PreviewViewController.h"
#import "CookBook.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "MyUIImageView.h"

@interface PreviewViewController ()


@end

@implementation PreviewViewController{
    NSMutableArray *cookBooks;
    
}

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
    self.collectionView.dataSource=self;
	// Do any additional setup after loading the view.
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    PFUser *user=[PFUser currentUser];
    if(!user){
        //        NSBundle *bundle=nil;
        LoginViewController *loginViewController=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:loginViewController animated:YES completion:^{
            NSLog(@"show login view success");
        }];
    }else{
        NSLog(@"current user:%@",user.username);
        //        [PFUser logOut];
        PFQuery *query=[PFQuery queryWithClassName:@"CookBook"];
        [query whereKey:@"userName" equalTo:user.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            cookBooks = [[NSMutableArray alloc] init];
            
            
            for (PFObject *object in objects) {
                NSLog(@"cookbook :%@",object);
                CookBook *tempCookBook=[[CookBook alloc] init];
                tempCookBook.name=(NSString *)([object valueForKey:@"name"]);
                tempCookBook.previewFile=(PFFile *)([object valueForKey:@"previewImage"]);
                if(tempCookBook.previewFile!=nil){
                    NSLog(@"name:%@,url:%@",tempCookBook.previewFile.name,tempCookBook.previewFile.url);
                }
                
                [cookBooks addObject:tempCookBook];
                
            }
            [self.collectionView reloadData];
        }];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//implementation UICollectionViewDataSourceDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"return count:%d",cookBooks.count);
    return cookBooks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    CookBook *currentCookBook=(CookBook *)[cookBooks objectAtIndex:indexPath.row];
    NSLog(@"getView currentCookBook:%@",currentCookBook);

    if(currentCookBook.previewFile!=nil){
        MyUIImageView *imageView=(MyUIImageView *)([cell viewWithTag:109]);
        imageView.file=currentCookBook.previewFile;
        [imageView loadInBackground];
    }
    
    UILabel *label=(UILabel *)([cell viewWithTag:101]);
    
    NSLog(@"row:%d,count:%d",indexPath.row,cookBooks.count);
    label.text=@"complete";
    if(currentCookBook!=nil){
        NSLog(@"set text:%@",currentCookBook);
        if(currentCookBook.name==nil){
            NSLog(@"cookBook.name is nil");
        }
        NSLog(@"set text name:%@",currentCookBook.name);//不知道为啥定位到这一行
        label.text=currentCookBook.name;
        if([label.text isEqualToString:@""]){
            label.text=@"null";
        }
        NSLog(@"label text:%@",label.text);
    }else{
        NSLog(@"cookBook is null");
    }
    
    return  cell;
}


@end
