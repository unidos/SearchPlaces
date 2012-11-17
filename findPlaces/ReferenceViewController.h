//
//  ReferenceViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-25.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface ReferenceViewController : UIViewController
{
    DataModel *_dataModel;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)backPressed:(id)sender;
@end
