//
//  UploadViewController.m
//  HeTaiJiCook
//
//  Created by apple on 13-10-12.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import "UploadViewController.h"
#import "CommonTools.h"
#import <Parse/Parse.h>
//#import "NSJ

@interface UploadViewController ()

@end
NSString const *TableCookBook=@"CookBook";
NSString const *TableImages=@"Images";

NSInteger const StepsViewTag=100;
NSInteger const OtherViewTag=101;
NSInteger const InputViewTag=102;
CGFloat const stepItemHeight=20;
CGFloat const marginTop=10;
UITextField *nameTextField;
UITextView *remarkTextView;
UITextView *tips;
NSData *previewImageData;
@implementation UploadViewController{

    CGFloat screenWidth ;
    CGFloat screenHeight;
    CGFloat stepsY;
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
    NSLog(@"viewDidLoad");
    //屏幕宽高
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    //scrollview 背景
    [self.scrollView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];

  
    //菜名
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    nameLabel.text=@"菜名:";
    [nameLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.4]];
    [self.scrollView addSubview:nameLabel];
    
//    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel2.frame.origin.y+nameLabel2.frame.size.height, 60, 20)];
//    nameLabel.text=@"菜名:";
//    [nameLabel setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.4]];
//    [self.scrollView addSubview:nameLabel];

//    if(1==1){
//        self.scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//        [self.scrollView setContentSize:CGSizeMake(screenWidth, nameLabel.frame.origin.y+nameLabel.frame.size.height+152)];
//        
//        return;
//    }
    
    nameTextField=[[UITextField alloc] initWithFrame:CGRectMake(80, 0, screenWidth, 20)];
    nameTextField.placeholder=@" 请输入菜名";
    
    [self.scrollView addSubview:nameTextField];
    
    //预览图和评论
    UIView *imageContent=[[UIView alloc] initWithFrame:CGRectMake(0, (nameTextField.frame.origin.y+nameTextField.frame.size.height+marginTop*2), screenWidth, (screenWidth/2-10)*1.5)];
    [imageContent setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.6]];
    [self.scrollView addSubview:imageContent];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, marginTop, screenWidth/2-10, (screenWidth/2-10)*1.5)];
    imageView.image=[UIImage imageNamed:@"default_icon"];
    [imageContent addSubview:imageView];
    
    remarkTextView=[[UITextView alloc] initWithFrame:CGRectMake(screenWidth/2, marginTop, screenWidth/2-10, (screenWidth/2-10)*1.5)];
    remarkTextView.text=@"大厨的烹饪心得";
    [imageContent addSubview:remarkTextView];
    
    //步骤 label
    UILabel *stepLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, imageContent.frame.origin.y+imageContent.frame.size.height+marginTop, 60, 20)];
    stepLabel.text=@"步骤:";
    [self.scrollView addSubview:stepLabel];
    
    //步骤 view
    UIView *stepView=[[UIView alloc] initWithFrame:CGRectMake(0, (stepLabel.frame.origin.y+stepLabel.frame.size.height), screenWidth, 1*(stepItemHeight+marginTop)+marginTop)];
    [stepView setTag:StepsViewTag];
    [self.scrollView addSubview:stepView];
    
    //默认步骤
    UIView *stepItem=[[UIView alloc] initWithFrame:CGRectMake(0, marginTop,screenWidth ,20)];
    [stepItem setTag:1];
    [stepView addSubview:stepItem];
    
    UITextField *stepText=[[UITextField alloc] initWithFrame:CGRectMake(0, marginTop,screenWidth-120 ,20)];
    stepText.placeholder=[NSString stringWithFormat:@"步骤%d",1];
    [stepText setTag:InputViewTag];
    [stepItem addSubview:stepText];
    UIButton *stepDelete=[[UIButton alloc] initWithFrame:CGRectMake(screenWidth-120+20+10, marginTop,80 ,20)];
    [stepDelete setTag:1];
    [stepDelete setTitle:@"删除" forState:UIControlStateNormal];
    [stepDelete addTarget:self action:@selector(deleteStep:) forControlEvents:UIControlEventTouchUpInside];
    [stepItem addSubview:stepDelete];
    
    UIView *otherView=[[UIView alloc] initWithFrame:CGRectMake(0, stepView.frame.origin.y+stepView.frame.size.height, screenWidth, marginTop+20+20+200+marginTop)];
    [otherView setTag:OtherViewTag];
    [self.scrollView addSubview:otherView];
    
    //添加步骤按钮 20+margin
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setTitle:@"添加步骤" forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(0, marginTop, 100, 20)];
    [addButton addTarget:self action:@selector(addSteps:) forControlEvents:UIControlEventTouchUpInside];
    [otherView addSubview:addButton];
    
    //贴士
    UILabel *tipsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, addButton.frame.origin.y+addButton.frame.size.height+marginTop, 200, 20)];
    tipsLabel.text=@"烹饪小贴士:";
    [otherView addSubview:tipsLabel];
    
    tips=[[UITextView alloc] initWithFrame:CGRectMake(0, tipsLabel.frame.origin.y+tipsLabel.frame.size.height+marginTop, screenWidth, 200)];
    tips.text=@"请输入烹饪小贴士";
    [otherView addSubview:tips];
    
    
    self.scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.scrollView setContentSize:CGSizeMake(screenWidth, otherView.frame.origin.y+otherView.frame.size.height+marginTop+152)];
    
    [super viewDidLoad];
    
    //添加一层view监听触摸后隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"hide keyboard");
    [nameTextField resignFirstResponder];
    [remarkTextView resignFirstResponder];
    UIView *stepsView=(UIView*)[self.scrollView viewWithTag:StepsViewTag];
    NSArray *subViews=[stepsView subviews];
    for(UIView *tempView in subViews){
        [((UITextField *)[tempView viewWithTag:InputViewTag]) resignFirstResponder];
    }
    [tips resignFirstResponder];
}

