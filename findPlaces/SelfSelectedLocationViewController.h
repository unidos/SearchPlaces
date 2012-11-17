

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "NearPlacesTableViewController.h"
#import "DetailViewController.h"

@interface SelfSelectedLocationViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,NSURLConnectionDataDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
 @private
    BOOL _isResultList;
    MKPointAnnotation *_currentAnnotation;
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    NSMutableData *_placesData;
    DataModel *_dataModel;
    NSURLConnection *_myConnection;
    NearPlacesTableViewController *_nearPlacesTableCtrl;
    NSMutableData *_resultData;
    NSArray *_resultTableArray;
    BOOL _isManualLocation;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)backPressed:(id)sender;
@end
