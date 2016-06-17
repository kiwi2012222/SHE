//
//  BrowseRecordModel.m
//  KWSHE
//
//  Created by kiwi on 16/6/5.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "BrowseRecordModel.h"

@implementation BrowseRecordModel
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_identity forKey:@"identity"];
    [aCoder encodeObject:_imagePath forKey:@"imagePath"];
}
//反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _identity = [aDecoder decodeObjectForKey:@"identity"];
        _imagePath = [aDecoder decodeObjectForKey:@"imagePath"];
    }
    return self;
}
@end
