//
//  UIDevice+VT.m
//  VTCore
//
//  Created by zhangyu on 1/17/14.
//  Copyright (c) 2014 Raxtone. All rights reserved.
//

#import "UIDevice+VT.h"
#import <AdSupport/AdSupport.h>
#import "VTCommonDef.h"

#if (kAPPUsePrivateApi)
#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>
NSString *serialNumber(void)
{
	NSString *serialNumber = nil;
	
	void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
	if (IOKit)
	{
		mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
		CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
		mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
		CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
		kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
		
		if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
		{
			mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
			if (platformExpertDevice)
			{
				CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformUUID"), kCFAllocatorDefault, 0);
                //IOPlatformSerialNumber
				if (CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
				{
					serialNumber = [NSString stringWithString:(__bridge NSString*)platformSerialNumber];
					CFRelease(platformSerialNumber);
				}
				IOObjectRelease(platformExpertDevice);
			}
		}
		dlclose(IOKit);
	}
	
	return serialNumber;
}
#endif

@implementation UIDevice (VT)
- (NSString *)uuid
{
#if (kAPPUsePrivateApi)
    return serialNumber();
#endif
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    VTLog(@"adid = %@",adId);
    return adId;
}
@end
