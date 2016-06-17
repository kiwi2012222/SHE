//
//  HomePageIssueViewController.h
//  KWSHE
//
//  Created by kiwi on 16/5/13.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomePageViewModel;
@protocol KWHomePageChangeTopBarDelegate <NSObject>
- (void)ChangeTopBarToStatus:(BOOL)show;
@end

@interface HomePageIssueViewController : UIViewController
@property (nonatomic,weak)id<KWHomePageChangeTopBarDelegate> ChangeTopBarDelegate;
@property (nonatomic,assign)BOOL topBarIsShowing;
- (void)setViewModel:(HomePageViewModel *)viewModel;
@end



