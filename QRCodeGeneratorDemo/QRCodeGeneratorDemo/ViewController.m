//
//  ViewController.m
//  QRCodeGeneratorDemo
//
//  Created by darkgm on 21/12/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// outlets
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

// property
@property (strong,  nonatomic) CIImage *qrcodeImage;

// actions
- (IBAction)clickButton:(id)sender;
- (IBAction)changeScale:(id)sender;
- (IBAction)tap:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slider.hidden = YES;
    self.imageView.userInteractionEnabled = YES;
}

- (IBAction)clickButton:(id)sender
{
    if (self.qrcodeImage == nil) {
        if ([self.textField.text isEqualToString:@""]) {
            return;
        }
        
        [self generateQRCodeImage];
        
        [self.textField resignFirstResponder];
        [self.button setTitle:@"Clear" forState:UIControlStateNormal];
    }
    else {
        [self clearQRCodeImage];
        
        [self.button setTitle:@"Generate" forState:UIControlStateNormal];
    }
    
    self.textField.enabled = !self.textField.enabled;
    self.slider.hidden = !self.slider.hidden;
}

- (IBAction)changeScale:(id)sender
{
    self.imageView.transform = CGAffineTransformMakeScale((CGFloat)self.slider.value, (CGFloat)self.slider.value);
}

- (IBAction)tap:(id)sender
{
    // 添加提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save QRCode?" message:@"The QRCode will be saved in Camera Roll album." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 保存二维码图像
        [self saveQRCodeImage];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:saveAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)generateQRCodeImage
{
    NSData *data = [self.textField.text dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:NO];
    
    // 创建并设置CIFilter对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    // 获取生成的CIImage对象
    self.qrcodeImage = filter.outputImage;
    
    // 缩放CIImage对象
    CGFloat scaleX = self.imageView.bounds.size.width / self.qrcodeImage.extent.size.width;
    CGFloat scaleY = self.imageView.bounds.size.height / self.qrcodeImage.extent.size.height;
    CIImage *transformedImage = [self.qrcodeImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    // 将调整后的CIImage对象转换成UIImage对象，并显示在图像视图中
    self.imageView.image = [UIImage imageWithCIImage:transformedImage];
}

- (void)clearQRCodeImage
{
    self.imageView.image = nil;
    self.qrcodeImage = nil;
    self.textField.text = nil;
}

- (void)saveQRCodeImage
{
    // 绘制图像
    UIGraphicsBeginImageContext(self.imageView.image.size);
    [self.imageView.image drawInRect:self.imageView.bounds];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 保存图像
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *title;
    NSString *message;
    
    if (!error) {
        title = @"Success!";
        message = @"The QRCode image saved successfully.";
    }
    else {
        title = @"Failed!";
        message = @"The QRCode image saved unsuccessfully, please try again later.";
    }
    
    // 使用alert view显示二维码保存状态
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
