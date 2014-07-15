//
//  FNMessageProxy.m
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import "VTMessageProxy.h"

@interface FNMessageProxy()
@property(nonatomic, weak) UIViewController *parentViewController;
@property(nonatomic, strong) NSString *recipitentString;
@end
@implementation FNMessageProxy
@synthesize parentViewController;
@synthesize recipitentString;
@synthesize delegate;
- (void)sendWithMessage:(NSString *)body
         andRecipitents:(NSArray *)recipitents
       inViewController:(UIViewController<IRTMessageProxyDelegate> *)parent
{
    Class msgClass = NSClassFromString(@"MFMessageComposeViewController");
    self.delegate = parent;
    if ((nil != msgClass) && [msgClass canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        [picker setMessageComposeDelegate:self];
        [picker setBody:body];
        [picker setRecipients:recipitents];
        [self setParentViewController:parent];
        [self.delegate messageProxyWillSendMessage:self];
        [parent presentViewController:picker animated:YES completion:NULL];
    } else {
        [[UIPasteboard generalPasteboard] setString:body];
        NSMutableString *sendString = [[NSMutableString alloc] initWithCapacity:0];
        [sendString appendString:@"sms://"];
        for (NSString *number in recipitents) {
            [sendString appendString:[NSString stringWithFormat:@"%@;", number]];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sendString]];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //处理 result：MessageComposeResultFailed
    [parentViewController dismissViewControllerAnimated:YES completion:NULL];
    if (MessageComposeResultSent == result) {
    } else if (MessageComposeResultFailed == result){
    }
    [self.delegate messageProxyDidSendMessage:result];
    self.delegate = nil;
}

+ (FNMessageProxy *)shared
{
    static FNMessageProxy *instance = nil;
    if (nil == instance) {
        instance = [[FNMessageProxy alloc] init];
    }
    return instance;
}
@end