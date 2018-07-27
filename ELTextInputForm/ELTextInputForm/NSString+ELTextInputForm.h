//
//  ELTextInputForm.h
//  
//  输入限制的nsstring;
//
//  Created by Eagle on 16/1/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  提供特定格式的字符串校验
 */
@interface NSString (TextInputForm)

/**
 *  是否是email格式
 */
- (BOOL)isTextInputFormEmailFormat;

/**
 *  是否是手机号码格式
 */
- (BOOL)isTextInputFormMobilePhoneNumFormat;


/**
 *  是否纯数字格式
 */
- (BOOL)isTextInputFormOnlyNumberFormat;

/**
 *  是否不带符号的密码格式[有字母数字组成]
 */
- (BOOL)isTextInputFormPasswordWithoutSymbolFormat;
@end
