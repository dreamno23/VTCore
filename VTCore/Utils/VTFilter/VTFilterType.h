//
//  VTFilterType.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTARGB8.h"

@interface VTFilterType : NSObject {
    @protected
    NSData * m_imageData_;
    
    CGSize m_imageSize_;
    
    void *param;
}
@property (nonatomic , readonly) NSData *m_imageData;

- (id)initWithImageData:(NSData *)imageData imageSize:(CGSize)imageSize paramValue:(void *)aParam;

- (NSData *)newImageData;
@end

@interface VTFilterInReverse : VTFilterType

@end

@interface VTFilterSmooth : VTFilterType

@end

@interface VTFilterRainbow : VTFilterType

@end

@interface VTFilterSharpen : VTFilterType {
    @private
    float m_sharpNum;
}

@end