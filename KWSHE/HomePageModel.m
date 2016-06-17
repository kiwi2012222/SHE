//
//  HomePageModel.m
//  KWSHE
//
//  Created by kiwi on 16/5/3.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel
+(instancetype)ModelCreateWithJson:(id)responseObj{         //转模型加号方法
    HomePageModel *homeModel = [[HomePageModel alloc]init];
    NSDictionary *dict = responseObj;
    NSArray *topItems = dict[@"list"];
    homeModel.channel = [ChannelModelForHomePageModel modelWithJSON:topItems[1]];
    homeModel.issue = [IssueModelForHomePageModel modelWithJSON:topItems[0]];
    homeModel.best = [BestModelForHomePageModel modelWithJSON:topItems[2]];
    return homeModel;
}
@end

@implementation ChannelModelForHomePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[ChannelItemModel class]
             };
}
@end

@implementation ChannelItemModel

@end

@implementation IssueModelForHomePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[IssueItemModel class]
             };
}
+(instancetype)ModelCreateWithJson:(id)responseObj       //转模型加号方法
{
    IssueModelForHomePageModel *issueModel = [[IssueModelForHomePageModel alloc]init];
    issueModel = [IssueModelForHomePageModel modelWithJSON:responseObj];
    return issueModel;
}
@end

@implementation IssueItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"
             };
}
@end

@implementation BestModelForHomePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[BestItemModel class]
             };
}

+(instancetype)ModelCreateWithJson:(id)responseObj       //转模型加号方法
{
    BestModelForHomePageModel *bestModel = [[BestModelForHomePageModel alloc]init];
    bestModel = [BestModelForHomePageModel modelWithJSON:responseObj];
    return bestModel;
}
@end

@implementation BestItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idForBestItem" : @"id"
             };
}
@end

@implementation CoverForHomePageModel

@end

@implementation ImageForHomePageModel
/**
 *  获得图片的长宽比
 */
- (CGFloat)getImageRatio{
    if (self.ratio[0] == nil) {
        return 0;
    }
    if (self.ratio[0]>0&&self.ratio[1]>0) {
        return [self.ratio[1] floatValue]/[self.ratio[0] floatValue];
    }
    return 0;
}
/**
 *  根据宽度获取图片的requestURL
 */
- (NSString *)getRequestUrlWithWidth:(CGFloat)width{
    CGFloat ratio = [self getImageRatio];
    NSNumber *requestWidth =[NSNumber numberWithInt:[[NSNumber numberWithFloat:width*[UIScreen mainScreen].scale] intValue]];
    NSNumber *requestHeight = [NSNumber numberWithInt:[[NSNumber numberWithFloat:width*ratio*[UIScreen mainScreen].scale] intValue]];
    NSString *url = [[[[self.path stringByAppendingString:@"?cmd=thumb&width="]stringByAppendingString:[requestWidth stringValue]]stringByAppendingString:@"&height="]stringByAppendingString:[requestHeight stringValue]];
    return url;
}
@end

@implementation LinkForHomePageModel

@end

@implementation TitleForHomePageModel

@end

@implementation DescriptionForHomePageModel

@end

@implementation DiscountForHomePageModel

@end







