//
//  CellFoeHomeBestPage.h
//  KWSHE
//
//  Created by kiwi on 16/5/9.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChangeableHeaderView;

@protocol KWBestCellDelegate<NSObject>

- (void)KWitemDetailClicked:(NSString *)itemIdentity;

@end

@interface CellForHomeBestPage : UICollectionViewCell

@property (nonatomic,weak) id<KWBestCellDelegate> delegate;
@property (nonatomic,copy) NSString *itemIdentity;

+ (instancetype)getChangeableHeaderCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath ;

+ (id)getBestItemCellWithEntity:(id)entity forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
+ (CGSize)getSizeOfChangeableHeaderCellWithEntity:(id)entity;
+ (CGSize)getSizeOfBodyCellWithEntity:(id)entity;

+ (void)registerClassesforCollectionView:(UICollectionView *)collectionView;

- (void)changeWithOffset:(CGFloat)offset;
@end
