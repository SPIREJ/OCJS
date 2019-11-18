//
//  SP_JSObject.h
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SPProtocol <JSExport>

- (void)doSomething;

- (void)doSomething2:(NSString *)str;

// 协议 - 协议方法
JSExportAs(getS, - (int)getSum:(int)num1 num2:(int)num2);

@end

@interface SP_JSObject : NSObject<SPProtocol>

@end

NS_ASSUME_NONNULL_END
