//
//  HomePageWrappingViewController.m
//  KWSHE
//
//  Created by kiwi on 16/5/12.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "HomePageWrappingViewController.h"
#import "HomePageViewModel.h"
#import "HomePageIssueViewController.h"
#import "HomePageBestViewController.h"
#import "EntryButtonViewForMenuViewController.h"

@interface HomePageWrappingViewController()<UIScrollViewDelegate,KWHomePageChangeTopBarDelegate>

@property (nonatomic ,strong) UIScrollView *wrappingScrollView;
@property (nonatomic,strong) UIView *topBar;
@property (nonatomic,strong) NSMutableArray<UIView *> *topBarButtons;
@property (nonatomic,assign) BOOL topBarIsShowing;

@property (nonatomic,strong) HomePageViewModel *viewModel;
@end

static NSUInteger currentIndex = 0;

static const CGFloat padding = 10;

@implementation HomePageWrappingViewController
#pragma mark ----------------lazy load 懒加载--------------------------
- (UIScrollView *)wrappingScrollView{
    if (_wrappingScrollView == nil) {
        _wrappingScrollView = [[UIScrollView alloc]init];
        _wrappingScrollView.backgroundColor = [UIColor whiteColor];
        _wrappingScrollView.delegate = self;
        
        CGFloat contentWidth = 2*[UIScreen mainScreen].bounds.size.width;
        _wrappingScrollView.contentSize = CGSizeMake(contentWidth,0);//设置为三个屏幕宽度的横向滚动;
        
        _wrappingScrollView.pagingEnabled = YES;
        _wrappingScrollView.showsHorizontalScrollIndicator = NO;
        _wrappingScrollView.bounces = NO;

        [self.view addSubview:_wrappingScrollView];
    }
    return _wrappingScrollView;
}
- (UIView *)topBar{
    if(_topBar == nil){
        _topBar = [[UIView alloc]init];
        [self.view addSubview:_topBar];
        
        EntryButtonViewForMenuViewController *menuButtonView = [EntryButtonViewForMenuViewController getTheButtonForViewController:self ButtonColorIsWhite:YES rightPadding:padding menuButtonWidth:32];
        [_topBar addSubview:menuButtonView];
        [menuButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [_topBar.layer hitTest:CGPointMake(100, 100)];
        
        [self topBarButtons];
    }
    return _topBar;
}
- (void)addSubControllers{
    HomePageIssueViewController *issueVC = [[HomePageIssueViewController alloc]init];//1
    issueVC.title = @"Issue";
    issueVC.ChangeTopBarDelegate = self;
    [self addChildViewController:issueVC];
    [self.wrappingScrollView addSubview:issueVC.view];
    [issueVC setViewModel:_viewModel];
    
    [issueVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo ([UIScreen mainScreen].bounds.size.width*0);
        make.top.mas_equalTo (0);
        make.width.height.mas_equalTo(self.view);
    }];
    
    HomePageBestViewController *bestVC = [[HomePageBestViewController alloc]init];//2
    bestVC.title = @"Best";
    bestVC.ChangeTopBarDelegate = self;
    [self addChildViewController:bestVC];
    [self.wrappingScrollView addSubview:bestVC.view];
    [bestVC setViewModel:_viewModel];
    
    [bestVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo ([UIScreen mainScreen].bounds.size.width*1);
        make.top.mas_equalTo (0);
        make.width.height.mas_equalTo(self.view);
    }];
}
- (NSMutableArray *)topBarButtons{
    if (_topBarButtons == nil) {
        _topBarButtons = [NSMutableArray array];
        NSArray<NSString *> *topItems= @[@"Issue",@"Best"];
        NSUInteger initialSubviewsCount = _topBar.subviews.count;
        for (int i = 0; i<topItems.count; i++) {
            UIImageView *imageViewButtton = [[UIImageView alloc]init];
            imageViewButtton.contentMode = UIViewContentModeScaleAspectFill;
            imageViewButtton.tag = i;
            UIImage *image = [UIImage imageNamed:topItems[i]];
            imageViewButtton.image = image;
            if(i!=0){
                imageViewButtton.layer.opacity = 0.5;
            }
            imageViewButtton.userInteractionEnabled = YES;
            [_topBar addSubview:imageViewButtton];
            [imageViewButtton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topButtonsClicked:)]];
            
            [imageViewButtton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i==0) {
                    make.left.mas_equalTo(24);
                }
                else{
                    make.left.mas_equalTo((_topBar.subviews[initialSubviewsCount+i-1]).mas_right).offset(16);   //此处受到topBar的i
                }
                make.centerY.mas_equalTo(_topBar.mas_top).offset(32);
                make.height.mas_equalTo(32);
                make.width.mas_equalTo([image size].width);
            }];
            [_topBarButtons addObject:imageViewButtton];
        }
    }
    return _topBarButtons;
}

