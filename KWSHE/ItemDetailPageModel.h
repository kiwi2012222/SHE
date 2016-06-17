//
//  ItemDetailPageModel.h
//  KWSHE
//
//  Created by kiwi on 16/5/24.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DiscountForHomePageModel,BestItemModel,ImageForHomePageModel,ProductModelForItemDetailPageModel,InfoModelForItemDetailPageModel,BrandlinkModelForItemDetailPageModel,FeatureModelForItemDetailPageModel,BannerModelForItemDetailPageModel,SizechartModelForItemDetailPageModel,ShareModelForItemDetailPageModel,LinkForHomePageModel,ContentsModelForItemDetailPageModel,ListModelForSizeChart,DetailListModelForItemDetailPageModel,SlideModelForItemDetailPageModel;
@interface ItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) ProductModelForItemDetailPageModel *product;
@property (nonatomic, strong) NSArray<InfoModelForItemDetailPageModel *> *info; //详细信息列表
@property (nonatomic, strong) BrandlinkModelForItemDetailPageModel *brandlink;
@property (nonatomic, assign) NSInteger reviewCount;
@property (nonatomic, assign) NSInteger qnaCount;
@property (nonatomic, strong) NSArray<DetailListModelForItemDetailPageModel *> *detailList;  //详情图片列表
@property (nonatomic, strong) NSArray<FeatureModelForItemDetailPageModel *> *feature;  //商品详情列表
@property (nonatomic, strong) NSArray<SlideModelForItemDetailPageModel *> *slide;  //表头滑动图片列表
@property (nonatomic, copy) NSString *descBasic;
@property (nonatomic, copy) NSString *descCaution;
@property (nonatomic, copy) NSString *descDelivery;
@property (nonatomic, copy) NSString *descAs;
@property (nonatomic, strong) NSArray<BestItemModel *> *related;  //相关商品列表(正方形展示)
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *isLast;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, strong) NSArray<BannerModelForItemDetailPageModel *> *banner;  //banner列表
@property (nonatomic, strong) SizechartModelForItemDetailPageModel *sizechart;
@property (nonatomic, strong) ShareModelForItemDetailPageModel *share;

+(instancetype)ModelCreateWithJson:(id)responseObj;
@end

@interface DetailListModelForItemDetailPageModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@end

@interface ProductModelForItemDetailPageModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, strong) DiscountForHomePageModel *discount;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, copy) NSString *buynow;
@property (nonatomic, copy) NSString *buyadult;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *isHeart;
@end

@interface BrandlinkModelForItemDetailPageModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, copy) NSString *brandkr;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, copy) NSString *branden;
@end


@interface SizechartModelForItemDetailPageModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray<InfoModelForItemDetailPageModel *> *info;  //info列表
@property (nonatomic, strong) NSArray<ListModelForSizeChart *> *list;  //list列表
@end

@interface InfoModelForItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@end

@interface ListModelForSizeChart : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<NSNumber *> *record;
@end

@interface ShareModelForItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *text;
@end

@interface BannerModelForItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) ContentsModelForItemDetailPageModel *contents;
@end

@interface ContentsModelForItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, strong) LinkForHomePageModel *link;
@end

@interface FeatureModelForItemDetailPageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@end

@interface SlideModelForItemDetailPageModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@end

@interface RelatedModelForItemDetailPageModel : NSObject
@property (nonatomic, strong) DiscountForHomePageModel *discount;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, copy) NSString *price;
@end


