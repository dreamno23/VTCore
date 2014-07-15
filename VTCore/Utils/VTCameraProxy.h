//
//  FNCameraProxy.h
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VTCameraOpenErrorCode {
     VTCameraOpenErrorCodeNoSupport = -4222,
    VTCameraOpenErrorCodeCancel
    };
typedef NSInteger VTCameraOpenErrorCode;

void fnCameraShowInController(UIViewController *aCon,
                              CGRect inRect,
                              UIImagePickerControllerSourceType imageType,
                              void (^a)(UIImage *aImage) , //UIImage
                              void (^)(NSError *aError) );
