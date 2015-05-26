//
//  NSURLRequest+PrivateExposed.h
//  BingAPI
//
//  Created by Ian on 5/26/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@interface NSURLRequest (PrivateExposed)
+ (void) setAllowsAnyHTTPSCertificate:(BOOL)allowsAnyHTTPSCertificate forHost:(NSString *)host;
@end