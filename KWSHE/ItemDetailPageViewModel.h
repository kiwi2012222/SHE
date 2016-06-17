//
//  ItemDetailPageViewModel.h
//  KWSHE
//
//  Created by kiwi on 16/5/25.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemDetailPageModel,InfoModelForItemDetailPageModel,FeatureModelForItemDetailPageModel,ImageForHomePageModel
;

@interface ItemDetailPageViewModel : NSObject

@property (nonatomic,strong)ItemDetailPageModel *itemDetailPageModel;

- (ImageForHomePageModel *)getSlideImage;
- (NSString *)itemNameLb;
- (NSString *)priceLb;
- (NSString *)discountLb;

- (NSString *)brandImage;
- (NSString *)brandNameLb;
- (NSString *)brandKrLb;

- (NSUInteger)getNumberOfInfoSection;
-(InfoModelForItemDetailPageModel *)getInfoForRow:(NSUInteger)row;

-(NSUInteger)getNumberOfFeatureSection;
-(FeatureModelForItemDetailPageModel *)getFeatureForRow:(NSUInteger)row;

- (NSString *)descBasicLb;

- (NSUInteger)getNumberOfDetailImageSection;
- (ImageForHomePageModel *)getDetailImageForRow:(NSUInteger)row;

/**
 *  获取页面json数据
 */
-(void)getDataByRequestMode:(KWRequestMode)requestMode PageName:(NSString *)pageName completionHandler:(void(^)(NSError *error))completionHandler;

@end
