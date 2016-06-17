//
//  HomePageViewController.m
//  KWSHE
//
//  Created by kiwi on 16/5/4.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "HomePageBestViewController.h"

#import "CellForHomeBestPage.h"
#import "HomePageViewModel.h"
#import "HomePageModel.h"
#import "ItemDetailPageController.h"
@interface HomePageBestViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,KWBestCellDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)HomePageViewModel *viewModel;
@property (nonatomic,strong)UIView *topBarBackgroundView;
@property (nonatomic,assign)CGFloat headerViewHeight;
@end

@implementation HomePageBestViewController
#pragma mark --------------私有方法及私有代理方法----------------------------------------
/**
 *  页面点击跳转到Detail页
 */
- (void)KWitemDetailClicked:(NSString *)itemIdentity{
    ItemDetailPageController *controller = [[ItemDetailPageController alloc]init];
    controller.itemIdentity = itemIdentity;
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

#pragma mark --------------集合视图代理UICollectionView--------------------------
//----------Datasource--------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;//可变大小section1+内容展示区域section2
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return _viewModel.bestPageModel.list.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellForHomeBestPage *cell;
    if (indexPath.section == 0) {
        cell = [CellForHomeBestPage getChangeableHeaderCellWithEntity:_viewModel.bestPageModel.cover forCollectionView:collectionView atIndexPath:indexPath];
    }
    if (indexPath.section ==1) {
        cell = [CellForHomeBestPage getBestItemCellWithEntity:[_viewModel getBestItemByIndexPath:indexPath] forCollectionView:collectionView atIndexPath:indexPath];
        cell.delegate = self;
        
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//-----------FlowLayout------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    if (section ==1) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat ratio = [_viewModel.bestPageModel.cover.image.ratio[1] floatValue]/[_viewModel.bestPageModel.cover.image.ratio[0] floatValue] ;
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat cellHeight = cellWidth*ratio;
        _headerViewHeight = cellHeight;
        return CGSizeMake(cellWidth, cellHeight);
    }
    if (indexPath.section == 1) {
        CGFloat bodyCellWidth = [UIScreen mainScreen].bounds.size.width/3;
        CGFloat bodyCellHeight = bodyCellWidth*1.1;
        return CGSizeMake(bodyCellWidth, [[NSNumber numberWithFloat:bodyCellHeight] intValue]);
    }
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark -----------------scrollView代理-----------------------
static CGFloat offsetNow = 0;
static CGFloat offsetLastTime = 0;
static CGFloat offsetChanged = 0;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    offsetNow = _collectionView.contentOffset.y;
    offsetChanged = offsetNow - offsetLastTime;
    offsetLastTime = offsetNow;
    if (offsetNow < (_headerViewHeight-64)) {
        _topBarBackgroundView.layer.opacity =0;
    }
    if (offsetNow >= (_headerViewHeight-64)) {
        _topBarBackgroundView.layer.opacity =1;
    }
    
    if (offsetNow >= _headerViewHeight) {
        if (offsetChanged >= 1) {     //上滑速度较大隐藏topBar
            if (self.topBarIsShowing == YES) {
                self.topBarIsShowing = NO;
                
                [self.ChangeTopBarDelegate ChangeTopBarToStatus:self.topBarIsShowing];
                [_topBarBackgroundView.layer removeAllAnimations];
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    _topBarBackgroundView.transform = CGAffineTransformMakeTranslation(0, -64);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
        if (offsetChanged <= -2.5) {      //下滑速度较大显示topBar
            if (self.topBarIsShowing == NO) {
                self.topBarIsShowing = YES;
                [self.ChangeTopBarDelegate ChangeTopBarToStatus:self.topBarIsShowing];
                [_topBarBackgroundView.layer removeAllAnimations];
                [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
                    _topBarBackgroundView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
    for (int i = 0; i<_collectionView.visibleCells.count; i++) {
        [_collectionView.visibleCells[i] changeWithOffset:_collectionView.contentOffset.y];
    }
    
}


#pragma mark ---------------------懒加载---------------------------

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.allowsSelection = NO;
        
        NSArray *images = @[[UIImage imageNamed:@"Best"],[UIImage imageNamed:@"Issue"]];
        __weak HomePageBestViewController *wself = self;
        [_collectionView addGifFooterRefresh:^{
            [wself.viewModel getDataByRequestMode:KWRequestModeMore PageName:@"Best" completionHandler:^(NSError *error) {
                if(!error){
                    [wself.collectionView reloadData];
                    [wself.collectionView endFooterRefresh];
                }
            }];
        } andImagesforGif:images];      //上拉加载
        
        
        [CellForHomeBestPage registerClassesforCollectionView:_collectionView];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)topBarBackgroundView{
    if (_topBarBackgroundView == nil) {
        _topBarBackgroundView = [[UIView alloc]init];
        _topBarBackgroundView.backgroundColor = [UIColor blackColor];
        _topBarBackgroundView.layer.opacity = 0;
        [self.view addSubview:_topBarBackgroundView];
    }
    return _topBarBackgroundView;
}

- (void)setViewModel:(HomePageViewModel *)viewModel{
    _viewModel = viewModel;
}

#pragma mark ---------------生命周期Life cycle------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constraintMake];//界面搭建
}

- (void)constraintMake {
    self.topBarIsShowing = YES;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.topBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end