#pragma mark --------------life cycle 生命周期------------------------
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;//隐藏系统的navigationBar
    self.view.clipsToBounds = YES;
    [self constraintMake];
    [self addSubControllers];
}
- (void)constraintMake{
    self.topBarIsShowing = YES;
    [self.wrappingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
}

#pragma mark --------------scrollview delegate方法---------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat changedPercent = (_wrappingScrollView.contentOffset.x-currentIndex*[UIScreen mainScreen].bounds.size.width)/[UIScreen mainScreen].bounds.size.width;
    CGFloat tempIndex = currentIndex;
    if (changedPercent>=0.5) {
        tempIndex+=1;
    }
    else if (changedPercent<=-0.5) {
        tempIndex-=1;
    }
    if (tempIndex != currentIndex) {
        currentIndex = tempIndex;
        [self indexChanged];
    }
}
#pragma mark --------------自定义类的代理方法-------------------------------
//-----------KWHomePageHideTopBarDelegate------------//
- (void)ChangeTopBarToStatus:(BOOL)show{
    [self changeTopBarShowingToStatus:show animateType:@"ForSubController"];
}

#pragma mark -------------private method私有方法---------------------------
/**
 *  顶部按钮点击事件
 */
- (void)topButtonsClicked:(UITapGestureRecognizer *) recognizer{
    UIImageView *chosenButton = (UIImageView *)recognizer.view;
    CGPoint offset = CGPointMake([UIScreen mainScreen].bounds.size.width*chosenButton.tag, 0);
    if (chosenButton.tag!=currentIndex) {
        [_wrappingScrollView setContentOffset:offset animated:YES];
    }
}
/**
 *  index页面改变事件
 */
- (void)indexChanged{
    for (int i=0; i<2; i++) {
        _topBarButtons[i].layer.opacity = 0.5;
    }
    _topBarButtons[currentIndex].layer.opacity =1;
    if (currentIndex == 0) {
        HomePageIssueViewController *currentController = (HomePageIssueViewController *)self.childViewControllers [currentIndex];
        if (currentController.topBarIsShowing != _topBarIsShowing) {
            [self changeTopBarShowingToStatus:currentController.topBarIsShowing animateType:@"IndexChange"];
        }
        return;
    }
    if (currentIndex == 1) {
        HomePageIssueViewController *currentController = (HomePageIssueViewController *)self.childViewControllers [currentIndex];
        if (currentController.topBarIsShowing != _topBarIsShowing) {
            [self changeTopBarShowingToStatus:currentController.topBarIsShowing animateType:@"IndexChange"];
        }
        return;
    }
}
/**
 *  移动到相应页面,并根据该子页是否显示topBar来改变打开或隐藏topBar
 */
- (void)changeTopBarShowingToStatus:(BOOL)Show animateType:(NSString *)type{
    if ([type isEqualToString:@"IndexChange"]) {                     //-----------for左右滑动的行为
        if (!Show) {                      //隐藏topBar
            _topBarIsShowing = !_topBarIsShowing;
            [_topBar.layer removeAllAnimations];
            [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _topBar.transform = CGAffineTransformMakeTranslation(0, -64);
            } completion:^(BOOL finished) {
            }];
            return;
        }
        if (Show) {                     //展示topBar
            _topBarIsShowing = !_topBarIsShowing;
            [_topBar.layer removeAllAnimations];
            [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _topBar.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }
        return;
    }
    if ([type isEqualToString:@"ForSubController"]) {              //--------for子controller的上下滑动
        if (!Show) {                      //隐藏topBar
            _topBarIsShowing = !_topBarIsShowing;
            [_topBar.layer removeAllAnimations];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _topBar.transform = CGAffineTransformMakeTranslation(0, -64);
            } completion:^(BOOL finished) {
                
            }];
            return;
        }
        if (Show) {                     //展示topBar
            _topBarIsShowing = !_topBarIsShowing;
            [_topBar.layer removeAllAnimations];
            [UIView animateWithDuration:0.15 delay:0.03 options:UIViewAnimationOptionCurveLinear animations:^{
                _topBar.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
        return;
    }
}
#pragma mark ---------------setter,getter------------------------------
- (void)setViewModel:(HomePageViewModel *)viewModel{
    _viewModel = viewModel;    
}
@end
