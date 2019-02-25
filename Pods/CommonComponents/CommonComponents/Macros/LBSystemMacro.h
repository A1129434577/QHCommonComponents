//
//  LBSystemHeader.h
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/2/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#ifndef LBSystemMacro_h
#define LBSystemMacro_h

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUNDLE_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define UUID_STRING [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define SYSTEM_VERSION [UIDevice currentDevice].systemVersion

#endif /* LBSystemMacro_h */
