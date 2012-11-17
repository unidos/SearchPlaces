//
//  Custom4ItemsTabBarController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "CustomFourItemsTabBarController.h"

@interface CustomFourItemsTabBarController ()
//若在.h文件声明了,类目的延展转为无效,依然可以调用实例的该方法;可是私有方法的定义应该是不能使用,而不仅仅是不能看见.苹果对类目的延展定义比较搞.
-(void)buttonPressed:(UIButton *)currentSelectedButton;

@end

@implementation CustomFourItemsTabBarController

@synthesize titles = _titles;
@synthesize brightColor = _brightColor;
@synthesize darkColor = _darkColor;
@synthesize brightImage = _brightImage;
@synthesize darkImage = _darkImage;
@synthesize selectedIndexCTB = _selectedIndexCTB;
@synthesize buttonArray = _buttonArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedIndexCTB = 0;
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }
    return self;
}

//应该在视图显示前进行操作,而不应该在viewDidAppear做,那样会被用户看到变化
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBar setHidden:YES];//隐藏系统的标签条
    self.tabBarController.view.hidden=YES;
    
    self.buttonArray = [NSMutableArray arrayWithCapacity:numItemsOnTabBar];//按钮数组初始化,实例变量不可以只用便利构造器,因为便利构造器是autorelease,出了方法体就会被释放,所以要加retain,或者用alloc.这里用了ARC,所以不用管
    //分配四个按钮到标签栏位置
    for (NSInteger i = 0; i < numItemsOnTabBar; i++) {
        UIButton *btnItemOnTabBar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnItemOnTabBar.tag = i;
        btnItemOnTabBar.frame = CGRectMake(i*screenWidth/numItemsOnTabBar, screenHeight-itemHeight-20, screenWidth/numItemsOnTabBar, itemHeight);
        //标题初始化
        [btnItemOnTabBar setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal] ;//设置标题
        [btnItemOnTabBar.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];//设置字体
        btnItemOnTabBar.titleEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0);//调整标题位置
        [btnItemOnTabBar setTitleColor:_darkColor forState:UIControlStateNormal];//设置标题暗颜色
        //背景图初始化
        [btnItemOnTabBar setBackgroundImage:[_darkImage objectAtIndex:i] forState:UIControlStateNormal];//设置暗背景图片
        //设置按钮的响应事件
        [btnItemOnTabBar addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:btnItemOnTabBar];//按钮加入按钮数组
        [self.view addSubview:btnItemOnTabBar];
    }
    //设置默认选中的按钮
    [self buttonPressed:[_buttonArray objectAtIndex:_selectedIndexCTB]];//模拟按下第_selectedIndexCTB个按钮
}

- (void)viewDidLoad//此处比较搞,只有"标签栏"在初始化的时候就立马进入此方法,其他的都是在AppDelegate加载完毕后需要视图显示的时候才加载此方法.//你说的比较搞,只要view方法被调用,就会进入该方法,你在init方法里调用了view方法,当然会进来了
{
    [super viewDidLoad];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.buttonArray = nil;
    self.titles = nil;
    self.brightColor = nil;
    self.darkColor = nil;
    self.brightImage = nil;
    self.darkImage = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonPressed:(UIButton *)currentSelectedButton
{
    //以前选中的按钮要可以交互.变暗色.变暗图片
    UIButton *forwardSelectedButton = [_buttonArray objectAtIndex:_selectedIndexCTB];
    [forwardSelectedButton setUserInteractionEnabled:YES];
    [forwardSelectedButton setTitleColor:_darkColor forState:UIControlStateNormal];
    [forwardSelectedButton setBackgroundImage:[_darkImage objectAtIndex:_selectedIndexCTB] forState:UIControlStateNormal];
    //现在选中的要不可以交互.变亮色.变亮图片
    [currentSelectedButton setUserInteractionEnabled:NO];
    [currentSelectedButton setTitleColor:_brightColor forState:UIControlStateNormal];
    [currentSelectedButton setBackgroundImage:[_brightImage objectAtIndex:currentSelectedButton.tag] forState:UIControlStateNormal];
    //更新后台的标签控制器的动作
    [self setSelectedIndex:currentSelectedButton.tag];
    //记录选中的按钮的tag值
    _selectedIndexCTB = currentSelectedButton.tag;
    //按钮动画
    [self buttonAnimate:currentSelectedButton];
}

-(void)buttonAnimate:(UIButton *)btn
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.type = kCATransitionFade;
    [btn.layer addAnimation:animation forKey:nil];
}

@end
