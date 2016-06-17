//
//  CellFoeHomeBestPage.m
//  KWSHE
//
//  Created by kiwi on 16/5/9.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "CellForHomeBestPage.h"
#import "ChangeableHeaderView.h"
#import "ViewForBestItemCell.h"
#import "HomePageModel.h"
@implementation CellForHomeBestPage
+ (instancetype)getChangeableHeaderCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath
{
    CellForHomeBestPage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"changeableCell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        ChangeableHeaderView *view = [[ChangeableHeaderView alloc]initWithFrame:CGRectZero];
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    [cell.contentView.subviews[0] fillWithEntity:entity];
     return cell;
}

+ (CGSize)getSizeOfChangeableHeaderCellWithEntity:(id)entity{
    return CGSizeZero;
}

+ (id)getBestItemCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    CellForHomeBestPage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bestItemCell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        ViewForBestItemCell *view = [[ViewForBestItemCell alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:cell action:@selector(tapped:)];
        [cell.contentView addGestureRecognizer:tap];
    }
    [cell.contentView.subviews[0] fillWithEntity:entity];
    BestItemModel *item = entity;
    cell.itemIdentity = item.idForBestItem;

    return cell;
    
}

+ (CGSize)getSizeOfBodyCellWithEntity:(id)entity{
    return CGSizeZero;
}

+ (void)registerClassesforCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[CellForHomeBestPage class] forCellWithReuseIdentifier:@"changeableCell"];
    [collectionView registerClass:[CellForHomeBestPage class] forCellWithReuseIdentifier:@"bestItemCell"];
}

- (void)changeWithOffset:(CGFloat)offset{    
    if ([self.reuseIdentifier  isEqual: @"changeableCell"]) {
        [self.contentView.subviews[0] changeWithOffset:offset];
    }
}
#pragma mark------------自定义代理方法---------------------
- (void)tapped:(UITapGestureRecognizer *)tapgr{
    [_delegate KWitemDetailClicked:self.itemIdentity];
}
@end