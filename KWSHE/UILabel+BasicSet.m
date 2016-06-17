//
//  UILabel+BasicSet.m
//  demo_拖动放大表头
//
//  Created by kiwi on 16/4/16.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "UILabel+BasicSet.h"

@implementation UILabel (BasicSet)

- (void)KWSetLabelWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)bkColor fontColor:(UIColor *)fontColor
{
    self.font = [UIFont fontWithName:fontName size:fontSize];
    self.layer.masksToBounds = YES;
    self.backgroundColor = bkColor;
    self.textColor = fontColor;
    self.numberOfLines = 0;
}
- (CGFloat)KWSetWithTextAndGetRowHeight:(NSString *)labelText expectedWidth:(CGFloat)width{
    
    self.text = labelText;
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil];
    CGFloat height = [self.text boundingRectWithSize:CGSizeMake(width,100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    
    
    return height;
    
}

- (CGFloat)KWSetWithTextAndGetWidth:(NSString *)labelText{
    
    self.text = labelText;
    
    self.numberOfLines = 1;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil];
    CGFloat width = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    
    
    return width;
    
}


@end
