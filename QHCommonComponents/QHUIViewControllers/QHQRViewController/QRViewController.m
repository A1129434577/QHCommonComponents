//
//  QRViewController.m
//  mbp_purse
//
//  Created by 刘彬 on 16/7/26.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "QRViewController.h"
#import <Photos/Photos.h>
#import "NSObject+SVProgressHUD.h"

@interface QRViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation QRViewController

- (instancetype)initError:(NSError **)outError
{
    self = [super init];
    if (self) {
        _qrView = [[QRView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self error:outError];
        if (*outError) {
            return nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:_qrView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 35)];
    [backBtn setImage:[UIImage imageNamed:@"qr_left_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-25-30, CGRectGetMinY(backBtn.frame), 25, 25)];
    photoBtn.backgroundColor = [UIColor whiteColor];
    photoBtn.layer.cornerRadius = CGRectGetHeight(photoBtn.frame)/2;
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [photoBtn addTarget:self action:@selector(qRSourceFromePhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
}
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)qRSourceFromePhotoLibrary{
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self showErrorWithStatus:@"您的设备不支持相册"];
        return;
    }else if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized && [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusNotDetermined){
        [self showErrorWithStatus:@"相册权限受限,请在隐私设置中启用相册访问"];
        return;
    }
    
    WEAKSELF
   [self showWithStatus:nil]; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf dismissWithCompletion:^{
                
                [weakSelf presentViewController:imagePicker animated:YES completion:NULL];
            }];
            
        });
        
    });
    
    
}


#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSArray *arr = [detector featuresInImage:[CIImage imageWithCGImage:[image CGImage]]];
    [self captureOutput:(AVCaptureOutput *)@"nil" didOutputMetadataObjects:arr fromConnection:(AVCaptureConnection *)@"nil"];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *qRMessageString = nil;
    if (metadataObjects.count > 0)
    {
        // 1. 如果扫描完成，停止会话
        [_qrView.session stopRunning];
        if ([[metadataObjects firstObject] isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            qRMessageString = ((AVMetadataMachineReadableCodeObject *)[metadataObjects firstObject]).stringValue;
        }else if ([[metadataObjects firstObject] isKindOfClass:[CIQRCodeFeature class]]){
            qRMessageString = ((CIQRCodeFeature *)[metadataObjects firstObject]).messageString;
        }
    }
    _QRViewScanedCode?_QRViewScanedCode(qRMessageString):NULL;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
