//
//  MyCollectionViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyEntity.h"
#import "DataModel.h"
#import "DetailSavedViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController

@synthesize tableView = _tableView;
@synthesize deleteBtn = _deleteBtn;
@synthesize collections = _collections;

-(void)dataSourceChanged//需要更新数据源
{
    _collections = _dataModel.myCollections;//主视图已经读取一次文件了,这里只需要获取数据模型
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canDelete = YES;
        _didDelete = NO;
        _dataModel = [DataModel defaultDataModel];
        //注册存储模型通知的观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataSourceChanged) name:persistentFileChanged object:nil];
        //通知事件的响应顺序是啥?主视图和收藏视图都注册了同一个通知,是不是按照谁先注册谁先响应的来?如果反了,先响应了收藏的后响应主视图的,那么收藏的数据源更新就会失败.实际测试发现好像时谁先注册谁先响应,所以获取文件只需要在AppDelegate或者主视图里动作就行了.因为他们两个的通知观察者是最先注册到通知中心的.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"木纹背景.png"]];
//    _tableView.backgroundView = imageView;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _alertView = [[UIAlertView alloc]initWithTitle:@"你想干嘛?" message:@"请先选中单元格" delegate:self cancelButtonTitle:@"半秒后自动关闭" otherButtonTitles:nil, nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self dataSourceChanged];//更新数据源
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDeleteBtn:nil];
    [super viewDidUnload];
}

#pragma mark - tableView
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collections.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"MyCollectionViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    MyEntity *entity = [_collections objectAtIndex:_collections.count - indexPath.row - 1];
    cell.imageView.image = entity.smallImage;
//    [cell.imageView setValue:[NSNumber numberWithDouble:5.0] forKeyPath:@"layer.borderWidth"];
    CALayer *layer = cell.imageView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 20;
    layer.borderWidth = 2;
    layer.borderColor = [UIColor grayColor].CGColor;
    cell.textLabel.text = entity.detailName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.detailTextLabel.text = entity.detailInfoText;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _dataModel.selectedEntity = [_collections objectAtIndex:_collections.count - 1 - indexPath.row];
    _selectedIndexPath = indexPath;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPathForSelectedRow %@",[tableView indexPathForSelectedRow]);//日他娘的,竟然是空值,害我半天试
    if(![indexPath isEqual:_selectedIndexPath]){
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //1-内存数据源删除.表格视图一定要先删数据源,后删视图.先后顺序不能颠倒.所以表格数据的数据源最好是可变数组.又因为删除文件后数据源会重读文件,视图也会重载,故而删完文件没必要再去删除数据源和视图
//        [_collections removeObjectAtIndex:_collections.count - 1 - indexPath.row];//数组的count会减1
        //2-视图删除
//        NSArray *indexPathsWillDelete = [NSArray arrayWithObjects:indexPath, nil];
//        [tableView deleteRowsAtIndexPaths:indexPathsWillDelete withRowAnimation:UITableViewRowAnimationRight];
        //外存文件删除相应行
        MyEntity *entityWillDelete = [_collections objectAtIndex:_collections.count - 1 - indexPath.row];
        [MyStore DeleteOneCollection:entityWillDelete];
        //更新删除状态
        [self tableViewCanDelete];
    }
}

- (IBAction)addBtnPressed:(id)sender {
    if (_selectedIndexPath) {
        _dataModel.selectedEntity = [_collections objectAtIndex:_collections.count -1 - _selectedIndexPath.row];
        DetailSavedViewController *dsVC = [DetailSavedViewController new];
        [self.navigationController pushViewController:dsVC animated:YES];
    }else{
        [_alertView show];
    }
}

- (IBAction)deletePressed:(UIButton *)sender {
    if (_selectedIndexPath) {
        if (_canDelete) {
            //正在删除状态,提示对号
            [_tableView setEditing:YES animated:YES];
            [self.deleteBtn setImage:[UIImage imageNamed:@"完成1.png"] forState:UIControlStateNormal];
            _canDelete = NO;
        }else{
            [self tableViewCanDelete];
        }
    }else{
        [_alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(disappearAlertView) userInfo:nil repeats:NO];
}

- (void)disappearAlertView
{
    [_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:YES];
}

- (void)tableViewCanDelete
{
    //不在删除状态,提示可以删除
    [_tableView setEditing:NO animated:YES];
    [_tableView selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.deleteBtn setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
    _canDelete = YES;
}
- (IBAction)backPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
