//
//  MoreViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "MoreViewController.h"
#import "SuggestionViewController.h"
#import "VersionViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize tableView = _tableView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HelpInterfaceOver object:_helpInterfaceVC];
//    [super dealloc];//ARC不用写[super dealloc],但是通知-sqlite-CF的release\retain-C的free要写
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       _titleArray = [NSArray arrayWithObjects:@"新手使用指导",@"意见反馈",@"到App Store评分",@"版本信息", nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(helpOver) name:HelpInterfaceOver object:_helpInterfaceVC];
    }
    return self;
}

- (void)helpOver
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"木纹背景.png"]];//为什么放在init里不行?
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.0;
    }
    return 8.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"MoreViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"设置-background.png"]];
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.section];
    [cell.textLabel setTextColor:[UIColor brownColor]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-copy-3 1.png"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0://@"新手使用指导"
        {
            _helpInterfaceVC = [HelpInterfaceViewController new];
            [self presentModalViewController:_helpInterfaceVC animated:YES];
            break;
        }
        case 1://@"意见反馈"
        {
            SuggestionViewController *suggestionVC = [SuggestionViewController new];
            [self.navigationController pushViewController:suggestionVC animated:YES];
            break;
        }
        case 2://@"到App Store评分"//此句代码没错,在手机上先是进入浏览器,然后会通过手机的App Store打开链接.在手机上测试正常,模拟器不能试
        {
            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id4964074336"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        case 3://@"版本信息"
        {
            VersionViewController *VVC = [VersionViewController new];
            [self.navigationController pushViewController:VVC animated:YES];
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)backPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
