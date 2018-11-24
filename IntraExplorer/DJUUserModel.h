//
//  DJUUserModel.h
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 10..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJUUserModel : NSObject
@property NSString *userCookie;
@property NSString *userId, *userPassword;

- (BOOL)loginWithId: (NSString *) inputId andPassword: (NSString *) inputPassword;

@end
