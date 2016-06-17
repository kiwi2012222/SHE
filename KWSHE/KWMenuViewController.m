//
//  KWMenuViewController.m
//  KWSHE
//
//  Created by kiwi on 16/5/14.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "KWMenuViewController.h"
#import "BrowseRecordModel.h"
#import "HomePageModel.h"
#import "ItemDetailPageController.h"
@interface KWMenuViewController()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *wrappingViewForAnimation;
@property (nonatomic,strong) UIView *dimmingViewForAnimation;
@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *topBar;
@property (nonatomic,strong) UIView *menuView;

@property (nonatomic,strong) UIScrollView *browseRecordingView;
@property (nonatomic,strong) UIView *browseRecordingWrappingView;
@property (nonatomic,strong) NSMutableArray<BrowseRecordModel *> *browseModels;

@property (nonatomic,assign) CGFloat percentage;//动画的进度
@end

//1
static const CGFloat maxOffsetOfTopBar = 50;     //顶部工具条的最初升起位置(动画相关)
static const NSTimeInterval animateDuration = 0.2;//动画持续时间
static const CGFloat minScaleOfView = 0.9;       //动画是view的初始大小
//2
static const CGFloat padding = 20;   //左右边距
static const CGFloat leftHeightOftheFirstController = 45;   //上个界面的剩余高度
static NSString * const backgroundColorHex =@"3A3636";//整体的背景颜色Hex
static CGFloat fontSize;     //menu列表的字体大小(根据屏幕大小作改变)
//3
static NSString * filePathForBrowse;    //browseView的数据归档路径
static const CGFloat browseRecordingViewWidth = 60;   //browseView每个方格的大小
static const CGFloat browseImageRate = 0.8;          //browseView图片的大小

@implementation KWMenuViewController

- (void)openMenu{
    self.isHidden = @"no";
    [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [UIApplication sharedApplication].keyWindow.subviews[1].transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height-leftHeightOftheFirstController);
    } completion:nil];

    [self animateFromPercentToStatus:YES];

}



- (void)closeMenu{
    self.isHidden = @"yes";
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [UIApplication sharedApplication].keyWindow.subviews[1].transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
    [self animateFromPercentToStatus:NO];
}

#pragma mark ----------------set,get函数-----------------------------------
- (void)setPercentage:(CGFloat)percentage{
    _topBar.transform = CGAffineTransformMakeTranslation(0, -maxOffsetOfTopBar*percentage+maxOffsetOfTopBar);
    _wrappingViewForAnimation.transform = CGAffineTransformMakeScale(minScaleOfView+(1-minScaleOfView)*percentage, minScaleOfView+(1-minScaleOfView)*percentage);
    _dimmingViewForAnimation.layer.opacity = 0.8-percentage;
    _percentage = percentage;
}


#pragma mark--------------动画相关-----------------------
- (void)animateFromPercentToStatus:(BOOL)toShow{
    if (toShow) {                //展开menu
        [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _topBar.transform = CGAffineTransformMakeTranslation(0,0);
            _wrappingViewForAnimation.transform = CGAffineTransformMakeScale(1, 1);
            _dimmingViewForAnimation.layer.opacity = 0;
        } completion:^(BOOL finished) {
            _percentage = 1;
        }];
        return;
    }
    if (!toShow) {              //关闭menu
        [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _topBar.transform = CGAffineTransformMakeTranslation(0, maxOffsetOfTopBar);
            _wrappingViewForAnimation.transform = CGAffineTransformMakeScale(minScaleOfView, minScaleOfView);
            _dimmingViewForAnimation.layer.opacity = 0.8;
        } completion:^(BOOL finished) {
            _percentage = 0;
        }];
        return;
    }
}

#pragma mark ---------------生命周期Life cycle------------------------------
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.percentage = 0;
    [self constraintMake];
    _topBar.transform = CGAffineTransformMakeTranslation(0, maxOffsetOfTopBar);
    _wrappingViewForAnimation.transform = CGAffineTransformMakeScale(minScaleOfView, minScaleOfView);
    _dimmingViewForAnimation.layer.opacity = 0.8;
}

- (void)constraintMake{
    fontSize = [UIScreen mainScreen].bounds.size.width/320*25;
    fontSize = floorf(fontSize);
    
    self.isHidden = @"yes";
    
    [self browseModels];
    
    [self.wrappingViewForAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-600);
        make.bottom.mas_equalTo(600);
    }];
    
    [self.dimmingViewForAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self updateBrowseRecordView];
}

