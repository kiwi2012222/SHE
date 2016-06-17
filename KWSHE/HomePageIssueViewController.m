//
//  HomePageIssueViewController.m
//  KWSHE
//
//  Created by kiwi on 16/5/4.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "HomePageIssueViewController.h"
#import "CellForHomeIssuePage.h"
#import "HomePageViewModel.h"
#import "HomePageModel.h"
#import "EntryButtonViewForMenuViewController.h"



@interface HomePageIssueViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)HomePageViewModel *viewModel;
@property (nonatomic,strong)UIView *topBarBackgroundView;
@property (nonatomic,assign)CGFloat headerViewHeight;
@end

@implementation HomePageIssueViewController

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
        return _viewModel.issuePageModel.list.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellForHomeIssuePage *cell;
    if (indexPath.section == 0) {
        cell = [CellForHomeIssuePage getChangeableHeaderCellWithEntity:_viewModel.issuePageModel.cover forCollectionView:collectionView atIndexPath:indexPath];
    }
    if (indexPath.section ==1) {
        cell = [CellForHomeIssuePage getBestItemCellWithEntity:_viewModel.issuePageModel.list[indexPath.row] forCollectionView:collectionView atIndexPath:indexPath];
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
        CGFloat ratio = [_viewModel.issuePageModel.cover.image.ratio[1] floatValue]/[_viewModel.issuePageModel.cover.image.ratio[0] floatValue] ;
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat cellHeight = cellWidth*ratio;
        _headerViewHeight = cellHeight;
        return CGSizeMake(cellWidth, cellHeight);
    }
    if (indexPath.section == 1) {
        IssueItemModel *issueItem =_viewModel.issuePageModel.list[indexPath.row];
        if (issueItem.cellHeight == 0) {
            [CellForHomeIssuePage getSizeOfBodyCellWithEntity:issueItem];
        }
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, issueItem.cellHeight);
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat offsetNow = 0;
    static CGFloat offsetLastTime = 0;
    static CGFloat offsetChanged = 0;
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


#pragma mark ---------------------lazy load 懒加载---------------------------

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.allowsSelection = NO;
        
        NSArray *images = @[[UIImage imageNamed:@"Best"],[UIImage imageNamed:@"Issue"]];
        __weak HomePageIssueViewController *wself = self;
        [_collectionView addGifFooterRefresh:^{
            [wself.viewModel getDataByRequestMode:KWRequestModeMore PageName:@"Issue" completionHandler:^(NSError *error) {
                if(!error){
                    [wself.collectionView reloadData];
                    [wself.collectionView endFooterRefresh];
                }
            }];
        } andImagesforGif:images];        //上拉加载
        
        [CellForHomeIssuePage registerClassesforCollectionView:_collectionView];
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

#pragma mark ----------------setget函数---------------------------
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
}
@end