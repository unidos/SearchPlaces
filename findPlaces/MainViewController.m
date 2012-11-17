//
//  MainViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-22.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "MainViewController.h"
#import "MyCollectionViewController.h"
#import "SelfSelectedLocationViewController.h"
#import "CurrentLocationViewController.h"
#import "MoreViewController.h"

#define loadCountKey @"loadCountKey"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize collectionNumLabel = _collectionNumLabel;
@synthesize custom4TabBarCtr = _custom4TabBarCtr;

//紧耦合的部分应该放在上面,以方便移植修改;弱耦合的部分放在下面比较好,因为没什么可变的.
-(void)fileChanged//文件改变的响应事件
{
    //文件的读取应该在根视图控制器中读取,或者在AppDelegate读取,因为他们的实例不会释放,从头至尾可以正常响应通知
    _dataModel.myCollections = [[MyStore FetchAllColloctions]mutableCopy];//文件读取一回就行了,我的收藏不用再次读取,只需重设dataSource就行了.如果再次读取会在内存中再生成一份,会多占内存
    self.collectionNumLabel.text = [NSString stringWithFormat:@"%d",[_dataModel.myCollections count]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //取得数据模型的单例和存储实例
        _dataModel = [DataModel defaultDataModel];
        //注册存储模型通知的观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fileChanged) name:persistentFileChanged object:nil];
        //注册loadCountKey默认值到注册域
        NSDictionary *loadCountDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:loadCountKey];
        [[NSUserDefaults standardUserDefaults]registerDefaults:loadCountDefaults];
        
        //我的收藏
        MyCollectionViewController *mCViewC = [[MyCollectionViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *naviMCVC = [[UINavigationController alloc]initWithRootViewController:mCViewC];
        naviMCVC.navigationBarHidden = YES;
        //自选位置
        SelfSelectedLocationViewController *sSLViewC = [[SelfSelectedLocationViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *naviSSLVC = [[UINavigationController alloc]initWithRootViewController:sSLViewC];
        naviSSLVC.navigationBarHidden = YES;
        //当前位置
        CurrentLocationViewController *cLViewC = [[CurrentLocationViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *naviCLVC = [[UINavigationController alloc]initWithRootViewController:cLViewC];
        naviCLVC.navigationBarHidden = YES;
        //More
        MoreViewController *mViewC = [[MoreViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *naviMVC = [[UINavigationController alloc]initWithRootViewController:mViewC];
        naviMVC.navigationBarHidden = YES;
        //自定义4项标签条
        _custom4TabBarCtr = [[CustomFourItemsTabBarController alloc]init];
        NSArray *viewCtrls = [NSArray arrayWithObjects:naviMCVC,naviSSLVC,naviCLVC,naviMVC, nil];
        [_custom4TabBarCtr setViewControllers:viewCtrls animated:YES];
        //自定义4项标签条的五项属性变量的设置
        _custom4TabBarCtr.titles = [NSArray arrayWithObjects:@"我的收藏",@"自选位置",@"当前位置",@"更多", nil];
        _custom4TabBarCtr.brightColor = [UIColor whiteColor];
        _custom4TabBarCtr.darkColor = [UIColor colorWithRed:0.3f green:0.14f blue:0.08f alpha:1.0f];
        //自定义4项标签条的亮.暗图片设置
        NSMutableArray *brightImageTemp = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray *darkImageTemp = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i = 0; i < 4; i++) {
            [brightImageTemp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"TabIcon1%d.png",i]]];
            [darkImageTemp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"TabIcon%d.png",i]]];
        }
        _custom4TabBarCtr.brightImage = brightImageTemp;
        _custom4TabBarCtr.darkImage = darkImageTemp;
        
        //注册为_helpInterfaceVC的通知的观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterMainViewC:) name:HelpInterfaceOver object:_helpInterfaceVC];
    }
    return self;
}

-(void)enterMainViewC:(NSNotification *)note
{
    [_helpInterfaceVC.view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHelpView];//看是否可加载帮助页面
    [self fileChanged];//更新收藏数量
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HelpInterfaceOver object:_helpInterfaceVC];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:persistentFileChanged object:nil];
}
- (void)viewDidUnload {
    [self setCollectionNumLabel:nil];
    [super viewDidUnload];
}
- (IBAction)collectionButtonPressed:(UIButton *)sender forEvent:(UIEvent *)event {
    _custom4TabBarCtr.selectedIndexCTB = 0;
    [self presentModalViewController:_custom4TabBarCtr animated:YES];
}

- (IBAction)selfSelectedLocationPressed:(UIButton *)sender {
    _custom4TabBarCtr.selectedIndexCTB = 1;
    [self presentModalViewController:_custom4TabBarCtr animated:YES];
}

- (IBAction)currentLocationPressed:(UIButton *)sender {
    _custom4TabBarCtr.selectedIndexCTB = 2;
    [self presentModalViewController:_custom4TabBarCtr animated:YES];
}

- (IBAction)settingPressed:(UIButton *)sender {
    _custom4TabBarCtr.selectedIndexCTB = 3;
    [self presentModalViewController:_custom4TabBarCtr animated:YES];
}

-(void)loadHelpView
{
    //-------如果注册域不注册默认值会不会取到的loadCount是0?
    NSUInteger loadCount = [[NSUserDefaults standardUserDefaults]integerForKey:loadCountKey];//从NSUserDefaults的应用域取上次保存值,应用域找不到会去注册域取值,同时说明程序没有运行过,所以注册域应该注册一个初始值.如果是运行次数应该设为0.
    if(!loadCount)//初次加载
    {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:loadCountKey];//更改加载次数为1到应用域.应用域会有文件保存.注册域没有,是临时的
        _helpInterfaceVC = [[HelpInterfaceViewController alloc]init];
        _helpInterfaceVC.view.frame = CGRectMake(0, 0, 320, 480);
        [self.view addSubview:_helpInterfaceVC.view];
    }
}

- (IBAction)exitPressed:(id)sender {
    [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
}
@end
