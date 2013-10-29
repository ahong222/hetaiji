//
//  UploadViewController.h
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PreviewViewController : UIViewController<UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

//+ (NSString*) replaceUnicode:(NSString*)aUnicodeString;
@end
