//
//  ViewForBestItemCell.m
//  KWSHE
//
//  Created by kiwi on 16/5/11.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ViewForBestItemCell.h"
#import "HomePageModel.h"
@interface ViewForBestItemCell()
@property(nonatomic,strong) UIImageView *mainImageView;//背景图片
@property(nonatomic,strong) UILabel *priceLb;//价格
@property(nonatomic,strong) UILabel *discountLb;//红色打折比例文字
@property(nonatomic,strong) NSString *itemIdentity;//商品ID记录
@end

@implementation ViewForBestItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self constraintMake];
    }
    return self;
}
- (void)constraintMake{
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_width);
    }];
    [self.discountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.left.mas_equalTo(12);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.left.mas_equalTo(_discountLb.mas_right).offset(2);
    }];
}

#pragma mark -------------------------懒加载--------------------------------------
- (UIImageView *)mainImageView{
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mainImageView.clipsToBounds = YES;
        [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_mainImageView];
    }
    return _mainImageView;
}

- (UILabel *)discountLb{
    if (_discountLb == nil){
        _discountLb = [[UILabel alloc]init];
        [_discountLb KWSetLabelWithFontName:@"AmericanTypewriter-Bold" fontSize:12 backgroundColor:[UIColor clearColor] fontColor:[UIColor redColor]]; //字体设置
        _discountLb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_discountLb];
    }
    return _discountLb;
}

- (UILabel *)priceLb{
    if (_priceLb == nil){
        _priceLb = [[UILabel alloc]init];
        [_priceLb KWSetLabelWithFontName:@"AmericanTypewriter-Bold" fontSize:12 backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]]; //字体设置
        _priceLb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_priceLb];
    }
    return _priceLb;
}
#pragma mark ---------------------------填充方法------------------------------------
-(void)fillWithEntity:(id)entity{
    BestItemModel *bestItem = entity;
    NSNumber *requestWidth =[NSNumber numberWithInt:[[NSNumber numberWithFloat:self.frame.size.width*[UIScreen mainScreen].scale] intValue]];
    NSString *url = [[[[bestItem.image.path stringByAppendingString:@"?cmd=thumb&width="]stringByAppendingString:[requestWidth stringValue]]stringByAppendingString:@"&height="]stringByAppendingString:[requestWidth stringValue]];
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    _priceLb.text = bestItem.discount.price;
    if ([bestItem.discount.percent isEqualToString:@"0"]) {
        _discountLb.text = @"";
        [_priceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-4);
            make.left.mas_equalTo(12);
        }];
    }
    else{
        _discountLb.text = [bestItem.discount.percent stringByAppendingString:@"%"];
        [_priceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-4);
            make.left.mas_equalTo(_discountLb.mas_right).offset(2);
        }];
    }
}

@end
