//
//  NSData+AES256.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 24..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end
