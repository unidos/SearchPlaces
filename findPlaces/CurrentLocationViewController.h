//
//  CurrentLocationViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "NearPlacesTableViewController.h"
#import "DetailViewController.h"

@interface CurrentLocationViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,NSURLConnectionDataDelegate>
{
 @private
    MKPointAnnotation *_currentAnnotation;
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    NSMutableData *_placesData;
    DataModel *_dataModel;
    NSURLConnection *_myConnection;
    NearPlacesTableViewController *_nearPlacesTableCtrl;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)refreshPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
@end