#pragma mark ---------------lazy load 懒加载------------------------------
- (UIView *)dimmingViewForAnimation{
    if (_dimmingViewForAnimation == nil) {
        _dimmingViewForAnimation = [[UIView alloc]init];
        _dimmingViewForAnimation.backgroundColor = [UIColor blackColor];
        _dimmingViewForAnimation.userInteractionEnabled = NO;
        [self.view addSubview:_dimmingViewForAnimation];
    }
    return _dimmingViewForAnimation;
}
- (UIView *)wrappingViewForAnimation{
    if (_wrappingViewForAnimation == nil) {
        _wrappingViewForAnimation = [[UIView alloc]init];
        _wrappingViewForAnimation.backgroundColor = [UIColor colorWithHexString:backgroundColorHex];
        [self.view addSubview:_wrappingViewForAnimation];
        
        [self scrollView];
        [self browseRecordingView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(0);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-leftHeightOftheFirstController);
            make.left.mas_equalTo(self.view.mas_left);     //scrollview的上下左右与最外层controller的view对等
        }];
        [_browseRecordingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-leftHeightOftheFirstController);
            make.height.mas_equalTo(browseRecordingViewWidth*3);
            make.right.mas_equalTo(-padding);
            make.width.mas_equalTo(browseRecordingViewWidth);
        }];
    }
    return _wrappingViewForAnimation;
}



- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        [_wrappingViewForAnimation addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(0, 0);
        
        [self topBar];
        [self menuView];
        
        [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(leftHeightOftheFirstController);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.height.mas_equalTo(40);
        }];
        [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topBar.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.bottom.mas_equalTo(_menuView.subviews.lastObject.mas_bottom);
            
            make.bottom.mas_equalTo(0);

        }];
    }
    return _scrollView;
}
- (UIView *)topBar{
    if (_topBar == nil) {
        _topBar = [[UIView alloc]init];
        [_scrollView addSubview:_topBar];
        
        UIImageView *searchButton = [[UIImageView alloc]init];
        searchButton.image = [UIImage imageNamed:@"searchButton"];
        searchButton.tag = 0;
        [_topBar addSubview:searchButton];
        
        UIImageView *heartButton = [[UIImageView alloc]init];
        heartButton.image = [UIImage imageNamed:@"heartButton"];
        heartButton.tag = 1;
        [_topBar addSubview:heartButton];
        
        UIImageView *shopButton = [[UIImageView alloc]init];
        shopButton.image = [UIImage imageNamed:@"shopButton"];
        shopButton.tag = 2;
        [_topBar addSubview:shopButton];
        
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topBar.mas_centerY);
            make.left.mas_equalTo(padding+3);
            make.height.width.mas_equalTo(30);
        }];
        [heartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topBar.mas_centerY);
            make.right.mas_equalTo(shopButton.mas_left).offset(-padding);
            make.height.width.mas_equalTo(30);
        }];
        [shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topBar.mas_centerY);
            make.right.mas_equalTo(-padding-3);
            make.height.width.mas_equalTo(30);
        }];
        
        for (int i = 0; i<3; i++) {
            _topBar.subviews[i].userInteractionEnabled = YES;
            [_topBar.subviews[i] addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topButtonsClicked:)]];
        }
    }
    return _topBar;
}

- (UIView *)menuView{
    if (_menuView == nil) {
        _menuView = [[UIView alloc]init];
        _menuView.backgroundColor = [UIColor colorWithHexString:backgroundColorHex];
        [_scrollView addSubview:_menuView];
        
        NSArray<NSString *> *menuTitles = @[@"29CM HOME",@"",@"SUMMER",@"WOMEN",@"MEN",@"",@"BEAUTY",@"HOME",@"LIFE",@"EVENT",@"",@"EVENT",@"BEST SELLER",@"EVENT ON",@"EVENT",@"EVENT"];
        
        for (int i = 0; i<menuTitles.count; i++) {
            UILabel *menuTitleLb = [[UILabel alloc]init];
            [menuTitleLb KWSetLabelWithFontName:@"Aapex" fontSize:fontSize backgroundColor:[UIColor clearColor] fontColor:[UIColor whiteColor]];
            menuTitleLb.numberOfLines = 1;
            [menuTitleLb KWSetWithTextAndGetRowHeight:menuTitles[i] expectedWidth:100];
            [_menuView addSubview:menuTitleLb];
            
            [menuTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(40);
                }
                else{
                    make.top.mas_equalTo(_menuView.subviews[i-1].mas_bottom).offset(0);
                }
                make.left.mas_equalTo(padding);
                make.height.mas_equalTo(fontSize*1.2);
            }];
        }
    }
    return _menuView;
}

