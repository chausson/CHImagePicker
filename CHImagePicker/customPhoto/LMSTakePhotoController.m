//
//  LMSTakePhotoController.m
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//觉得这个功能可以的话、可以去点个赞 --> 本人github仓库https://github.com/DefaultYuan/__defaultyuan


#import "LMSTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "UIView+borderLine.h"
#import "UIImage+fixOrientation.h"

#define kPMake(x,y)  [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define OnePixelWidth  (ScreenWidth == 414 ? 0.334 : 0.5)


@interface LMSTakePhotoController ()<AVCaptureMetadataOutputObjectsDelegate>
{

    //切换前后摄像头
    __weak IBOutlet UIButton *_switchBtn;

    //拍照
    __weak IBOutlet UIButton *_takePicBtn;

    //取消
    __weak IBOutlet UIButton *_cancelBtn;
    
    //重拍
    __weak IBOutlet UIButton *restartBtn;
    
    //使用拍照
    __weak IBOutlet UIButton *_doneBtn;
    
    __weak IBOutlet UIView *_cameraView;
    
    //预览照片
    __weak IBOutlet UIImageView *_groupImage;
    
    UIImage * previewImage;//预览图片
    
    //身份证拍照的边框
    __weak IBOutlet UIView *borderView;
    
    //身份证横幅
    __weak IBOutlet UIView *IdNumBorderBgView;
    __weak IBOutlet UILabel *IdNumLabel;
    __weak IBOutlet UIView *IdNumBorderView;
    
    //有效期限边框
    __weak IBOutlet UIView *validTermBorderBgView;
    __weak IBOutlet NSLayoutConstraint *validTermBgViewWidth;
    __weak IBOutlet NSLayoutConstraint *validTermBgViewTrailConstraint;
    __weak IBOutlet UIView *validTermBorderView;
    __weak IBOutlet UILabel *validTermLabel;
    
    //签证机关
    __weak IBOutlet UIView *visaAgenciesBorderBgView;
    __weak IBOutlet NSLayoutConstraint *visaAgenciesBgViewWidth;
    __weak IBOutlet NSLayoutConstraint *visaAgenciesBgViewTrailConstraint;
    __weak IBOutlet UIView *visaAgenciesBorderView;
    __weak IBOutlet UILabel *visaAgenciesLabel;
    
    
    
    
}

@property (nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSArray *borderPoints;
@property (nonatomic, assign) UIInterfaceOrientation toInterfaceOrientation;
@property (nonatomic, strong) CMMotionManager * motionManager;//旋转

- (IBAction)takePic:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
- (IBAction)done:(UIButton *)sender;
- (IBAction)switchAction:(UIButton *)sender;
- (IBAction)restartAction:(UIButton *)sender;

@end

@implementation LMSTakePhotoController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"预览照片";
    self.view.backgroundColor = [UIColor blackColor];
    [self drawTakePicBtn];
    [self startMotionManager];//通过重力感性识别方向
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialSession];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}
#pragma mark - setupFunctionType
- (void)setupFunctionType
{
    switch (_functionType) {
        case TakePhotoIDCardFrontType:
            borderView.hidden = IdNumBorderBgView.hidden = NO;
            [self drawLabelsBorder];
            break;
            
        case TakePhotoIDCardBackType:
             borderView.hidden = validTermBorderBgView.hidden = visaAgenciesBorderBgView.hidden = NO;
            [self drawLabelsBorder];
            break;
            
        default:
            break;
    }
}
#pragma mark session
- (void) initialSession;
{
    //身份证拍照就让它开启后置摄像头了
    if (_functionType == TakePhotoIDCardBackType || _functionType == TakePhotoIDCardFrontType) {
        _position = TakePhotoPositionBack;
    }
    
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];//需要更加清晰的照片的话可以重新设置新值
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    if (self.session) {
        [self.session startRunning];
    }
    [self setUpCameraLayer];
    [self setDonePicture:NO];
    [self setupFunctionType];

}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:self.position == TakePhotoPositionBack ? AVCaptureDevicePositionBack :AVCaptureDevicePositionFront];
}

