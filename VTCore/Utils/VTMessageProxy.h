//
//  FNMessageProxy.h
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MessageUI.h>

@class FNMessageProxy;
@protocol IRTMessageProxyDelegate <NSObject>

- (void)messageProxyWillSendMessage:(FNMessageProxy *)aProxy;

- (void)messageProxyDidSendMessage:(MessageComposeResult)aResult;

@end
//发送短信代理类

@interface FNMessageProxy : NSObject<MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) id<IRTMessageProxyDelegate>delegate;
//发送短信
- (void)sendWithMessage:(NSString *)body
         andRecipitents:(NSArray *)recipitents
       inViewController:(UIViewController<IRTMessageProxyDelegate> *)parent;
+ (FNMessageProxy *)shared;
@end