- (UIScrollView *)browseRecordingView{
    if (_browseRecordingView == nil) {
        _browseRecordingView = [[UIScrollView alloc]init];
        _browseRecordingView.contentSize = CGSizeZero;
        [self.wrappingViewForAnimation addSubview:_browseRecordingView];
        
        [self browseRecordingWrappingView];
    }
    return _browseRecordingView;
}
- (UIView *)browseRecordingWrappingView{
    if (_browseRecordingWrappingView == nil) {
        _browseRecordingWrappingView = [[UIView alloc]init];
        [_browseRecordingView addSubview:_browseRecordingWrappingView];        
    }
    return _browseRecordingWrappingView;
}

- (NSMutableArray<BrowseRecordModel *> *)browseModels{
    if (_browseModels == nil) {
        filePathForBrowse = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"BrowseRecord.data"];
        _browseModels = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathForBrowse];
        if (_browseModels == nil) {
            _browseModels = [NSMutableArray array];//还是没有数据---就新建吧;
        }
    }
    return _browseModels;
}

#pragma mark----------------private methods私有方法---------------------------
- (void)topButtonsClicked:(UITapGestureRecognizer *)recognizer{    
    UIImageView *chosenButton = (UIImageView *)recognizer.view;
    switch (chosenButton.tag) {
        case 0:
            NSLog(@"search");
            break;
            
        case 1:
            NSLog(@"heart");
            break;
            
        case 2:
            NSLog(@"shop");
            break;
            
        default:
            break;
    }
}




- (void)insertItemInBrowseRecordingView:(BrowseRecordModel *)browseRecordModel{
    UIImageView *newView = [[UIImageView alloc]init];
    newView.backgroundColor = [UIColor whiteColor];
    newView.layer.cornerRadius = browseRecordingViewWidth*0.8*0.5;
    
    [newView sd_setImageWithURL:[NSURL URLWithString:browseRecordModel.imagePath]];
    
    newView.clipsToBounds = YES;
    [_browseRecordingWrappingView addSubview:newView];
    
    newView.tag = _browseRecordingWrappingView.subviews.count-1;
    newView.userInteractionEnabled = YES;
    [newView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browseViewClicked:)]];
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_browseRecordingWrappingView.subviews.count == 1) {
            make.bottom.mas_equalTo(-browseRecordingViewWidth*0.2*0.5);//imageView的底部距正方形底部的距离(但imageView是直接在wrappingView里的,而不是在正方形中)
        }
        else{
            make.bottom.mas_equalTo(-browseRecordingViewWidth*(_browseRecordingWrappingView.subviews.count-1)-browseRecordingViewWidth*0.2*0.5);
        }
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(browseRecordingViewWidth*0.8);
        make.height.mas_equalTo(browseRecordingViewWidth*0.8);
        
    }];
    
    
    [_browseRecordingWrappingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_browseRecordingWrappingView.subviews.count<3) {
            make.top.mas_equalTo((3-_browseRecordingWrappingView.subviews.count)*browseRecordingViewWidth);;
        }
        else{
            make.top.mas_equalTo(0);
        }
        make.height.mas_equalTo(browseRecordingViewWidth*_browseRecordingWrappingView.subviews.count);
        make.width.mas_equalTo(_browseRecordingView.mas_width);
        make.left.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)addBrowsedItemWithIdentity:(NSString *)itemIdentity andimage:(ImageForHomePageModel *)image{
    
    BrowseRecordModel *browseRecordModel = [[BrowseRecordModel alloc]init];
    browseRecordModel.identity = itemIdentity;
    browseRecordModel.imagePath = [image getRequestUrlWithWidth:browseRecordingViewWidth*browseImageRate];

    //寻找相同元素,若有则删除(此元素将添加到队尾)
    for (int i = 0; i<_browseModels.count; i++) {
        if ([_browseModels[i].identity isEqualToString:browseRecordModel.identity]) {
            [_browseModels removeObject:_browseModels[i]];
        }
    }
    [_browseModels addObject:browseRecordModel];

    //最多存储20个
    if(_browseModels.count>20){
        [_browseModels removeObjectAtIndex:0];
    }
    
    //界面更新
    [self updateBrowseRecordView];
    
    //数据同步归档;
    [NSKeyedArchiver archiveRootObject:self.browseModels toFile:filePathForBrowse];
}

- (void)updateBrowseRecordView{
    [_browseRecordingWrappingView removeAllSubviews];
    for(int i = 0;i<_browseModels.count;i++){
        [self insertItemInBrowseRecordingView:_browseModels[i]];
    }
    
    [_browseRecordingView setContentOffset:CGPointMake(0, 0)];
}
- (void)browseViewClicked:(UITapGestureRecognizer *)tap{
    UINavigationController *rootNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ItemDetailPageController  *newController = [[ItemDetailPageController alloc]init];
    newController.itemIdentity = _browseModels[tap.view.tag].identity;
    [rootNav pushViewController:newController animated:NO];
    [self closeMenu];
}

@end
