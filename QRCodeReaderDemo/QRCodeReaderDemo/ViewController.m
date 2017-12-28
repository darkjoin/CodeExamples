//
//  ViewController.m
//  QRCodeReaderDemo
//
//  Created by darkgm on 27/12/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"
#import "ScanView.h"

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// properties
@property (assign, nonatomic) BOOL isReading;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

// outlets:
@property (weak, nonatomic) IBOutlet ScanView *scanView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startStopButton;

// actions:
- (IBAction)startStopAction:(id)sender;
- (IBAction)readingFromAlbum:(id)sender;

@end

@implementation ViewController

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isReading = NO;
    self.captureSession = nil;
    
    [self loadSound];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scanView.timer.fireDate = [NSDate distantFuture];
}

#pragma mark - IBActions
- (IBAction)startStopAction:(id)sender
{
    if (!self.isReading) {
        [self startScanning];
        [self.view bringSubviewToFront:self.toolBar];   // display toolBar
        [self.view bringSubviewToFront:self.scanView];  // display scanView
        self.scanView.timer.fireDate = [NSDate distantPast];    //start timer
        [self.startStopButton setTitle:@"Stop"];
    }
    else {
        [self stopScanning];
        self.scanView.timer.fireDate = [NSDate distantFuture];  //stop timer
        [self.startStopButton setTitle:@"Start"];
    }
    
    self.isReading = !self.isReading;
}

- (IBAction)readingFromAlbum:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - HelpMethods
- (void)startScanning
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // add input
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (!deviceInput) {
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.captureSession addInput:deviceInput];
    
    // add output
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:metadataOutput];
    
    // configure output
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [metadataOutput setMetadataObjectsDelegate:self queue:queue];
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];  // qrcode
//    [metadataOutput setMetadataObjectTypes:[metadataOutput availableMetadataObjectTypes]];  // barcode
    
    // configure previewLayer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:self.previewLayer];
    
    // set the scanning area
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        metadataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
    }];
    
    // start scanning
    [self.captureSession startRunning];
}

- (void)stopScanning
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.previewLayer removeFromSuperlayer];
}

- (void)loadSound
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *soundURL = [NSURL URLWithString:soundFilePath];
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    if (error) {
        NSLog(@"Could not play sound file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        [self.audioPlayer prepareToPlay];
    }
}

- (void)displayMessage:(NSString *)message
{
    UIViewController *vc = [[UIViewController alloc] init];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:vc.view.bounds];
    [textView setText:message];
    [textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    textView.editable = NO;
    
    [vc.view addSubview:textView];
    
    [self.navigationController showViewController:vc sender:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// qrcode
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *message = [metadataObject stringValue];
            // display message
            [self performSelectorOnMainThread:@selector(displayMessage:) withObject:message waitUntilDone:YES];

            [self performSelectorOnMainThread:@selector(stopScanning) withObject:nil waitUntilDone:NO];
            [self.startStopButton performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start" waitUntilDone:NO];
            self.isReading = NO;

            // play sound
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
        }
    }
}

/*
// barcode
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadataObject in metadataObjects) {
        for (NSString *barcodeType in supportedBarcodeTypes) {
            if ([barcodeType isEqualToString:metadataObject.type]) {
                AVMetadataMachineReadableCodeObject *object = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                NSString *message = [object stringValue];
                // display message
                [self performSelectorOnMainThread:@selector(displayMessage:) withObject:message waitUntilDone:YES];

                [self performSelectorOnMainThread:@selector(stopScanning) withObject:nil waitUntilDone:NO];
                [self.startStopButton performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start" waitUntilDone:NO];
                self.isReading = NO;

                // play sound
                if (self.audioPlayer) {
                    [self.audioPlayer play];
                }
            }
        }
    }
}
*/

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    CIImage *ciImage = [[CIImage alloc] initWithImage:selectedImage];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    NSArray *features = [detector featuresInImage:ciImage];
    
    if (features.count > 0) {
        CIQRCodeFeature *feature = features.firstObject;
        NSString *message = feature.messageString;
        // display message
        [self displayMessage:message];
        
        // play sound
        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
    }
}

@end