#pragma mark VideoCapture
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.previewLayer setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (97.0f / 667.0f)*ScreenHeight)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_cameraView.layer insertSublayer:self.previewLayer below:[[_cameraView.layer sublayers] objectAtIndex:0]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 切换前后摄像头
- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    NSArray *inputs = self.session.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}
#pragma mark - 手画拍照按钮
- (void)drawTakePicBtn
{
    
    //手算按钮的尺寸
    CGFloat width = 97.0/667.0 * ScreenHeight - 2*10.0;
    CGFloat heigth = width;
    
    [_takePicBtn cornerRadius:width/2.0
                  borderColor:[[UIColor blackColor] CGColor]
                  borderWidth:OnePixelWidth];
    
    CAShapeLayer *circleTrack = [CAShapeLayer layer];
    circleTrack.strokeColor = [[UIColor blackColor] CGColor];
    circleTrack.fillColor = nil;
    
    CGFloat lineWith = 1.5f;
    CGFloat thickness = 4.0f;
    
    circleTrack.lineWidth = lineWith;
    
    CGRect trackFrame = CGRectMake(thickness, thickness, width - 2*thickness - 2*lineWith, heigth - 2*thickness - 2*lineWith);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0f,heigth / 2.0f)
                                                              radius:trackFrame.size.width / 2.0f
                                                          startAngle:0
                                                            endAngle:M_PI * 2.0f
                                                           clockwise:YES];
    circleTrack.path = circlePath.CGPath;
    
    [_takePicBtn.layer addSublayer:circleTrack];
}
#pragma mark - 手画身份证边框
- (void)drawLabelsBorder
{
    NSArray *borderPoints = self.borderPoints;
    
    for (int i = 0; i < borderPoints.count; i++) {
        
        NSArray *points = borderPoints[i];
        CGPoint p0 = [points[0] CGPointValue];
        CGPoint p1 = [points[1] CGPointValue];
        CGPoint p2 = [points[2] CGPointValue];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, p0.x, p0.y);
        CGPathAddLineToPoint(path, NULL, p1.x, p1.y);
        CGPathAddLineToPoint(path, NULL, p2.x, p2.y);
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.fillColor = nil;
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.lineWidth = 1.5f;
        borderLayer.lineJoin = kCALineJoinRound;
        borderLayer.path = path;
        
        [borderView.layer addSublayer:borderLayer];
        
        CGPathRelease(path);
    }
    
    
}
#pragma mark 初始化
-(NSArray *)borderPoints
{
    if (!_borderPoints) {
        
        CGFloat w = 45.0f;
        CGFloat originX = 0;
        CGFloat originY = 0;
        CGFloat endX = 295.0f / 375.0f * ScreenWidth;
        CGFloat endY = 85.6f / 54.0f * endX;
        
        _borderPoints = @[@[kPMake(originX + w, originY),kPMake(originX, originY),kPMake(originX, originY + w)],
                          @[kPMake(originX, endY - w),kPMake(originX, endY),kPMake(originX + w, endY)],
                          @[kPMake(endX - w, endY),kPMake(endX, endY),kPMake(endX, endY - w)],
                          @[kPMake(endX, w),kPMake(endX, 0),kPMake(endX - w, 0)]];
        
    }
    
    return _borderPoints;
}

