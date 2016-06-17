//
//  ChangeableHeaderView.m
//  KWSHE
//
//  Created by kiwi on 16/5/6.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ChangeableHeaderView.h"
#import "HomePageModel.h"

@interface ChangeableHeaderView()
@property(nonatomic,strong) UIImageView *mainImageView;//背景图片
@property(nonatomic,strong) UILabel *mainLabel;//标题文字(大)
@property(nonatomic,strong) UIView *imageMaskLayerForMainImageView;//image的透明渐变的覆盖层
@end

static const CGFloat originOpacity = 0.05;
//http://image.29cm.co.kr/contents/channel/201605/20160516105831.jpg

@implementation ChangeableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self constraintMake];
    }
    return self;
}
- (void)constraintMake{
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_mainImageView);
        make.width.mas_equalTo(self);
    }];
    [self.imageMaskLayerForMainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(_mainImageView);
    }];
}
#pragma mark ------------------懒加载-------------------------------------
- (UIImageView *)mainImageView{
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc]init];
        [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_mainImageView];
    }
    return _mainImageView;
}

- (UILabel *)mainLabel{
    if (_mainLabel == nil){
        _mainLabel = [[UILabel alloc]init];
        [_mainLabel KWSetLabelWithFontName:@"Georgia-Bold" fontSize:35 backgroundColor:[UIColor clearColor] fontColor:[UIColor whiteColor]]; //字体设置
        _mainLabel.textAlignment = NSTextAlignmentCenter;//文字居中
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

- (UIView *)imageMaskLayerForMainImageView{
    if (_imageMaskLayerForMainImageView == nil) {
        _imageMaskLayerForMainImageView = [[UIView alloc]initWithFrame:CGRectZero];
        _imageMaskLayerForMainImageView.backgroundColor = [UIColor blackColor];
        _imageMaskLayerForMainImageView.layer.opacity = originOpacity;
        [self addSubview:_imageMaskLayerForMainImageView];

    }
    return _imageMaskLayerForMainImageView;
}


- (void)fillWithEntity:(id)entity{
    CoverForHomePageModel *cover = entity;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:cover.image.path]];
    _mainLabel.text = cover.title.text;
}

- (void)changeWithOffset:(CGFloat)offset{
    [_mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(offset);
        make.left.right.bottom.mas_equalTo(0);
    }];
    if (offset>=0) {
        CGFloat opacity = offset/(self.frame.size.height-64)*offset/(self.frame.size.height-64)*(1-originOpacity)+originOpacity;
        _imageMaskLayerForMainImageView.layer.opacity = opacity;
        [_imageMaskLayerForMainImageView setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

@end
