//
//  ViewForIssueItem.m
//  KWSHE
//
//  Created by kiwi on 16/5/13.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ViewForIssueItem.h"
#import "HomePageModel.h"
@interface ViewForIssueItem()
@property(nonatomic,strong) UIImageView *mainImageView;//背景图片
@property(nonatomic,strong) UILabel *mainLb;//带漂浮主文字
@property(nonatomic,strong) UILabel *descLb;//描述文字,小
@end

static const CGFloat padding = 20;
static const CGFloat bottomPadding = 30;
static const CGFloat mainLbFontSize = 34;
static const CGFloat descLbFontSize = 14;

@implementation ViewForIssueItem
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self constraintMake];
    }
    return self;
}
- (void)constraintMake{
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];
    
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.bottom.mas_equalTo(-bottomPadding);
    }];
    
    [self.mainLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(_mainImageView.mas_bottom).offset(-mainLbFontSize*0.5);
    }];
}

#pragma mark --------lazy load 懒加载-------------------

- (UIImageView *)mainImageView{
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //_mainImageView.backgroundColor = [UIColor lightGrayColor];
        _mainImageView.clipsToBounds = YES;
        [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_mainImageView];
    }
    return _mainImageView;
}

- (UILabel *)mainLb{
    if (_mainLb == nil){
        _mainLb = [[UILabel alloc]init];
        [_mainLb KWSetLabelWithFontName:@"Helvetica-Bold" fontSize:mainLbFontSize backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]]; //字体设置
        _mainLb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_mainLb];
    }
    return _mainLb;
}

- (UILabel *)descLb{
    if (_descLb == nil){
        _descLb = [[UILabel alloc]init];
        [_descLb KWSetLabelWithFontName:@"Helvetica" fontSize:descLbFontSize backgroundColor:[UIColor whiteColor] fontColor:[UIColor blackColor]]; //字体设置
        _descLb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_descLb];
    }
    return _descLb;
}

#pragma mark----------------------填充方法----------------------------------
+ (void)getSizelWithEntity:(id)entity{
    IssueItemModel *issueItem = entity;
    CGFloat ratio = [issueItem.image getImageRatio];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainImageHeight = width*ratio;
    ViewForIssueItem *view = [[ViewForIssueItem alloc]init];
    CGFloat mainLbHeight = [view.mainLb KWSetWithTextAndGetRowHeight:issueItem.title.text expectedWidth:[UIScreen mainScreen].bounds.size.width -padding*2];
    CGFloat descLbHeight = [view.descLb KWSetWithTextAndGetRowHeight:issueItem.desc.text expectedWidth:[UIScreen mainScreen].bounds.size.width -padding*2];
    issueItem.cellHeight = mainImageHeight+mainLbHeight+descLbHeight+bottomPadding;
}

-(void)fillWithEntity:(id)entity{
    IssueItemModel *issueItem = entity;
    CGFloat ratio = [issueItem.image getImageRatio];
    NSString *url = [issueItem.image getRequestUrlWithWidth:[UIScreen mainScreen].bounds.size.width];
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:url]];    
    [self.mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_width).multipliedBy(ratio);
        make.width.mas_equalTo(self.mas_width);
    }];
    _mainLb.text = issueItem.title.text;
    _descLb.text = issueItem.desc.text;
}
@end
