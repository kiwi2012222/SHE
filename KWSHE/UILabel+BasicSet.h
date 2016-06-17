//
//  UILabel+BasicSet.h
//  demo_拖动放大表头
//
//  Created by kiwi on 16/4/16.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BasicSet)

- (void)KWSetLabelWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)bkColor fontColor:(UIColor *)fontColor;

- (CGFloat)KWSetWithTextAndGetRowHeight:(NSString *)labelText expectedWidth:(CGFloat)width;

- (CGFloat)KWSetWithTextAndGetWidth:(NSString *)labelText;
@end
