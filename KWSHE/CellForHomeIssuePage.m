//
//  CellForHomeIssuePage.m
//  demo_拖动放大表头
//
//  Created by kiwi on 16/4/14.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "CellForHomeIssuePage.h"
#import "ChangeableHeaderView.h"
#import "ViewForIssueItem.h"

@interface CellForHomeIssuePage ()

@end


@implementation CellForHomeIssuePage

#pragma mark---------------表格建设---------------------------
+ (instancetype)getChangeableHeaderCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    CellForHomeIssuePage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"changeableCell" forIndexPath:indexPath];
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

+ (id)getBestItemCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    CellForHomeIssuePage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"issueItemCell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        ViewForIssueItem *view = [[ViewForIssueItem alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    [cell.contentView.subviews[0] fillWithEntity:entity];
    return cell;
}

+ (void)getSizeOfBodyCellWithEntity:(id)entity{
    [ViewForIssueItem getSizelWithEntity:entity];
}

+(void)registerClassesforCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[CellForHomeIssuePage class] forCellWithReuseIdentifier:@"changeableCell"];
    [collectionView registerClass:[CellForHomeIssuePage class] forCellWithReuseIdentifier:@"issueItemCell"];
}

#pragma mark --------------动画效果--------------------------
- (void)changeWithOffset:(CGFloat)offset{
    if ([self.reuseIdentifier  isEqual: @"changeableCell"]) {
        [self.contentView.subviews[0] changeWithOffset:offset];
    }
}





@end
