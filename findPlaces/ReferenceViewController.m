//
//  ReferenceViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-25.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "ReferenceViewController.h"

@interface ReferenceViewController ()

@end

@implementation ReferenceViewController

@synthesize tableView = _tableView;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _dataModel = [DataModel defaultDataModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"nearbyPlaces count = %d",[_dataModel.nearbyPlaces count]);
    return [_dataModel.nearbyPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReferenceViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *currentPlace = [_dataModel.nearbyPlaces objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [currentPlace objectForKey:@"name"];
    //自该参照往%@方向走%f米至您当前位置
    NSDictionary *srcLocaDic = [[currentPlace objectForKey:@"geometry"]objectForKey:@"location"];
    CLLocationCoordinate2D srcCoor = CLLocationCoordinate2DMake([[srcLocaDic objectForKey:@"lat"]floatValue], [[srcLocaDic objectForKey:@"lng"]floatValue]);
    NSString *direStr = [_dataModel directionFrom:srcCoor to:_dataModel.currentLocation.coordinate];
    
//    CGPoint srcPoint = [self.mapView convertCoordinate:srcCoor toPointToView:self.mapView];
//    CGPoint destPoint = [self.mapView convertCoordinate:_dataModel.currentLocation.coordinate toPointToView:self.mapView];
//    NSString *direStrNew = [_dataModel directionFromSrcPoint:srcPoint to:destPoint];
    
    CLLocation *srcLoc = [[CLLocation alloc]initWithLatitude:srcCoor.latitude longitude:srcCoor.longitude];
    CLLocationDistance aDistance = [_dataModel.currentLocation distanceFromLocation:srcLoc];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"该参照往%@走%.0f米至您",direStr,aDistance];
    //保持选中状态
    NSString *str = [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,cell.detailTextLabel.text];
    if([str isEqualToString:_dataModel.referenceText]){
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewRowAnimationTop];
    }
    cell.imageView.image = [UIImage imageNamed:@"店名.png"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _dataModel.referenceSelectedIndexPath = indexPath;
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}
- (IBAction)backPressed:(id)sender {
    //保存选中数据到数据模型
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_dataModel.referenceSelectedIndexPath];
    _dataModel.referenceText = [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,cell.detailTextLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
