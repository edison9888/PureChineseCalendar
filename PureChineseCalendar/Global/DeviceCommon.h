//
//  DeviceCommon.h
//  WYISOFramework
//
//  Created by wangyang on 13-7-3.
//  Copyright (c) 2013年 wangyang. All rights reserved.
//

#ifndef WYISOFramework_DeviceCommon_h
#define WYISOFramework_DeviceCommon_h

#define iOS6OrLater                     ([UIDevice currentDevice].systemVersion.floatValue >=6.0 ? YES : NO)
#define iOS7OrLater                     ([UIDevice currentDevice].systemVersion.floatValue >=7.0 ? YES : NO)
#define isIPhone                        ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define isIPad                          ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

#define iPhone4                         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5                         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ipad2                           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)
#define ipad4                           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20

//device 与 screen 的宽高不是一个概念，在设备rotate时，device的宽高不会变，而screen的宽高是可以互换的
#define UI_DEVICE_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_DEVICE_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] applicationFrame].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] applicationFrame].size.height)



#endif
