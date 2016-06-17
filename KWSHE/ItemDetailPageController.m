//
//  ItemDetailPageController.m
//  KWSHE
//
//  Created by kiwi on 16/5/23.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "ItemDetailPageController.h"
#import "ItemDetailPageModel.h"
#import "HomePageModel.h"
#import "ItemDetailPageViewModel.h"
#import "AppDelegate.h"

#import "EntryButtonViewForMenuViewController.h"


@interface ItemDetailPageController()
@property (nonatomic,strong)ItemDetailPageViewModel *viewModel;
@property (nonatomic,strong)UIView *loadingView;

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *slidePictureView;
@property (nonatomic,strong)UIView *topSection;
@property (nonatomic,strong)UIView *brandSection;
@property (nonatomic,strong)UIView *infoSection;
@property (nonatomic,strong)UIView *sizeChartSection;
@property (nonatomic,strong)UIView *buttonForDetailSection;
@property (nonatomic,strong)UIView *detailSection;

@property (nonatomic,strong)UIView *featureSection;
@property (nonatomic,strong)UIView *descBasicSection;
@property (nonatomic,strong)UIView *detailImageSection;

@property (nonatomic,strong)UIView *commentSection;

@property (nonatomic,strong)UIView *navigationBarForImformation;
@property (nonatomic,strong)UIView *navigationBarForButton;
@property (nonatomic,strong)EntryButtonViewForMenuViewController *menuButtonView;

@property (nonatomic,assign)CGFloat topImageViewHeight;
@end
static const CGFloat padding = 10;
static const CGFloat commonLineSpacing = 10;
static const CGFloat buttonWidth = 30;

@implementation ItemDetailPageController

#pragma mark ---------------life cycle 生命周期--------------------------------
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    NSLog(@"viewdidload");
    [self loading];
    [self loadViewModel];
}

