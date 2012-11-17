//
//  NearPlacesTableViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "NearPlacesTableViewController.h"
#import "CurrentLocationViewController.h"
#import "DetailViewController.h"

@interface NearPlacesTableViewController ()

@end

@implementation NearPlacesTableViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataModel = [DataModel defaultDataModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 320, 180);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //下沉按钮
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundImage:[UIImage imageNamed:@"Titlebg.png"] forState:UIControlStateNormal];
    titleButton.frame = CGRectMake(0, 4, 320, 20);
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];
    //数据表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, 160) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)titleButtonPressed:(UIButton *)button
{
    CurrentLocationViewController *clVC = (CurrentLocationViewController *)self.view.superview.nextResponder;
    //移除自己的视图
    [self.view removeFromSuperview];
    //重设mapview的地图和中心坐标
    clVC.mapView.frame = CGRectMake(0, 40, 320, 460);
    clVC.mapView.centerCoordinate = clVC.locationManager.location.coordinate;
}

#pragma mark - UITableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return <#expression#>
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取被选中的行的数据
    NSDictionary *selectedPlace = [_dataModel.nearbyPlaces objectAtIndex:indexPath.row];
    //取它的经纬度
    CLLocationDegrees lat = [[[[selectedPlace objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lat"]floatValue];
    CLLocationDegrees lng = [[[[selectedPlace objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lng"]floatValue];
    //转换为CLLocation
    CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    //更新数据模型
    _dataModel.detailLocation = location;
    NSLog(@"%@",location);
    UITableViewCell *cellTmp = [tableView cellForRowAtIndexPath:indexPath];
    _dataModel.detailInfoText = [NSString stringWithFormat:@"%@\n%@",cellTmp.textLabel.text,cellTmp.detailTextLabel.text];
    //弹出细节视图显示
    DetailViewController *detailVC = [DetailViewController new];
    CurrentLocationViewController *cLVC = (CurrentLocationViewController *)self.view.superview.nextResponder;
    [cLVC.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataModel.nearbyPlaces count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NearPlacesTableViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    NSDictionary *itemDic = [_dataModel.nearbyPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [itemDic objectForKey:@"name"];
    cell.detailTextLabel.text = [itemDic objectForKey:@"vicinity"];
    return cell;
}

@end
