//
//  AppDelegate.m
//  KWSHE
//
//  Created by kiwi on 16/4/23.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "AppDelegate.h"

#import "HomePageBestViewController.h"
#import "HomePageViewModel.h"
#import "HomePageWrappingViewController.h"

#import "KWMenuViewController.h"


#import "ItemDetailPageController.h"
#import "KWMenuViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

+ (KWMenuViewController *)getMenuView{
    KWMenuViewController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    if(menuController == nil){
        menuController = [[KWMenuViewController alloc]init];
    }
    return menuController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //获取配置信息判断是否先进入欢迎界面
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    //loadingViews生成及动画获取
    UIViewController *loadingcontroller = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *loadingAnimationView = [[UIView alloc]init];
    loadingAnimationView.backgroundColor = [UIColor colorWithHexString:@"C1FFC2"];
    [loadingcontroller.view addSubview:loadingAnimationView];
    loadingAnimationView.layer.cornerRadius = 5;
    
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"opacity";
    anim1.toValue = @0;
    anim1.duration = 1;
    anim1.repeatCount = MAXFLOAT;
    
    [loadingAnimationView.layer addAnimation:anim1 forKey:nil];
    [loadingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(3);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(10);
    }];
    self.window.rootViewController = loadingcontroller;
 
    [self.window makeKeyAndVisible];

    _menuController = [[KWMenuViewController alloc]init];
    
    //数据加载
    HomePageViewModel *homeViewModel = [[HomePageViewModel alloc]init];
    [homeViewModel getDataByRequestMode:KWRequestModeRefresh PageName:@"homePages" completionHandler:^(NSError *error) {
        if (!error) {
            
            [loadingAnimationView.layer removeAllAnimations];            
            
            [UIView animateWithDuration:0.7 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
                loadingAnimationView.transform = CGAffineTransformMakeScale(4, 4);
                loadingAnimationView.layer.opacity = 0;
            } completion:^(BOOL finished) {
                
                HomePageWrappingViewController *root = [[HomePageWrappingViewController alloc]init];
                [root setViewModel:homeViewModel];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
                self.window.rootViewController = nav;
            }];
            
        }
    }];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
