//
//  TextinputForm.h
//  TextInputForm
//  文本限制输入
//  Created by Eagle on 2018/7/25.
//  Copyright © 2018年 Eagle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+ELTextInputForm.h"

@class ELTextInputForm;

@interface UITextField (TextInputForm)
@property(nonatomic,strong)ELTextInputForm *textInputForm;
@end

@interface UITextView (TextInputForm)
@property(nonatomic,strong)ELTextInputForm *textInputForm;
@end


@interface ELTextInputForm : NSObject //文本输入
@property(nonatomic)NSInteger minLen; //最少字符
@property(nonatomic,strong)NSString *minMessage;//最小字符提示语
@property(nonatomic)NSInteger maxLen; //最大字符
@property(nonatomic,strong)NSString *maxMessage;//最小字符提示语
@property(nonatomic,strong)NSMutableArray *ignoreStrs;//需要忽略字符

@property(nonatomic,weak)id textInput; //textField 或者textview


-(void)textChange:(NSNotification*)notifi;
-(NSString*)formChangeText:(NSString*)str;


-(NSString*)ignorePrefixStr:(NSString*)ignorePrefixStr str:(NSString*)str;//去掉头部一段什么字符
-(NSString*)ignoreSuffixStr:(NSString*)ignoreSuffixStr str:(NSString*)str;//去掉头部一段什么字符

-(void)ignoreInputSuffixBlank;//去掉尾部空格

-(NSString*)contentString;//内容
-(NSString*)isRightForm;//是否是正确的格式 正确返回nil

@end

@interface PhoneInputForm : ELTextInputForm //手机号码输入
@property(nonatomic)NSInteger countryCode;//国家代码
@property(nonatomic,copy)NSString *phoneMessage; //提示手机格式化
+(id)phoneInputForm;
@end

@interface EmailInputForm : ELTextInputForm //邮箱输入
@property(nonatomic,copy)NSString *emailMessage; //提示手机格式化
+(id)emailInputForm;
@end


@interface NumberInputForm : ELTextInputForm //数量输入
+(id)numberInputForm;

@end



