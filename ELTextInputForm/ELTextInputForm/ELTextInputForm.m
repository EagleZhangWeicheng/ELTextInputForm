//
//  TextFieldForm.m
//  TextFieldForm
//  文本限制输入
//  Created by Eagle on 2018/7/25.
//  Copyright © 2018年 Eagle. All rights reserved.
//
#import <objc/runtime.h>
#import "ELTextInputForm.h"

@implementation UITextField (TextInputForm)
-(void)setTextInputForm:(ELTextInputForm *)textInputForm{
    textInputForm.textInput = self;
    objc_setAssociatedObject(self, @"TextInputForm", textInputForm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ELTextInputForm*)textInputForm{
    return objc_getAssociatedObject(self, @"TextInputForm");
}
@end

@implementation UITextView (TextInputForm)
-(void)setTextInputForm:(ELTextInputForm *)textInputForm{
    textInputForm.textInput = self;
    objc_setAssociatedObject(self, @"TextInputForm", textInputForm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ELTextInputForm*)textInputForm{
    return objc_getAssociatedObject(self, @"TextInputForm");
}
@end


@implementation ELTextInputForm
- (instancetype)init{
    self = [super init];
    if (self) {
        self.ignoreStrs = [NSMutableArray arrayWithCapacity:0];
        self.minMessage = @"输入长度不能小于";
        self.maxMessage = @"输入长度不能大于";
    }
    return self;
}


-(void)setTextInput:(id)textInput{
    if (![_textInput isEqual:textInput]) {
        _textInput = textInput;
        if ([_textInput isKindOfClass:[UITextField class]]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:(UITextField*)_textInput];
        }
        else if ([_textInput isKindOfClass:[UITextView class]]){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:(UITextView*)_textInput];
        }
    }
}

-(void)textChange:(NSNotification*)noti{
    if ([noti.object isKindOfClass:[UITextField class]]) {
        UITextField *textField = noti.object;
        textField.text = [self formChangeText:textField.text];
    }
    else if ([noti.object isKindOfClass:[UITextView class]]){
        UITextView *textView = noti.object;
        textView.text = [self formChangeText:textView.text];
    }
}

-(NSString*)formChangeText:(NSString*)str;{
    for (NSString *ignoreStr in self.ignoreStrs) {
        str = [str stringByReplacingOccurrencesOfString:ignoreStr withString:@""];
    }
    
    str = [self ignorePrefixStr:@" " str:str]; //去掉头部空格
    
    if (str.length > self.maxLen) {
        str = [str substringToIndex:self.maxLen];
    }
    return str;
}


-(NSString*)ignorePrefixStr:(NSString*)ignorePrefixStr str:(NSString*)str;{//去掉头部一段什么字符
    NSInteger firstIndex = -1;
    for (NSInteger index = 0; index<str.length; index++) {
        NSString *tempStr = [str substringWithRange:NSMakeRange(index, 1)];
        if (![tempStr isEqualToString:ignorePrefixStr]) {
            firstIndex = index;
            break;
        }
    }
    
    if (firstIndex == -1) {
        str = @"";
    }
    else{
        str = [str substringFromIndex:firstIndex];
    }
    return str;
    
}

-(NSString*)ignoreSuffixStr:(NSString*)ignoreSuffixStr str:(NSString*)str;{//去掉头部一段特殊字符
    NSInteger lastIndex = -1;
    for (NSInteger index = str.length - 1; index>=0; index--) {
        NSString *tempStr = [str substringWithRange:NSMakeRange(index, 1)];
        if (![tempStr isEqualToString:ignoreSuffixStr]) {
            lastIndex = index;
            break;
        }
    }
    
    if (lastIndex == -1) {
        str = @"";
    }
    else{
        if (lastIndex < str.length - 1) {
            str = [str substringToIndex:lastIndex];
        }
    }
    return str;
    
}

-(void)ignoreInputSuffixBlank;{//去掉尾部空格
    if ([_textInput isKindOfClass:[UITextField class]]) {
        UITextField *text = self.textInput;
        text.text = [self ignoreSuffixStr:@" " str:text.text];
    }
    else if ([_textInput isKindOfClass:[UITextView class]]){
        UITextView *text = self.textInput;
        text.text = [self ignoreSuffixStr:@" " str:text.text];
    }
}

