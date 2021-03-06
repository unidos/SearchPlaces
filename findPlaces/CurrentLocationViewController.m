//
//  CurrentLocationViewController.m
//  findPlaces
//  Created by 孙延梁 on 12-10-21.

#import "CurrentLocationViewController.h"
#import "JSONKit.h"

@interface CurrentLocationViewController ()

@end

@implementation CurrentLocationViewController

@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataModel = [DataModel defaultDataModel];
        _nearPlacesTableCtrl = [[NearPlacesTableViewController alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    //定位管理器
    if([CLLocationManager locationServicesEnabled])
    {
        _locationManager = _dataModel.locationManager;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:1.0f];
        [_locationManager setDelegate:self];
        [_locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //test//MKUserLocation是annotation不是location,其包含location
//    CLLocationCoordinate2D coor = mapView.userLocation.coordinate;
//    NSLog(@"mapView.userLocation.coordinate %f %f",coor.latitude,coor.longitude);
    if(view == [mapView viewForAnnotation:mapView.userLocation]){
        MKPointAnnotation *pAn= (MKPointAnnotation *)view.annotation;
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
            //从服务器传送completion才会执行,所以要给注释赋值需要在此块里
            _dataModel.currentPlacemark = [placemarks objectAtIndex:0];
            //设置注释
            pAn.title = [NSString stringWithFormat:@"%@%@",_dataModel.currentPlacemark.thoroughfare,_dataModel.currentPlacemark.subThoroughfare];
            pAn.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@%@",_dataModel.currentPlacemark.country,_dataModel.currentPlacemark.locality,_dataModel.currentPlacemark.subLocality,_dataModel.currentPlacemark.thoroughfare,_dataModel.currentPlacemark.subThoroughfare,_dataModel.currentPlacemark.name];
        }];
        [self.mapView selectAnnotation:view.annotation animated:YES];
    }

}*/
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if([newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp] > 1){
        //关闭定位
//        [_locationManager stopUpdatingLocation];
        //更新数据模型的详细视图的定位
        _dataModel.detailLocation = newLocation;
        _dataModel.currentLocation = newLocation;
        //显示新定位
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(newLocation.coordinate.latitude+0.0015, newLocation.coordinate.longitude);//地图中心点上移一点
        MKCoordinateRegion regin = MKCoordinateRegionMakeWithDistance(coor, 1000, 1000);
        [_mapView setRegion:regin animated:YES];
        //坐标转地标
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //从服务器传送completion才会执行,所以要给注释赋值需要在此块里
            _dataModel.currentPlacemark = [placemarks objectAtIndex:0];
            //设置注释
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = newLocation.coordinate;
            annotation.title = [NSString stringWithFormat:@"%@",_dataModel.currentPlacemark.name];
            annotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@",_dataModel.currentPlacemark.country,_dataModel.currentPlacemark.locality,_dataModel.currentPlacemark.subLocality,_dataModel.currentPlacemark.thoroughfare,_dataModel.currentPlacemark.subThoroughfare];
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:YES];
            //更新数据模型的详细信息项
            _dataModel.detailInfoText = [NSString stringWithFormat:@"%@\n%@",annotation.title,annotation.subtitle];
        }];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //删除Current Location注释的2种方法:MKUserLocation是annotation不是location,其包含location
//    if ([[annotation title] isEqualToString:@"Current Location"]) {
//        [_mapView removeAnnotation:annotation];
//        return nil;
//    }
    if(annotation == _mapView.userLocation){
        [_mapView removeAnnotation:annotation];
        return nil;
    }
    _currentAnnotation = annotation;
    [_locationManager stopUpdatingLocation];
    //生成注释视图
    static NSString *PinID = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:PinID];
    annotationView.annotation = annotation;

    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:PinID];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        //设置左指示图
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"near.png"] forState:UIControlStateNormal];
        leftButton.bounds = CGRectMake(0, 0, 50, 30);
        leftButton.tag = 0;
        annotationView.leftCalloutAccessoryView = leftButton;
        //设置右指示图
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"Arrow-Icon.png"] forState:UIControlStateNormal];
        rightButton.bounds = CGRectMake(0, 0, 40, 30);
        rightButton.tag = 1;
        annotationView.rightCalloutAccessoryView = rightButton;
//        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;//动画落下
        annotationView.canShowCallout = YES;//注释可以在选择的时候弹出来
    }
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    switch(control.tag){
        case 0://显示附近信息
        {
            CLLocationCoordinate2D coor = _dataModel.currentLocation.coordinate;
            NSString *URLStr = [NSString stringWithFormat:@"%@location=%f,%f&radius=100&sensor=false&key=%@",baseURLStr,coor.latitude,coor.longitude,GooglePlacesAPIKey];//第一个字符串中的格式符用后面的代替
            NSLog(@"%@",URLStr);
            NSURL *placesURL = [NSURL URLWithString:URLStr];
            NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:placesURL];
            [mRequest setTimeoutInterval:15];
            [mRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            //NSURLConnection建立的异步DownLoad连接
            [_myConnection cancel];
            _myConnection = [NSURLConnection connectionWithRequest:mRequest delegate:self];
            //地图缩上去
            _mapView.frame = CGRectMake(0, 40, 320, 193);
            _mapView.centerCoordinate = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude + 0.0015, _locationManager.location.coordinate.longitude);
            //弹出附近信息表格
            _nearPlacesTableCtrl.view.frame = CGRectMake(0, 230, 320, 180);
            [self.view addSubview:_nearPlacesTableCtrl.view];
            break;
        }
        case 1://显示详细信息
        {
//            if (!_dataModel.nearbyPlaces) {
//                [_mapView deselectAnnotation:_currentAnnotation animated:YES];
//                return;
//            }
            _dataModel.detailLocation = _dataModel.currentLocation;
            DetailViewController *detailVC = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _placesData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_placesData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //大括号.分号.等号是字典,小括号.逗号是数组
    NSError *error;
//    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:_placesData options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *JSONDic = [_placesData objectFromJSONData];
    //    NSLog(@"%@",JSONDic);
    NSMutableArray *resultsArray = [NSMutableArray array];
    if(!error)
    {
        //JSON字典数据分析
        resultsArray = [[JSONDic objectForKey:@"results"]mutableCopy];//获取到的为不可变数组,要mutableCopy一份,或者用NSMutableArray包装一下
        [resultsArray removeObjectAtIndex:0];
        [resultsArray removeLastObject];
        _dataModel.nearbyPlaces = resultsArray;
    }
    else
    {
        NSLog(@"JSON解析错误");
    }
    [_nearPlacesTableCtrl.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
- (IBAction)refreshPressed:(id)sender {
    [_mapView removeAnnotation:_currentAnnotation];
    [_locationManager startUpdatingLocation];
}

- (IBAction)backPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
