//
//  ChangeableHeaderView.h
//  KWSHE
//
//  Created by kiwi on 16/5/6.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeableHeaderView : UIView
- (void)fillWithEntity:(id)entity;
- (void)changeWithOffset:(CGFloat)offset;
@end