-(NSString*)contentString;{//内容
    if ([_textInput isKindOfClass:[UITextField class]]) {
        UITextField *text = self.textInput;
        return  text.text;
    }
    else if ([_textInput isKindOfClass:[UITextView class]]){
        UITextView *text = self.textInput;
        return text.text;
    }
    return @"";
}

-(NSString*)isRightForm{
    [self ignoreInputSuffixBlank];
    
    NSString *contentStr = [self contentString];
    
    if (contentStr.length < self.minLen) {
        return [NSString stringWithFormat:@"%@%ld",self.minMessage,self.minLen];
    }
    else if (contentStr.length > self.maxLen){
        return [NSString stringWithFormat:@"%@%ld",self.maxMessage,self.maxLen];
    }
    
    return nil;
}

- (void)dealloc{
    if ([_textInput isKindOfClass:[UITextField class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }
    else if ([_textInput isKindOfClass:[UITextView class]]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    }
}

@end

@implementation PhoneInputForm
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countryCode = 86; //默认中国手机
        self.minMessage = @"手机号码长度不能小于";
        self.maxMessage = @"手机号码长度不能大于";
        self.phoneMessage = @"不是规范的手机号码";
    }
    return self;
}

-(void)setCountryCode:(NSInteger)countryCode{
    if (_countryCode!= countryCode) {
        _countryCode  = countryCode;
        if (self.countryCode == 86) {
            self.minLen = 11; //最小有11
            self.maxLen = 11; //最大为11
        }
        else{
            self.minLen = 6; //最小有6
            self.maxLen = 11; //最大为11
        }
    }
}

+(id)phoneInputForm;{
    PhoneInputForm *temp = [[PhoneInputForm alloc] init];
    return temp;
}


-(NSString*)formChangeText:(NSString*)str;{
    NSString *backStr = @"";
    if (![str isTextInputFormOnlyNumberFormat]) {
        for (NSInteger index= 0;index<str.length;index++) {
            NSString *tempStr =  [str substringWithRange:NSMakeRange(index, 1)];
            if ([tempStr isTextInputFormOnlyNumberFormat]) {
                backStr = [NSString stringWithFormat:@"%@%@",backStr,tempStr];
            }
        }
    }

    backStr = [self ignorePrefixStr:@"0" str:backStr];
    if (backStr.length > self.maxLen) {
        backStr = [backStr substringToIndex:self.maxLen];
    }

    return backStr;
}

-(NSString*)isRightForm{
    NSString *superStr =  [super isRightForm];
    if (superStr != nil) {
        return superStr;
    }
    
    NSString *contentStr = [self contentString];
    if (self.countryCode == 86) {
        if (![contentStr isTextInputFormMobilePhoneNumFormat]) {
            return self.phoneMessage;
        }
    }
    return nil;
}
@end

@implementation EmailInputForm
+(id)emailInputForm;{
    EmailInputForm *temp = [[EmailInputForm alloc] init];
    return temp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxLen = 32;
        self.minLen = 6;
        self.minMessage = @"邮件长度不能小于";
        self.maxMessage = @"邮件长度不能大于";
        self.emailMessage = @"不是规范邮件格式";
    }
    return self;
}

-(NSString*)isRightForm{
    NSString *superStr =  [super isRightForm];
    if (superStr != nil) {
        return superStr;
    }
    
    NSString *contentStr = [self contentString];
    if (![contentStr isTextInputFormEmailFormat]) {
        return self.emailMessage;
    }
    
    return nil;
}

@end

@implementation NumberInputForm
+(id)numberInputForm;{
    NumberInputForm *temp = [[NumberInputForm alloc] init];
    return temp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxLen = 64;
        self.minLen = 1;
        self.minMessage = @"数字长度不能小于";
        self.maxMessage = @"数字长度不能大于";
    }
    return self;
}

-(NSString*)formChangeText:(NSString*)str;{
    NSString *backStr = @"";
    if (![str isTextInputFormOnlyNumberFormat]) {
        for (NSInteger index= 0;index<str.length;index++) {
            NSString *tempStr =  [str substringWithRange:NSMakeRange(index, 1)];
            if ([tempStr isTextInputFormOnlyNumberFormat]) {
                backStr = [NSString stringWithFormat:@"%@%@",backStr,tempStr];
            }
        }
    }
    
    backStr = [self ignorePrefixStr:@"0" str:backStr];
    if (backStr.length > self.maxLen) {
        backStr = [backStr substringToIndex:self.maxLen];
    }
    
    return backStr;
}


@end
