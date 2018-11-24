//
//  AES256Util.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 24..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES256Util : NSObject
+(NSString*)encWithString:(NSString*)string key:(NSString*)key;
+(NSString*)decWithString:(NSString*)string key:(NSString*)key;
@end
