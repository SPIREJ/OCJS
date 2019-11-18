//
//  SP_JSObject.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "SP_JSObject.h"

@implementation SP_JSObject

- (void)doSomething {
    NSLog(@"doSomething 来了");
}

- (void)doSomething2:(NSString *)str {
    NSLog(@"doSomething2 来了 -- %@", str);
}

- (int)getSum:(int)num1 num2:(int)num2 {
    NSLog(@"getSum 来了");
    // int (nil) - jsvalue (0)
    NSLog(@"num1 = %d, num2 = %d", num1, num2);
    return num1+num2;
}

@end
