//
//  VTCameraProxy.m
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import "VTCameraProxy.h"

@interface VTCameraProxy : NSObject <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
@property (nonatomic, copy) void (^imageHandler)(UIImage *aImage);
@property (nonatomic, copy) void (^errorHandler)(NSError *aError);

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong) UIPopoverController *popoverController;
@end
static VTCameraProxy *proxy = nil;
@implementation VTCameraProxy


- (BOOL)isDeviceCameraAvailable
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }else
        return NO;
}
+ (void)destory
{
    proxy.popoverController = nil;
    proxy.imageHandler = nil;
    proxy.errorHandler = nil;
    proxy = nil;
}
+ (VTCameraProxy *)share
{
    if (proxy == nil) {
        proxy = [[VTCameraProxy alloc]init];
    }
    return proxy;
}
- (void)imageInViewController:(UIViewController *)controller withType:(UIImagePickerControllerSourceType)type inRect:(CGRect)aShowRect
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        if(![self isDeviceCameraAvailable]){
            if (self.errorHandler) {
                self.errorHandler([NSError errorWithDomain:@"UIImagePickerControllerSourceType" code:VTCameraOpenErrorCodeNoSupport userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"当前设备不支持拍照功能!", NSLocalizedDescriptionKey, nil]]);
            }
            [self endImagePick];
            return;
        }
        self.parentViewController = controller;
        [controller presentViewController:picker animated:YES completion:^{
            
        }];
    } else  {
        NSString *deviceString = [[UIDevice currentDevice].model lowercaseString];
        if ([deviceString rangeOfString:@"pad"].location != NSNotFound) {
            [picker setTitle:@"照片"];
            UIPopoverController*popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover setDelegate:self];
            [popover setPopoverContentSize:CGSizeMake(500, 370)];
            self.popoverController= popover;
            [self.popoverController presentPopoverFromRect:aShowRect inView:controller.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        } else {
            self.parentViewController = controller;
            [controller presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)endImagePick
{
    if (self.popoverController) {
         [self.popoverController dismissPopoverAnimated:YES];//关掉当前视图
    }
    if (self.parentViewController) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        }];
    }
    [VTCameraProxy destory];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.imageHandler) {
        self.imageHandler(gotImage);
    }
    [self endImagePick];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.errorHandler) {
        self.errorHandler([NSError errorWithDomain:@"imagePickerControllerDidCancel" code:VTCameraOpenErrorCodeCancel userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"已取消!", NSLocalizedDescriptionKey, nil]]);
    }
    [self endImagePick];
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (self.errorHandler) {
        self.errorHandler([NSError errorWithDomain:@"imagePickerControllerDidCancel" code:VTCameraOpenErrorCodeCancel userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"已取消!", NSLocalizedDescriptionKey, nil]]);
    }
   [self endImagePick];
}

@end
void fnCameraShowInController(UIViewController *aCon,
                              CGRect inRect,
                              UIImagePickerControllerSourceType imageType,
                              void (^a)(UIImage *aImage) , //UIImage
                              void (^b)(NSError *aError) )
{
    [[VTCameraProxy share] setImageHandler:a];
    [[VTCameraProxy share] setErrorHandler:b];
    [[VTCameraProxy share] imageInViewController:aCon withType:imageType inRect:inRect];
}