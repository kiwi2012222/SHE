//
//  KWMenuViewController.h
//  KWSHE
//
//  Created by kiwi on 16/5/14.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageForHomePageModel;
@interface KWMenuViewController : UIViewController
@property (nonatomic,strong) NSString *isHidden;
@property (nonatomic,strong) NSString *hoho;

- (void)setPercentage:(CGFloat)percentage;

- (void)openMenu;
- (void)closeMenu;
- (void)addBrowsedItemWithIdentity:(NSString *)itemIdentity andimage:(ImageForHomePageModel *)image;
@end
