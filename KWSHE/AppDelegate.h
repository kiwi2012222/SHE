//
//  AppDelegate.h
//  KWSHE
//
//  Created by kiwi on 16/4/23.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KWMenuViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KWMenuViewController *menuController;

+ (KWMenuViewController *)getMenuView;

@end

