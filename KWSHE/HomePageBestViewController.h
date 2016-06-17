//
//  HomePageBestViewController.h
//  KWSHE
//
//  Created by kiwi on 16/5/5.
//  Copyright © 2016年 kiwi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HomePageIssueViewController.h"

@class HomePageViewModel;

@interface HomePageBestViewController : UIViewController
@property (nonatomic,weak)id<KWHomePageChangeTopBarDelegate> ChangeTopBarDelegate;
@property (nonatomic,assign)BOOL topBarIsShowing;
- (void)setViewModel:(HomePageViewModel *)viewModel;
@end
