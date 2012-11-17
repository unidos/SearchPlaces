//
//  DetailViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "DetailViewController.h"
#import "ReferenceViewController.h"
#import "DetailSavedViewController.h"
#import "MyStore.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationCustom.h"

#define toolbarH 40.0

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize smallMap = _smallMap;
@synthesize detailInfo = _detailInfo;
@synthesize additionalInfo = _additionalInfo;

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataModel = [DataModel defaultDataModel];
        //注册键盘回收通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //地图范围设置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_dataModel.detailLocation.coordinate, 300, 300);
    [self.smallMap setRegion:region animated:YES];
    self.smallMap.layer.borderWidth = 5.0;
    self.smallMap.layer.borderColor = [UIColor brownColor].CGColor;
    
    //添加当前坐标的注释
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = _dataModel.detailLocation.coordinate;
    [self.smallMap addAnnotation:annotation];
    
    //设置详细信息
    self.detailInfo.text = _dataModel.detailInfoText;
    
    //增加关闭键盘按钮
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyboardButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setShowsTouchWhenHighlighted:YES];
    //keyboard.png尺寸=23*23
    [keyboardButton setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
    keyboardButton.frame = CGRectMake(320-30, 9, 23, 23);
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 460, 320, toolbarH)];
    [_toolbar addSubview:keyboardButton];
    _toolbar.alpha = 0.7;
    [self.view addSubview:_toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setSmallMap:nil];
    [self setDetailInfo:nil];
    [self setAdditionalInfo:nil];
    [super viewDidUnload];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    return annotationView;
}

//与键盘有关的行为应该尽量在键盘通知里做
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _distance = [AnimationCustom View:self.view UpWithKeyboardFor:textView];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];

    if(textView == self.additionalInfo){
        if([textView.text isEqualToString:@"添加点啥注释呢?"]){
            self.additionalInfo.text = @"";
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //self.view和收键盘按钮都恢复原位
    [AnimationCustom ViewDowningToItsOrigin:self.view];
    [AnimationCustom ViewDowningToItsOrigin:_keyboardButton];
    
    if(textView == self.additionalInfo){
        if(![textView hasText]){
            textView.text = @"添加点啥注释呢?";
        }
    }
}

- (void)hideKeyboard:(UIButton *)keyboardBtn
{
    //取消键盘,会触发textViewDidEndEditing:事件
    [self.view endEditing:YES];//[textView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [AnimationCustom ViewDowningToItsOrigin:self.view];
    [AnimationCustom ViewDowningToItsOrigin:_toolbar];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    rKBEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
}

- (IBAction)controlPressed:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)refereceBtnPressed:(UIButton *)sender {
    //取消键盘
    [self.view endEditing:YES];//[textView resignFirstResponder];
    ReferenceViewController *referenceVC = [[ReferenceViewController alloc]init];
    [self.navigationController pushViewController:referenceVC animated:YES];
}

- (IBAction)saveBtn:(UIButton *)sender {
    //生成smallImage,需要 <QuartzCore/QuartzCore.h>
    UIGraphicsBeginImageContext(CGSizeMake(320, 460));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bigImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef cgImage = CGImageCreateWithImageInRect([bigImage CGImage], CGRectMake(110, 100, 80, 80));
    _dataModel.smallImage = [UIImage imageWithCGImage:cgImage];


    //保存注释到数据模型
    _dataModel.additionalText = self.additionalInfo.text;
    //弹出存储标题提示框
    _myAlert = [[UIAlertView alloc]initWithTitle:@"请输入存储标题" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    _myAlert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [_myAlert show];
    
    //保存nametext
    _dataModel.detailName = [[_myAlert textFieldAtIndex:0]text];

}

#pragma mark - MFMessageComposeViewController
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发短信功能");
            break;
        case MessageComposeResultSent:
            NSLog(@"发送短信");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendBtn:(UIButton *)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self; //设置代理
        messageVC.body = @"test"; //设置短信内容
        messageVC.recipients = [NSArray arrayWithObject:@"136-0000-1234"]; //设置电话
        [self presentModalViewController:messageVC animated:YES];//打开短信发送视图
    }
    else
    {
        [NSException raise:@"不能发送短信" format:@"不能进行短信发送"];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == _myAlert){
        switch (buttonIndex) {
            case 0://确定
            {
                _dataModel.detailName = [[_myAlert textFieldAtIndex:0]text];
                //            DetailSavedViewController *detailSavedVC = [DetailSavedViewController new];
                //            [self presentModalViewController:detailSavedVC animated:YES];
                //保存
                BOOL OK = [MyStore SaveDetailToColloction];
                NSString *alertStr = nil;
                if(OK){
                    alertStr = @"保存成功";
                }
                else {
                    alertStr = @"保存失败";
                }
                _alertView  = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:@"半秒后自动消失" otherButtonTitles:nil, nil];
                [_alertView show];
                break;
            }
            case 1://取消
            {
                break;
            }
            default:
                break;
        }
    }
}

-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if(alertView == _alertView){
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(alertViewDisappear) userInfo:nil repeats:NO];
    }
}

- (void)alertViewDisappear
{
    [_alertView dismissWithClickedButtonIndex:[_alertView cancelButtonIndex] animated:YES];
}

@end
