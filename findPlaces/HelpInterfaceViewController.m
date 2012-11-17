//
//  HelpInterfaceViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-22.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "HelpInterfaceViewController.h"
#import "MoreViewController.h"
#import "CustomFourItemsTabBarController.h"

@interface HelpInterfaceViewController ()

@end

@implementation HelpInterfaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //滚动视图的加载
    _helpInterface = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    _helpInterface.contentSize = CGSizeMake(320*5, 460);
    _helpInterface.delegate = self;
    _helpInterface.pagingEnabled = YES;
    for (NSInteger i = 0; i < 5; i++) {
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"help%d",i+1] ofType:@"jpg"];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imagePath];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(320*i, 0, 320, 460);
        [_helpInterface addSubview:imageView];
    }
    [self.view addSubview:_helpInterface];
    //给滚动视图_helpInterface加手势判断"开始体验"响应区域
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [_helpInterface addGestureRecognizer:tap];
    //翻页控件的加载
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 410, 100, 40)];
    _pageControl.numberOfPages = 5;
    [_pageControl addTarget:self action:@selector(pageControlPressed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage  = fabs(_helpInterface.contentOffset.x/_helpInterface.frame.size.width);
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:_helpInterface];
    if (tapPoint.x > 1372 && tapPoint.x < 1523 && tapPoint.y > 360 && tapPoint.y < 407) {
        if ([self.presentingViewController isKindOfClass:[CustomFourItemsTabBarController class]]) {
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:HelpInterfaceOver object:self];
            NSLog(@"zzz");
        }
    }
}

-(void)pageControlPressed:(UIPageControl *)pageControl
{
    [_helpInterface setContentOffset:CGPointMake(_pageControl.currentPage*320,0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
