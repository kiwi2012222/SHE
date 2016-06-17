//
//  EntryButtonViewForMenuViewController.m
//  KWSHE
//
//  Created by kiwi on 16/5/14.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "EntryButtonViewForMenuViewController.h"
#import "KWMenuViewController.h"
#import "AppDelegate.h"
#import "ItemDetailPageController.h"

@interface EntryButtonViewForMenuViewController()<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) UIView *menuButton;

@property (nonatomic,strong) UIView *maskViewFullScreen;
@property (nonatomic,strong) UIView *maskViewEdge;

@property (nonatomic,weak) UIViewController *myViewController;
@property (nonatomic,strong)KWMenuViewController *menuViewController;

@end

static const CGFloat leftHeightOftheFirstController = 45; //上一个controller的剩余高度

@implementation EntryButtonViewForMenuViewController

#pragma mark------------初始化方法----------------------------
+ (instancetype)getTheButtonForViewController:(UIViewController *)viewController ButtonColorIsWhite:(BOOL)isWhite rightPadding:(CGFloat)padding menuButtonWidth:(CGFloat)menuButtonWidth{
    EntryButtonViewForMenuViewController *view = [[EntryButtonViewForMenuViewController alloc]init];
    view.selfPadding = padding;
    view.buttonWidth = menuButtonWidth;
    view.buttonIswhtite = isWhite;
    view.myViewController = viewController;
    [view prepareToShow];
    return view;
}
- (void)prepareToShow{
    [self constraintMake];
    [self addGesture];
}
- (void)constraintMake{

    _menuViewController = [AppDelegate getMenuView];

    if ([UIApplication sharedApplication].keyWindow.subviews.count == 1) {
        [[UIApplication sharedApplication].keyWindow addSubview:_menuViewController.view];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:_menuViewController.view];
    }
    
    [self.myViewController.view addSubview:self.maskViewEdge];     //maskViewEdge不属于本view,用于边缘拖拽
    
    [_maskViewEdge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-_selfPadding);
        make.width.mas_equalTo(_menuButton.mas_height);
    }];
    
    [_menuViewController addObserver:self forKeyPath:@"isHidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)dealloc{
    [_menuViewController removeObserver:self forKeyPath:@"isHidden"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isHidden"]) {
        if ([change[@"new"] isEqualToString:@"yes"]) {
            [self maskViewHide];
        }
        else{
            [self maskViewShow];
        }
    }

}
#pragma mark -------------------手势驱动,打开,关闭menu------------------------------------
- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [_menuButton addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];

    [self.maskViewFullScreen addGestureRecognizer:pan1];
    [self.maskViewFullScreen addGestureRecognizer:tap1];
    
    [self.maskViewEdge addGestureRecognizer:pan2];
}
/**
 *  pan手势
 */
- (void)pan:(UIPanGestureRecognizer *)pangr{


    if ([UIApplication sharedApplication].keyWindow.subviews.count == 1) {
        NSLog(@"new");
        [[UIApplication sharedApplication].keyWindow addSubview:_menuViewController.view];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:_menuViewController.view];
    }
    CGPoint translation = [pangr translationInView:[UIApplication sharedApplication].keyWindow];
    [pangr setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
    [UIApplication sharedApplication].keyWindow.subviews[1].transform = CGAffineTransformTranslate([UIApplication sharedApplication].keyWindow.subviews[1].transform, 0, translation.y);
    [self.menuViewController setPercentage:[UIApplication sharedApplication].keyWindow.subviews[1].transform.ty/([UIScreen mainScreen].bounds.size.height-leftHeightOftheFirstController)];
    if (pangr.state == UIGestureRecognizerStateEnded) {
        if ([pangr velocityInView:[UIApplication sharedApplication].keyWindow].y>1200) {         //pan速度较大时,展开或关闭menu
            [self openMenu];
            return;
        }
        if ([pangr velocityInView:[UIApplication sharedApplication].keyWindow].y<-1200) {
            [self closeMenu];
            return;
        }
        if ([pangr velocityInView:[UIApplication sharedApplication].keyWindow].y<=1200&&[pangr velocityInView:[UIApplication sharedApplication].keyWindow].y>=-1200) {               //速度较小
            if ([pangr locationInView:[UIApplication sharedApplication].keyWindow].y<=[UIScreen mainScreen].bounds.size.height*0.33 && [_menuViewController.isHidden isEqualToString:@"no"]) {//位置高(应该关闭)但是实际状况是开启
                [self closeMenu];
                return;
            }
            if ([pangr locationInView:[UIApplication sharedApplication].keyWindow].y>=[UIScreen mainScreen].bounds.size.height*0.67 && [_menuViewController.isHidden isEqualToString:@"yes"]) {//位置低(应该打开)但是实际状态是关闭
                [self openMenu];
                return;
            }
            if ([_menuViewController.isHidden isEqualToString:@"yes"]) {                           //不满足前两个条件->此处恢复原状
                [self closeMenu];
                return;
            }
            else{
                [self openMenu];
                return;
            }
        }
    }
    
}
/**
 *  点击手势
 */
- (void)tapped:(UITapGestureRecognizer *)tapgr{

    if ([UIApplication sharedApplication].keyWindow.subviews.count == 1) {
        NSLog(@"new");
        [[UIApplication sharedApplication].keyWindow addSubview:_menuViewController.view];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:_menuViewController.view];
    }
    if ([_menuViewController.isHidden isEqualToString:@"yes"]) {                  //展示menu层
        [self openMenu];
    }
    else{                            //收起menu层
        [self closeMenu];
    }
}


- (void)openMenu{

    [self.menuViewController openMenu];
    

}
- (void)maskViewShow{
    
    [self.myViewController.view addSubview:self.maskViewFullScreen];
    
    [_maskViewFullScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)closeMenu{

    [self.menuViewController closeMenu];

}

- (void)maskViewHide{
    
    [self.maskViewFullScreen removeFromSuperview];

}



#pragma mark -----------lazy load懒加载----------------
- (UIView *)menuButton{
    if(_menuButton == nil){
        _menuButton = [[UIView alloc]init];
        [self addSubview:_menuButton];

        UIImageView *menuButtonImageView = [[UIImageView alloc]init];
        menuButtonImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.buttonIswhtite) {
            menuButtonImageView.image = [UIImage imageNamed:@"menuButton"];
        }
        else{
            menuButtonImageView.image = [UIImage imageNamed:@"menuButtonBlack"];
        }
        [_menuButton addSubview:menuButtonImageView];
        
        [menuButtonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(_buttonWidth);
            make.center.mas_equalTo(0);
        }];
    }
    return _menuButton;
}

- (UIView *)maskViewFullScreen{
    if (_maskViewFullScreen == nil) {
        _maskViewFullScreen = [[UIView alloc]init];
    }
    return _maskViewFullScreen;
    
}

- (UIView *)maskViewEdge{
    if (_maskViewEdge == nil) {
        _maskViewEdge = [[UIView alloc]init];
    }
    return _maskViewEdge;
}

- (void)addBrowsedItemWithIdentity:(NSString *)itemIdentity andimage:(ImageForHomePageModel *)image{
    [self.menuViewController addBrowsedItemWithIdentity:itemIdentity andimage:image];
}
@end
