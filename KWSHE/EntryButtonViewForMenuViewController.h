//
//  EntryButtonViewForMenuViewController.h
//  KWSHE
//
//  Created by kiwi on 16/5/14.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageForHomePageModel;

@interface EntryButtonViewForMenuViewController : UIView

//界面建立所需属性参数
@property (assign,nonatomic) CGFloat selfPadding;
@property (assign,nonatomic) CGFloat buttonWidth;
@property (assign,nonatomic) BOOL buttonIswhtite;

@property (assign,nonatomic) BOOL test;


/**
 *  初始化方法
 *
 *  @param viewController  为哪个controller添加的menuBar
 *  @param isWhite         需要黑色还是白色图标
 *  @param padding         menuButton距离右边的间距
 *  @param menuButtonWidth 所需的menuButton宽度(menuButton宽高相等)
 *
 *  @return menuButtonView
 */
+ (instancetype)getTheButtonForViewController:(UIViewController *)viewController ButtonColorIsWhite:(BOOL)isWhite rightPadding:(CGFloat)padding menuButtonWidth:(CGFloat)menuButtonWidth;
/**
 *  在menuController里添加浏览记录
 *
 *  @param itemIdentity 商品的Id
 *  @param image        商品主图<ImageForHomePageModel *>
 */
- (void)addBrowsedItemWithIdentity:(NSString *)itemIdentity andimage:(ImageForHomePageModel *)image;


- (void)closeMenu;
@end
