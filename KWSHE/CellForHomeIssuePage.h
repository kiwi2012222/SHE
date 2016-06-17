//
//  CellForHomeIssuePage.h
//  KWSHE
//
//  Created by kiwi on 16/5/4.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IssueItemModel;
@interface CellForHomeIssuePage : UICollectionViewCell
+ (instancetype)getChangeableHeaderCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

+ (id)getBestItemCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

+ (void)getSizeOfBodyCellWithEntity:(id)entity;

+ (void)registerClassesforCollectionView:(UICollectionView *)collectionView;

- (void)changeWithOffset:(CGFloat)offset;
@end
