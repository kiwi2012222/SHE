//
//  ItemDetailPageViewModel.m
//  KWSHE
//
//  Created by kiwi on 16/5/25.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ItemDetailPageViewModel.h"
#import "ItemDetailPageModel.h"
#import "HomePageModel.h"

@implementation ItemDetailPageViewModel
- (ImageForHomePageModel *)getSlideImage{
    return self.itemDetailPageModel.slide[0].image;
}
- (NSString *)itemNameLb{
    return self.itemDetailPageModel.product.title;
}
- (NSString *)priceLb{
    NSString *str = self.itemDetailPageModel.product.price;
    NSInteger strLength = str.length;
    NSInteger location = strLength%3;
    NSString *newString = @"";
    for (int i = 0; i<strLength/3+1; i++) {
        if (i == 0) {
            newString = [newString stringByAppendingString:[str substringWithRange:NSMakeRange(0, location)]];
        }
        else{
            if (![newString isEqualToString:@""]) {
                newString = [newString stringByAppendingString:@","];
            }
            newString = [newString stringByAppendingString:[str substringWithRange:NSMakeRange((i-1)*3+location, 3)]];
        }
    }
    return newString;
}

- (NSString *)discountLb{
    if ([self.itemDetailPageModel.product.discount.percent isEqualToString:@"0"]) {
        return @"";
    }
    else{
        NSString *str = self.itemDetailPageModel.product.discount.price;
        NSInteger strLength = str.length;
        NSInteger location = strLength%3;
        NSString *newString = @"";
        for (int i = 0; i<strLength/3+1; i++) {
            if (i == 0) {
                newString = [newString stringByAppendingString:[str substringWithRange:NSMakeRange(0, location)]];
            }
            else{
                if (![newString isEqualToString:@""]) {
                    newString = [newString stringByAppendingString:@","];
                }
                newString = [newString stringByAppendingString:[str substringWithRange:NSMakeRange((i-1)*3+location, 3)]];
                
            }
        }
        return [NSString stringWithFormat:@"%@%% %@",self.itemDetailPageModel.product.discount.percent,newString];;
    }
}

- (NSString *)brandNameLb{
    return self.itemDetailPageModel.brandlink.branden;
}

- (NSString *)brandKrLb{
    return self.itemDetailPageModel.brandlink.brandkr;
}

- (NSString *)brandImage{
    return [self.itemDetailPageModel.brandlink.image getRequestUrlWithWidth:35];
}

-(NSUInteger)getNumberOfInfoSection{
    return self.itemDetailPageModel.info.count;
}

-(InfoModelForItemDetailPageModel *)getInfoForRow:(NSUInteger)row{
    return self.itemDetailPageModel.info[row];
}

-(NSUInteger)getNumberOfFeatureSection{
    return self.itemDetailPageModel.feature.count;
}

-(FeatureModelForItemDetailPageModel *)getFeatureForRow:(NSUInteger)row{
    return self.itemDetailPageModel.feature[row];
}

- (NSString *)descBasicLb{
    NSString *str = self.itemDetailPageModel.descBasic;
    return [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}

- (NSUInteger)getNumberOfDetailImageSection{
    return self.itemDetailPageModel.detailList.count;
}

- (ImageForHomePageModel *)getDetailImageForRow:(NSUInteger)row{
    return self.itemDetailPageModel.detailList[row].image;
}

- (void)getDataByRequestMode:(KWRequestMode)requestMode PageName:(NSString *)pageName completionHandler:(void (^)(NSError *))completionHandler{
    if (requestMode == KWRequestModeRefresh) {
        NSDictionary *para = @{@"idx":pageName,@"device":@"iphone"};
        [NSObject POST:@"http://www.29cm.co.kr/app/v3/shop/product.asp" parameters:para progress:nil completionHandler:^(id respondObj, NSError *error){
            if(!error){
                self.itemDetailPageModel = [ItemDetailPageModel modelWithJSON:respondObj];
            }
            completionHandler(error);
        }];        
    }
}

@end