-(void)viewDidLayoutSubviews
{
    if (_functionType == TakePhotoIDCardFrontType || _functionType == TakePhotoIDCardBackType) {
        //描白边
        CGFloat borderWidth = 1.0f;
        [IdNumBorderView cornerRadius:0 borderColor:[UIColor whiteColor].CGColor borderWidth:borderWidth];
        [validTermBorderView cornerRadius:0 borderColor:[UIColor whiteColor].CGColor borderWidth:borderWidth];
        [visaAgenciesBorderView cornerRadius:0 borderColor:[UIColor whiteColor].CGColor borderWidth:borderWidth];
        
        IdNumLabel.text = @"公民身份证号码  ";
        
        //旋转
        CGFloat angle = M_PI_2 * 3;
        IdNumLabel.transform = CGAffineTransformMakeRotation(angle);
        validTermBorderBgView.transform = CGAffineTransformMakeRotation(angle);
        visaAgenciesBorderBgView.transform = CGAffineTransformMakeRotation(angle);
    }
    
    [self.view layoutSubviews];

}
#pragma mark 获取照片
- (void)gainPicture
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    if (!videoConnection) {
        NSLog(@"获取照片失败!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *gainImage = [UIImage imageWithData:imageData];
        previewImage = [[UIImage alloc] init];
        
        //为了自拍的时候 检测方向
        AVCaptureDevicePosition position = AVCaptureDevicePositionUnspecified; //判断是前置摄像头还是后置摄像头
        NSArray *inputs = self.session.inputs;
        
        for (AVCaptureDeviceInput *input in inputs) {
            AVCaptureDevice *device = input.device;
            if ([device hasMediaType:AVMediaTypeVideo]) {
                 position = device.position;
            }
        }
        
        //设备的方向
        switch (self.toInterfaceOrientation) {
                
            case UIInterfaceOrientationPortrait://1
                //home健在下
                previewImage = [UIImage imageWithCGImage:gainImage.CGImage scale:1.0f orientation:UIImageOrientationRight];
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                //home健在上
                previewImage = [UIImage imageWithCGImage:gainImage.CGImage scale:1.0f orientation:UIImageOrientationLeft];
                break;
                
            case UIInterfaceOrientationLandscapeLeft:
                //home健在左 //为了自拍的时候
                previewImage = [UIImage imageWithCGImage:gainImage.CGImage scale:1.0f orientation:position == AVCaptureDevicePositionBack ? UIImageOrientationDown : UIImageOrientationUp];
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                //home健在右 //为了自拍的时候
                previewImage = [UIImage imageWithCGImage:gainImage.CGImage scale:1.0f orientation:position == AVCaptureDevicePositionBack ? UIImageOrientationUp : UIImageOrientationDown];
                break;
                
            default:
                break;
                
        }

        _groupImage.image = previewImage;
        
        _groupImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setDonePicture:YES];
        
        if (self.session) {
            [self.session stopRunning];
        }
    }];
}

#pragma mark 


///拍照之后YES  显示的东西
- (void)setDonePicture:(BOOL)isTake;
{
    self.navigationController.navigationBarHidden = !isTake;
    ///拍照完之后
    self.previewLayer.hidden =  _cancelBtn.hidden  = _switchBtn.hidden = _takePicBtn.hidden = borderView.hidden = isTake;
    restartBtn.hidden = _groupImage.hidden = _doneBtn.hidden = !isTake;
    
    if (_functionType == TakePhotoIDCardFrontType || _functionType == TakePhotoIDCardBackType) {
        _switchBtn.hidden = YES;
    }
}

- (IBAction)takePic:(UIButton *)sender {
    [self gainPicture];
}

- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didFinishPickingImage:)]) {
        [_delegate didFinishPickingImage:[previewImage fixOrientation]];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)switchAction:(UIButton *)sender {
    
    [self swapFrontAndBackCameras];
    sender.selected = !sender.selected;
}

- (IBAction)restartAction:(UIButton *)sender {
    [self setDonePicture:NO];
    if (self.session) {
        [self.session startRunning];
    }
}
#pragma mark 判断是否可以进行拍照
- (BOOL)isAuthorizedCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    return !(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted);
}

-(BOOL)isCameraAvailable
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL isAvailable =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    BOOL _isCameraAvailable = YES;
    if (!isAvailable || [mediaTypes count] <= 0) {
        _isCameraAvailable = NO;
    }
    
    return _isCameraAvailable ;
}
#pragma mark startMotionManager 重力感应
- (void)startMotionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
           self.toInterfaceOrientation = UIDeviceOrientationPortraitUpsideDown;
        }else{
            self.toInterfaceOrientation = UIDeviceOrientationPortrait;
        }
    }else{
        if (x >= 0){
            self.toInterfaceOrientation = UIDeviceOrientationLandscapeRight;
        }else{
            self.toInterfaceOrientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}
-(void)dealloc
{
    [_motionManager stopDeviceMotionUpdates];
}

@end
