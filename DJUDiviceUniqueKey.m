//
//  DJUDiviceUniqueKey.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 24..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUDiviceUniqueKey.h"

@implementation DJUDiviceUniqueKey
+ (NSString *)getKey
{
    UIDevice *currentDevice = [[UIDevice alloc]init];
    NSUUID *deviceUUID = currentDevice.identifierForVendor;
    NSString *isKey = [NSString stringWithFormat:@"DJU%@INTRA",[deviceUUID UUIDString]];
    return isKey;
    
}
@end