-(void) deleteStep:(id)sender{
    UIButton *button=(UIButton *)sender;
    UIView *stepsView=(UIView*)[self.scrollView viewWithTag:StepsViewTag];
    int currentCount=[stepsView subviews].count;
    
    NSLog(@"deleteStep ,index:%d,currentCount:%d",button.tag,currentCount);

    if(currentCount<=1){
        UIAlertView *atLeastOnStepAlert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"至少需要一个步骤，无法删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [atLeastOnStepAlert show];
        return;
    }

    UIView *stepItem=[stepsView viewWithTag:button.tag];
    NSArray *subViews=[stepsView subviews];
    //如果删除的是中间的button，还需要修改下面的stepItem的frame
    for (int i=subViews.count-1; i>0; i--) {
        UIView *view=[subViews objectAtIndex:i];
        if(view.tag!=button.tag){
            ((UITextField *)[view viewWithTag:InputViewTag]).placeholder=[NSString stringWithFormat:@"步骤%d",(i)];
            CGRect frameRect=view.frame;
            frameRect.origin.y-=(stepItemHeight+marginTop);
            [view setFrame:frameRect];
        }else{
            break;
        }
    }
    [stepItem removeFromSuperview];
    
    //更新frame
    CGRect rect=stepsView.frame;
    rect.size.height-=(stepItemHeight+marginTop);
    [stepsView setFrame:rect];
    
    UIView *otherView=(UIView*)[self.scrollView viewWithTag:OtherViewTag];
    CGRect otherRect=otherView.frame;
    otherRect.origin.y-=(stepItemHeight+marginTop);
    [otherView setFrame:otherRect];
    
    CGSize scrollViewSize=self.scrollView.contentSize;
    scrollViewSize.height-=(stepItemHeight+marginTop);
    [self.scrollView setContentSize:scrollViewSize];
        
    int latestCount=[stepsView subviews].count;
    NSLog(@"after delete,currentCount:%d",latestCount);
    
}

