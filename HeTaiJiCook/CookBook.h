//
//  CookBook.h
//  HeTaiJiCook
//
//  Created by apple on 13-10-11.
//  Copyright (c) 2013年 syh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CookBook : NSObject

@property(copy,atomic) NSString *name;
@property(copy,atomic) NSString *imageName;
@property(retain,atomic) PFFile *previewFile;
@end
