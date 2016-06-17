//
//  ItemDetailPageModel.m
//  KWSHE
//
//  Created by kiwi on 16/5/25.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ItemDetailPageModel.h"
#import "HomePageModel.h"
@implementation ItemDetailPageModel

+(instancetype)ModelCreateWithJson:(id)responseObj
{
    ItemDetailPageModel *itemDetailPageModel = [[ItemDetailPageModel alloc]init];
    itemDetailPageModel = [ItemDetailPageModel modelWithDictionary:responseObj];
    return itemDetailPageModel;

}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"detailList":[DetailListModelForItemDetailPageModel class], ///此处应该是"detailList"而不是原json中的"list"
             
             @"info":[InfoModelForItemDetailPageModel class],
             @"feature":[FeatureModelForItemDetailPageModel class],
             @"slide":[SlideModelForItemDetailPageModel class],
             @"related":[BestItemModel class],
             @"banner":[BannerModelForItemDetailPageModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descCaution" : @"desc_caution",
             @"descBasic" : @"desc_basic",
             @"descDelivery" : @"desc_delivery",
             @"descAs" : @"desc_as",
             @"detailList" : @"list"
             };
}
@end
@implementation DetailListModelForItemDetailPageModel

@end

@implementation ProductModelForItemDetailPageModel

@end

@implementation BrandlinkModelForItemDetailPageModel

@end


@implementation SizechartModelForItemDetailPageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[ListModelForSizeChart class],
             @"info":[InfoModelForItemDetailPageModel class]
             };
}
@end

@implementation InfoModelForItemDetailPageModel

@end

@implementation ListModelForSizeChart

@end

@implementation ShareModelForItemDetailPageModel

@end

@implementation BannerModelForItemDetailPageModel

@end

@implementation ContentsModelForItemDetailPageModel

@end

@implementation FeatureModelForItemDetailPageModel

@end

@implementation SlideModelForItemDetailPageModel

@end

@implementation RelatedModelForItemDetailPageModel

@end