-(void) addSteps:(id)sender{
    NSLog(@"add Steps ");
    UIView *stepsView=(UIView*)[self.scrollView viewWithTag:StepsViewTag];
    
    int childCount=[[stepsView subviews] count];
    
    UIView *stepItem=[[UIView alloc] initWithFrame:CGRectMake(0, stepsView.frame.size.height,screenWidth ,stepItemHeight)];
    [stepItem setTag:(childCount+1)];
    [stepsView addSubview:stepItem];
    
    UITextField *stepText=[[UITextField alloc] initWithFrame:CGRectMake(0, marginTop,screenWidth-120 ,20)];
    stepText.placeholder=[NSString stringWithFormat:@"步骤%d",(childCount+1)];
    [stepText setTag:InputViewTag];
    [stepItem addSubview:stepText];
    UIButton *stepDelete=[[UIButton alloc] initWithFrame:CGRectMake(screenWidth-120+20+10, marginTop,80 ,20)];
    [stepDelete setTag:(childCount+1)];
    [stepDelete setTitle:@"删除" forState:UIControlStateNormal];
    [stepDelete addTarget:self action:@selector(deleteStep:) forControlEvents:UIControlEventTouchUpInside];
    [stepItem addSubview:stepDelete];

    //更新frame
    CGRect rect=stepsView.frame;
    rect.size.height+=(stepItemHeight+marginTop);
    [stepsView setFrame:rect];

    UIView *otherView=(UIView*)[self.scrollView viewWithTag:OtherViewTag];
    CGRect otherRect=otherView.frame;
    otherRect.origin.y+=(stepItemHeight+marginTop);
    [otherView setFrame:otherRect];
    
    CGSize scrollViewSize=self.scrollView.contentSize;
    scrollViewSize.height+=(stepItemHeight+marginTop);
    [self.scrollView setContentSize:scrollViewSize];
}
//
//-(void) pressButton:(id)sender{
//    NSLog(@"pressButton");
////    UIButton *stepItem=(UIButton *)sender;
//    UIView *stepView=[self.scrollView viewWithTag:StepsViewTag];
//    
//}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    
//       self.scrollView.frame = CGRectMake(0, 0, 320, 480);
//       [self.scrollView setContentSize:CGSizeMake(320, 1000)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender {
    //save steps image
    NSLog(@"upload");
    PFObject *cookBook =[PFObject objectWithClassName:TableCookBook];
    //菜名
    NSString *name=nameTextField.text;
    [cookBook setObject:name forKey:@"name"];
    
    //预览图
    if(previewImageData!=nil){
        PFFile *previewImage=[PFFile fileWithData:previewImageData];
        [cookBook setObject:previewImage forKey:@"previewImage"];
    }
    
    //厨师点评
    NSString *remark=remarkTextView.text;
    [cookBook setObject:remark forKey:@"remark"];
    
    //步骤
    NSMutableArray *steps=[[NSMutableArray alloc] init];
    UIView *stepsView=(UIView*)[self.scrollView viewWithTag:StepsViewTag];
    NSArray *subViews=[stepsView subviews];
    for(UIView *tempView in subViews){
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        NSString *text=((UITextField *)[tempView viewWithTag:InputViewTag]).text;

        [dic setValue:text forKey:@"text"];
        [dic setValue:nil forKey:@"image"];
        
        NSLog(@"step text:%@,real text;%@",text,[dic valueForKey:@"text"]);
        
        [steps addObject:dic];
    }
    if(steps!=nil){
        NSData *stepData=[NSJSONSerialization dataWithJSONObject:steps options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stepsStr=[[NSString alloc] initWithData:stepData encoding:NSUTF8StringEncoding];
        NSLog(@"stepsStr:%@",stepsStr);
        [cookBook setObject:stepsStr forKey:@"steps"];
    }
    
    //小贴士
    [cookBook setObject:tips.text forKey:@"tips"];
    
    [cookBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"save cookbook success");
    }];
    
}
@end