- (void)loading{
    _loadingView = [[UIView alloc]init];
    _loadingView.backgroundColor = [UIColor colorWithHexString:@"C1FFC2"];
    _loadingView.layer.cornerRadius = 5;
    [self.view addSubview:_loadingView];
    
    CABasicAnimation *anim = [CABasicAnimation animation];    //loadingView加载时添加动画
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.toValue = @2;
    anim.duration = 0.7;
    anim1.keyPath = @"opacity";
    anim1.toValue = @0.6;
    anim1.duration = 0.7;
    anim.repeatCount = MAXFLOAT;
    anim1.repeatCount = MAXFLOAT;
    [_loadingView.layer addAnimation:anim forKey:nil];
    [_loadingView.layer addAnimation:anim1 forKey:nil];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.width.mas_equalTo(10);
    }];

    [self.navigationBarForButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    self.topBarIsShowing=YES;
    
    //[_menuButtonView closeMenu];
}
- (void)loadViewModel{
    _viewModel = [[ItemDetailPageViewModel alloc]init];
    [_viewModel getDataByRequestMode:KWRequestModeRefresh PageName:self.itemIdentity completionHandler:^(NSError *error) {
        if(!error){
            [self constraintMake];
        }
    }];
}
- (void)constraintMake{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.navigationBarForImformation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    
    //--------初始动画
    _scrollView.transform = CGAffineTransformMakeTranslation(0,-_topImageViewHeight);
    _slidePictureView.transform = CGAffineTransformMakeTranslation(0,_topImageViewHeight*0.5);
    _scrollView.layer.opacity = 0;
    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        _loadingView.layer.opacity = 0;
        _scrollView.transform = CGAffineTransformIdentity;
        _slidePictureView.transform = CGAffineTransformIdentity;
        _scrollView.layer.opacity = 1;
    } completion:^(BOOL finished) {
    }];
    
    [_menuButtonView addBrowsedItemWithIdentity:self.itemIdentity andimage:_viewModel.getSlideImage];
}
- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark ------------------------lazy load 懒加载-------------------------------------
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.clipsToBounds = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:_scrollView aboveSubview:_loadingView];
        
        [self slidePictureView];
        [self topSection];
        [self brandSection];
        [self infoSection];
        [self sizeChartSection];
        [self buttonForDetailSection];   //详情展开按钮
        [self commentSection];

        [_topSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_slidePictureView.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.bottom.mas_equalTo(_topSection.subviews[_topSection.subviews.count-1].mas_bottom);
        }];
        [_brandSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topSection.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
        }];
        [_infoSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_brandSection.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.bottom.mas_equalTo(_infoSection.subviews[_infoSection.subviews.count-1].mas_bottom).offset(padding);
        }];
        [_sizeChartSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_infoSection.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
        }];
        
        [_buttonForDetailSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_sizeChartSection.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.bottom.mas_equalTo(_buttonForDetailSection.subviews[_buttonForDetailSection.subviews.count-1].mas_bottom).offset(padding);
            
            make.bottom.mas_equalTo(_commentSection.mas_top); //设置与下一个Section的距离
        }];
        
        [_commentSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.height.mas_equalTo(800);
            
            make.bottom.mas_equalTo(0);  //此处约束为了填充scrollview的contentsize高度;
        }];
        
    }
    return _scrollView;
}
- (UIView *)slidePictureView{                           
    if (_slidePictureView == nil) {
        _slidePictureView = [[UIView alloc]init];
        [_scrollView addSubview:_slidePictureView];
        UIImageView *slideIv = [[UIImageView alloc]init];
        [slideIv setContentMode:UIViewContentModeScaleAspectFill];
        [_slidePictureView addSubview:slideIv];
        
        [slideIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);

            make.bottom.mas_equalTo(_slidePictureView.mas_bottom);
            make.left.right.mas_equalTo(0);
        }];
        
        ImageForHomePageModel *image = [_viewModel getSlideImage];
        _topImageViewHeight = floorf([UIScreen mainScreen].bounds.size.width * [image getImageRatio]);
        [_slidePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_scrollView.mas_width);
            make.height.mas_equalTo(_topImageViewHeight);
        }];

        [slideIv sd_setImageWithURL:[NSURL URLWithString:[image getRequestUrlWithWidth:[UIScreen mainScreen].bounds.size.width]]];
    }
    return _slidePictureView;
}
- (UIView *)topSection{
    if (_topSection == nil) {
        _topSection = [[UIView alloc]init];
        _topSection.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_topSection];
        
        UILabel *itemNameLb = [[UILabel alloc]init];     //1
        [itemNameLb KWSetLabelWithFontName:@"Aapex" fontSize:25 backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]];
        [itemNameLb KWSetWithTextAndGetRowHeight:_viewModel.itemNameLb expectedWidth:100];
        [_topSection addSubview:itemNameLb];
        
        
        UILabel *priceLb = [[UILabel alloc]init];        //2
        [priceLb KWSetLabelWithFontName:@"Aapex" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor lightGrayColor]];
        [priceLb KWSetWithTextAndGetRowHeight:_viewModel.priceLb expectedWidth:100];
        [_topSection addSubview:priceLb];
        
        
        UILabel *discountLb = [[UILabel alloc]init];     //3
        [discountLb KWSetLabelWithFontName:@"Aapex" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor redColor]];
        [discountLb KWSetWithTextAndGetRowHeight:_viewModel.discountLb expectedWidth:100];
        [_topSection addSubview:discountLb];
        
        UIView *separator = [[UILabel alloc]init];       //4
        separator.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        [_topSection addSubview:separator];
        
        
        [itemNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-itemNameLb.font.lineHeight/2);
            make.left.mas_equalTo(padding);
            make.width.mas_equalTo(250);
        }];
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemNameLb.mas_bottom).offset(padding);
            make.left.mas_equalTo(padding);
            make.width.mas_equalTo(itemNameLb.mas_width);
            
            make.height.mas_equalTo(16);
        }];
        
        [discountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceLb.mas_bottom).offset(0);
            make.left.mas_equalTo(padding);
            make.width.mas_equalTo(itemNameLb.mas_width);
            
            make.height.mas_equalTo(16);
        }];
        
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(discountLb.mas_bottom).offset(commonLineSpacing);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(1);
        }];
    }
    return _topSection;
}
- (UIView *)brandSection{
    if (_brandSection == nil) {
        _brandSection = [[UIView alloc]init];
        _brandSection.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_brandSection];
        
        UIImageView *brandImage = [[UIImageView alloc]init];  //1
        [brandImage setContentMode:UIViewContentModeScaleAspectFill];
        [brandImage sd_setImageWithURL:[NSURL URLWithString:_viewModel.brandImage]];
        [_brandSection addSubview:brandImage];
        
        UILabel *brandNameLb = [[UILabel alloc]init];        //2
        [brandNameLb KWSetLabelWithFontName:@"Aachen BT" fontSize:18 backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]];
        [brandNameLb KWSetWithTextAndGetRowHeight:_viewModel.brandNameLb expectedWidth:100];
        [_brandSection addSubview:brandNameLb];
        
        UILabel *brandKrLb = [[UILabel alloc]init];        //3
        [brandKrLb KWSetLabelWithFontName:@"Aachen BT" fontSize:10 backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]];
        [brandKrLb KWSetWithTextAndGetRowHeight:_viewModel.brandKrLb expectedWidth:100];
        [_brandSection addSubview:brandKrLb];
        
        [brandImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(padding);
            make.left.mas_equalTo(padding);
            make.bottom.mas_equalTo(-padding*3);
            make.width.height.mas_equalTo(35);
        }];
        
        [brandNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(padding);
            make.left.mas_equalTo(brandImage.mas_right).offset(10);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(18);
        }];
        
        [brandKrLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(brandNameLb.mas_bottom).offset(4);
            make.left.mas_equalTo(brandNameLb.mas_left);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(10);
        }];
    }
    return _brandSection;
}
- (UIView *)infoSection{
    if (_infoSection == nil) {
        _infoSection = [[UIView alloc]init];
        _infoSection.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_infoSection];
        
        for (int i = 0 ; i<[_viewModel getNumberOfInfoSection]; i++) {
            UIView *infoContentView = [[UIView alloc]init];
            [_infoSection addSubview:infoContentView];
            
            UILabel *infoTitleLb = [[UILabel alloc]init];        //1
            [infoTitleLb KWSetLabelWithFontName:@"Aapex" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor lightGrayColor]];
            infoTitleLb.numberOfLines = 1;
            [infoTitleLb KWSetWithTextAndGetRowHeight:[_viewModel getInfoForRow:i].title expectedWidth:100];
            [infoContentView addSubview:infoTitleLb];
            
            UILabel *infoTextLb = [[UILabel alloc]init];         //2
            [infoTextLb KWSetLabelWithFontName:@"HelveticaNeue-Bold" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor lightGrayColor]];
            [infoTextLb KWSetWithTextAndGetRowHeight:[_viewModel getInfoForRow:i].text expectedWidth:100];
            [infoContentView addSubview:infoTextLb];
            
            
            [infoTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(padding);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            [infoTextLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(infoTitleLb.mas_right).offset(10);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-100);
                make.top.bottom.mas_equalTo(0);
            }];
            
            [infoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(0);
                }
                else{
                    make.top.mas_equalTo(_infoSection.subviews[i-1].mas_bottom).offset(10);
                }
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
            }];
        }
    }
    return _infoSection;
}
- (UIView *)sizeChartSection{
    if (_sizeChartSection == nil) {
        _sizeChartSection = [[UIView alloc]init];
        _sizeChartSection.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_sizeChartSection];
        
        UIView *sizeChartLeft = [[UIView alloc]init];
        sizeChartLeft.layer.borderWidth = 1;
        sizeChartLeft.layer.borderColor = [UIColor grayColor].CGColor;
        [_sizeChartSection addSubview:sizeChartLeft];
        
        UIView *sizeChartRight = [[UIView alloc]init];
        sizeChartRight.backgroundColor = [UIColor grayColor];
        [_sizeChartSection addSubview:sizeChartRight];
        
        UILabel *sLb = [[UILabel alloc]init];
        sLb.textAlignment = NSTextAlignmentCenter;
        [sLb KWSetLabelWithFontName:@"Aapex" fontSize:18 backgroundColor:[UIColor clearColor] fontColor:[UIColor grayColor]];
        [sLb KWSetWithTextAndGetRowHeight:@"S" expectedWidth:100];
        [sizeChartLeft addSubview:sLb];
        
        UILabel *mLb = [[UILabel alloc]init];
        mLb.textAlignment = NSTextAlignmentCenter;
        [mLb KWSetLabelWithFontName:@"Aapex" fontSize:18 backgroundColor:[UIColor clearColor] fontColor:[UIColor grayColor]];
        [mLb KWSetWithTextAndGetRowHeight:@"M" expectedWidth:100];
        [sizeChartLeft addSubview:mLb];
        
        UILabel *lLb = [[UILabel alloc]init];
        lLb.textAlignment = NSTextAlignmentCenter;
        [lLb KWSetLabelWithFontName:@"Aapex" fontSize:18 backgroundColor:[UIColor clearColor] fontColor:[UIColor grayColor]];
        [lLb KWSetWithTextAndGetRowHeight:@"L" expectedWidth:100];
        [sizeChartLeft addSubview:lLb];
        
        UILabel *rightLb = [[UILabel alloc]init];
        rightLb.textAlignment = NSTextAlignmentCenter;
        [rightLb KWSetLabelWithFontName:@"Aapex" fontSize:18 backgroundColor:[UIColor clearColor] fontColor:[UIColor whiteColor]];
        [rightLb KWSetWithTextAndGetRowHeight:@"ABOUT SIZE" expectedWidth:100];
        [sizeChartRight addSubview:rightLb];
        
        //1级
        [sizeChartLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(lLb.mas_right);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(-20);
            make.top.mas_equalTo(20);
        }];
        [sizeChartRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sizeChartLeft.mas_right);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(-20);
            make.top.mas_equalTo(20);
        }];
        
        //2级
        [sLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(sizeChartLeft.mas_height);
        }];
        [mLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(sLb.mas_right);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(sizeChartLeft.mas_height);
        }];
        [lLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(mLb.mas_right);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(sizeChartLeft.mas_height);
        }];
        
        [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
        }];
    }
    return _sizeChartSection;
}
- (UIView *)buttonForDetailSection{
    if (_buttonForDetailSection == nil) {
        _buttonForDetailSection = [[UIView alloc]init];
        _buttonForDetailSection.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_buttonForDetailSection];
        
        UIView *buttonForDetail = [[UIView alloc]init];
        buttonForDetail.backgroundColor = [UIColor blackColor];
        [_buttonForDetailSection addSubview:buttonForDetail];
        
        UILabel *viewMoreLabel = [[UILabel alloc]init];
        [viewMoreLabel KWSetLabelWithFontName:@"Aapex" fontSize:20 backgroundColor:[UIColor clearColor] fontColor:[UIColor whiteColor]];
        viewMoreLabel.numberOfLines = 1;
        [viewMoreLabel KWSetWithTextAndGetRowHeight:@"VIEW MORE ^" expectedWidth:100];
        [buttonForDetail addSubview:viewMoreLabel];
        
        [viewMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        [buttonForDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(padding);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(40);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonForDetailTapped:)];
        [buttonForDetail addGestureRecognizer:tap];
    }
    return _buttonForDetailSection;
}
- (UIView *)detailSection{
    if (_detailSection == nil) {
        _detailSection = [[UIView alloc]init];
        _detailSection.backgroundColor = [UIColor whiteColor];
        
        [self featureSection];
        [self descBasicSection];
        [self detailImageSection];
        
        [_featureSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_detailSection.mas_width);
            make.bottom.mas_equalTo(_featureSection.subviews[_featureSection.subviews.count-1].mas_bottom);
        }];
        [_descBasicSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_featureSection.mas_bottom).offset(20);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_detailSection.mas_width);
            make.bottom.mas_equalTo(_descBasicSection.subviews[_descBasicSection.subviews.count-1].mas_bottom).offset(padding);
            
        }];
        [_detailImageSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_descBasicSection.mas_bottom).offset(padding);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(_detailSection.mas_width);
            make.bottom.mas_equalTo(_detailImageSection.subviews[_detailImageSection.subviews.count-1].mas_bottom).offset(0);
            
            make.bottom.mas_equalTo(0);  //此处约束为了填充scrollview的contentsize高度
        }];
    }
    [_scrollView insertSubview:_detailSection atIndex:4];
    [_detailSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sizeChartSection.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
        make.bottom.mas_equalTo(_detailSection.subviews[_detailSection.subviews.count-1].mas_bottom).offset(0);
        
        make.bottom.mas_equalTo(_commentSection.mas_top).offset(0); //设置与下一个Section的距离
    }];
    return _detailSection;
}
//属于detailSection
- (UIView *)featureSection{
    if (_featureSection == nil) {
        _featureSection = [[UIView alloc]init];
        [_detailSection addSubview:_featureSection];
        
        for (int i = 0; i<[_viewModel getNumberOfFeatureSection]; i++) {
            UIView *featureContentView = [[UIView alloc]init];
            [_featureSection addSubview:featureContentView];
            
            UILabel *featureTitleLb = [[UILabel alloc]init];        //1
            [featureTitleLb KWSetLabelWithFontName:@"Aapex" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor lightGrayColor]];
            featureTitleLb.numberOfLines = 1;
            [featureTitleLb KWSetWithTextAndGetRowHeight:[_viewModel getFeatureForRow:i].title expectedWidth:100];
            [featureContentView addSubview:featureTitleLb];
            
            UILabel *featureTextLb = [[UILabel alloc]init];         //2
            [featureTextLb KWSetLabelWithFontName:@"HelveticaNeue-Bold" fontSize:12 backgroundColor:[UIColor clearColor] fontColor:[UIColor colorWithHexString:@"656565"]];
            [featureTextLb KWSetWithTextAndGetRowHeight:[_viewModel getFeatureForRow:i].text expectedWidth:100];
            [featureContentView addSubview:featureTextLb];
            
            [featureTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(padding);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            [featureTextLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(featureTitleLb.mas_bottom).offset(4);
                make.left.mas_equalTo(padding);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-padding*2);
                make.bottom.mas_equalTo(0);
            }];
            
            [featureContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(0);
                }
                else{
                    make.top.mas_equalTo(_featureSection.subviews[i-1].mas_bottom).offset(10);
                }
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
            }];
        }
    }
    return _featureSection;
}
- (UIView *)descBasicSection{
    if (_descBasicSection == nil) {
        _descBasicSection = [[UIView alloc]init];
        [_detailSection addSubview:_descBasicSection];
        
        UILabel *descBasicLb = [[UILabel alloc]init];
        [descBasicLb KWSetLabelWithFontName:@"HelveticaNeue-Bold" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor colorWithHexString:@"656565"]];
        [descBasicLb KWSetWithTextAndGetRowHeight:_viewModel.descBasicLb expectedWidth:100];
        [_descBasicSection addSubview:descBasicLb];
        
        [descBasicLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-padding*2);
            make.top.mas_equalTo(0);
        }];
    }
    return _descBasicSection;
}
- (UIView *)detailImageSection{
    if (_detailImageSection == nil) {
        _detailImageSection = [[UIView alloc]init];
        [_detailSection addSubview:_detailImageSection];
        
        for (int i = 0; i<[_viewModel getNumberOfDetailImageSection]; i++) {
            UIImageView *detailIv = [[UIImageView alloc]init];
            detailIv.backgroundColor = [UIColor lightGrayColor];
            [_detailImageSection addSubview:detailIv];
            ImageForHomePageModel *image = [_viewModel getDetailImageForRow:i];
            [detailIv mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(0);
                }
                else{
                    make.top.mas_equalTo(_detailImageSection.subviews[i-1].mas_bottom).offset(0);
                }
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(detailIv.mas_width).multipliedBy([image getImageRatio]);
            }];
            
            [detailIv sd_setImageWithURL:[NSURL URLWithString:[image getRequestUrlWithWidth:[UIScreen mainScreen].bounds.size.width]]];
        }
    }
    return _detailImageSection;
}
- (UIView *)commentSection{
    if (_commentSection == nil) {
        _commentSection = [[UIView alloc]init];
        [_scrollView addSubview:_commentSection];
        _commentSection.backgroundColor = [UIColor lightGrayColor];
    }
    return _commentSection;
}
- (UIView *)navigationBarForImformation{
    if (_navigationBarForImformation == nil) {
        _navigationBarForImformation = [[UIView alloc]init];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        _navigationBarForImformation.backgroundColor = [UIColor whiteColor];
        _navigationBarForImformation.layer.opacity = 0;
        [self.view insertSubview:_navigationBarForImformation aboveSubview:_scrollView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        [nameLabel KWSetLabelWithFontName:@"HelveticaNeue-Bold" fontSize:14 backgroundColor:[UIColor clearColor] fontColor:[UIColor blackColor]];
        nameLabel.numberOfLines = 1;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel KWSetWithTextAndGetRowHeight:_viewModel.itemNameLb expectedWidth:100];
        [_navigationBarForImformation addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _navigationBarForImformation;
}
- (UIView *)navigationBarForButton{
    if (_navigationBarForButton == nil) {
        _navigationBarForButton = [[UIView alloc]init];
        [self.view addSubview:_navigationBarForButton];
        
        _menuButtonView = [EntryButtonViewForMenuViewController getTheButtonForViewController:self ButtonColorIsWhite:NO rightPadding:padding menuButtonWidth:buttonWidth];
        [_navigationBarForButton addSubview:_menuButtonView];
        [_menuButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];                                                              //1
        
        UIView *returnButton = [[UIView alloc]init];
        UIImageView *returnButtonImage = [[UIImageView alloc]init];
        returnButtonImage.image = [UIImage imageNamed:@"returnButtonBlack"];
        returnButtonImage.contentMode = UIViewContentModeScaleAspectFill;
        [returnButton addSubview:returnButtonImage];
        [returnButtonImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.height.width.mas_equalTo(buttonWidth);
        }];
        [_navigationBarForButton addSubview:returnButton];
        [returnButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnButtonClicked:)]];
        [returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(returnButton.mas_height);
        }];                                                              //2
    }
    return _navigationBarForButton;
}
#pragma mark------------------private methods 私有方法----------------------
- (void)returnButtonClicked:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buttonForDetailTapped:(UITapGestureRecognizer *)tapgr{
    [_buttonForDetailSection removeFromSuperview];
    [self detailSection];
}
- (void)navigationBarChangeStatus:(BOOL)toShow{
    if (toShow) {
        [_navigationBarForButton.layer removeAllAnimations];
        [_navigationBarForImformation.layer removeAllAnimations];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _navigationBarForButton.transform = CGAffineTransformMakeTranslation(0, 0);
            _navigationBarForImformation.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            
        }];
        self.topBarIsShowing = YES;
    }
    if (!toShow) {
        [_navigationBarForButton.layer removeAllAnimations];
        [_navigationBarForImformation.layer removeAllAnimations];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _navigationBarForButton.transform = CGAffineTransformMakeTranslation(0, -64);
            _navigationBarForImformation.transform = CGAffineTransformMakeTranslation(0, -64);
        } completion:^(BOOL finished) {
            
        }];
        self.topBarIsShowing = NO;
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat opacity = (_scrollView.contentOffset.y-_topImageViewHeight)/300;
        if (opacity>1) {
            opacity=1;
        }
        if (opacity<0) {
            opacity=0;
        }
        _navigationBarForImformation.layer.opacity=opacity;
        if (_scrollView.contentOffset.y<=_topImageViewHeight+300) {
            if (self.topBarIsShowing == NO) {
                self.navigationBarForImformation.transform = CGAffineTransformIdentity;
                self.navigationBarForButton.transform = CGAffineTransformIdentity;
                self.topBarIsShowing = YES;
            }
        }
        if (_scrollView.contentOffset.y>=_topImageViewHeight+300) {
            if ([_scrollView.panGestureRecognizer velocityInView:self.view].y<-600) {
                if (self.topBarIsShowing == YES) {
                    [self navigationBarChangeStatus:NO];
                }
            }
            if ([_scrollView.panGestureRecognizer velocityInView:self.view].y>600) {
                if (self.topBarIsShowing == NO) {
                    [self navigationBarChangeStatus:YES];
                }
            }
        }
    }
}

@end
