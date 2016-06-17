//
//  HomePageModel.h
//  KWSHE
//
//  Created by kiwi on 16/5/3.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChannelModelForHomePageModel,ChannelItemModel,IssueModelForHomePageModel,IssueItemModel,BestModelForHomePageModel,BestItemModel,CoverForHomePageModel,ImageForHomePageModel,LinkForHomePageModel,TitleForHomePageModel,DescriptionForHomePageModel,DiscountForHomePageModel
;

@interface HomePageModel : NSObject
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *footer;
@property (nonatomic, strong) ChannelModelForHomePageModel *channel;
@property (nonatomic, strong) IssueModelForHomePageModel *issue;
@property (nonatomic, strong) BestModelForHomePageModel *best;
+(instancetype)ModelCreateWithJson:(id)responseObj;
@end

@interface ChannelModelForHomePageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) CoverForHomePageModel *cover;
@property (nonatomic, strong) NSArray<ChannelItemModel *> *list;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *isLast;
@property (nonatomic, copy) NSString *totChannel;
@property (nonatomic, copy) NSString *limit;
@end


@interface ChannelItemModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, strong) LinkForHomePageModel *link;
@end

@interface IssueModelForHomePageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) CoverForHomePageModel *cover;
@property (nonatomic, strong) NSArray<IssueItemModel *> *list;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *isLast;
@property (nonatomic, copy) NSString *limit;
+(instancetype)ModelCreateWithJson:(id)responseObj;
@end

@interface IssueItemModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, strong) TitleForHomePageModel *title;
@property (nonatomic, strong) DescriptionForHomePageModel *desc;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, strong) LinkForHomePageModel *link;
@property (nonatomic, assign)CGFloat cellHeight;//此处用于缓存生成cell的高度,并不对应json信息
@end


@interface BestModelForHomePageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) CoverForHomePageModel *cover;
@property (nonatomic, strong) NSArray<BestItemModel *> *list;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *isLast;
@property (nonatomic, copy) NSString *limit;
+(instancetype)ModelCreateWithJson:(id)responseObj;
@end

@interface BestItemModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, strong) DiscountForHomePageModel *discount;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *idForBestItem;
@end

@interface TitleForHomePageModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *color;
@end

@interface DescriptionForHomePageModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *color;
@end

@interface LinkForHomePageModel : NSObject
@property (nonatomic, copy) NSString *menu;
@property (nonatomic, copy) NSString *value1;
@property (nonatomic, copy) NSString *value2;
@property (nonatomic, copy) NSString *value3;
@end

@interface CoverForHomePageModel : NSObject
@property (nonatomic, strong) ImageForHomePageModel *image;
@property (nonatomic, strong) TitleForHomePageModel *title;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) LinkForHomePageModel *link;
@end

@interface ImageForHomePageModel : NSObject
@property (nonatomic, strong) NSArray<NSNumber *> *ratio;
@property (nonatomic, copy) NSString *path;
- (CGFloat)getImageRatio;
- (NSString *)getRequestUrlWithWidth:(CGFloat)width;
@end

@interface DiscountForHomePageModel : NSObject
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *percent;
@end
