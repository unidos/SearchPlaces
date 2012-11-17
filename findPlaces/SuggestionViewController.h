//
//  SuggestionViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-30.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSInteger _restCharNum;
    UIAlertView *_alert;
    UIToolbar *_toolbar;
    CGRect rKBEnd;
    CGFloat _distance;
}
@property (strong, nonatomic) IBOutlet UILabel *charNumLable;
@property (strong, nonatomic) IBOutlet UITextView *suggestionText;
@property (strong, nonatomic) IBOutlet UITextField *mailText;
- (IBAction)commitPressed:(UIButton *)sender;
- (IBAction)backPressed:(UIButton *)sender;
- (IBAction)controlPressed:(UIControl *)sender;
@end
