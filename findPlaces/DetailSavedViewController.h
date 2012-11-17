//
//  DetailViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "ReferenceViewController.h"

@interface DetailSavedViewController : UIViewController<MKMapViewDelegate,UITextViewDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>
{
    DataModel *_dataModel;
    UIButton *_keyboardButton;
    UIAlertView *_alertView;
    UIToolbar *_toolbar;
    CGRect rKBEnd;
    CGFloat _distance;
}
@property (strong, nonatomic) IBOutlet UIButton *referenceBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveOrEditBtn;
@property (strong, nonatomic) IBOutlet UITextView *nameText;
@property (strong, nonatomic) IBOutlet MKMapView *smallMap;
@property (strong, nonatomic) IBOutlet UITextView *detailInfo;
@property (strong, nonatomic) IBOutlet UITextView *additionalInfo;
- (IBAction)refereceBtnPressed:(UIButton *)sender;
- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)sendBtn:(UIButton *)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)controlPressed:(id)sender;
@end
