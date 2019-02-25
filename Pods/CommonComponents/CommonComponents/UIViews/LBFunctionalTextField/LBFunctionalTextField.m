//
//  FunctionalTextField.m
//  FunctionalTextField
//
//  Created by 刘彬 on 16/3/28.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBFunctionalTextField.h"
@implementation LBFunctionalTextField

- (instancetype)init
{
    self = [[self.class alloc] initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (self.f_inputType == FCVV2Input) {
        if (action == @selector(paste:))//禁止粘贴
            return NO;
        if (action == @selector(select:))// 禁止选择
            return NO;
        if (action == @selector(selectAll:))// 禁止全选
            return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}
-(void)setF_inputType:(FTextFieldInputType)lb_inputType{
    _f_inputType = lb_inputType;
    switch (lb_inputType) {
        case FPhoneNumberInput:
        case FBankCardNumberInput:
        case FCVV2Input:
        case VerificationCode:
        case FPayPasswordInput:
        case FIndateInput:
        case FPercentInput:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case FMoneyInput:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case FPasswordInput:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        default:
            break;
    }
}
-(NSError *)f_inputError{
    NSString *errorDescription = nil;
    if (!self.text.length){
        errorDescription = [self.placeholder rangeOfString:@"输入"].length?self.placeholder:[NSString stringWithFormat:@"请输入%@",self.placeholder];
    }else{
        switch (self.f_inputType) {
            case FBankCardNumberInput:
                if (self.text.length && ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(\\d{14,20})"] evaluateWithObject:self.text]){
                    errorDescription = @"请输入正确的银行卡号";
                }
                break;
            case FMoneyInput:
                if (![self.text floatValue] || ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]+(.[0-9]{1,2})?$"] evaluateWithObject:self.text]) {
                    errorDescription = @"请输入有效金额";
                }
                break;
            case FIDCardNumberInput:
                if (self.text.length && ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(\\d{14}|\\d{17})(\\d|[xX])$"] evaluateWithObject:self.text]){
                    errorDescription = @"请输入正确的身份证号码";
                }
                break;
            case FPhoneNumberInput:
                if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1(\\d{10})"] evaluateWithObject:self.text]){
                    errorDescription = @"请输入正确的手机号码";
                }
                break;
            case FIndateInput:
                if (self.text.length < 4 || [[self.text substringToIndex:2] integerValue] > 12 || [[self.text substringToIndex:2] integerValue] == 0 || [[self.text substringFromIndex:2] integerValue] > 31 || [[self.text substringFromIndex:2] integerValue] == 0){
                    errorDescription = @"请输入正确的有效期";
                }
                break;
            case FCVV2Input:
                if (self.text.length < 3){
                    errorDescription = @"请输入3位安全码";
                }
                break;
            case FPasswordInput:
            {
                if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![a-zA-Z0-9]+$)(?![^a-zA-Z/D]+$)(?![^0-9/D]+$).{8,16}$"] evaluateWithObject:self.text]) {
                    errorDescription = @"密码必须由8-16位字母、数字和特殊字符组成";
                    
                }
            }
                break;
            case FPayPasswordInput:
            {
                NSUInteger index = 0;
                BOOL isNotAllEnqual = NO;
                while ((!isNotAllEnqual) && (index+1) < self.text.length) {
                    if ([[self.text substringWithRange:NSMakeRange(index, 1)] isEqualToString:[self.text substringWithRange:NSMakeRange(index+1, 1)]]) {
                        index ++;
                    }else{
                        isNotAllEnqual = YES;
                    }
                }
                
                
                NSUInteger index2 = 0;
                BOOL isNotAscending = NO;
                while ((!isNotAscending) && (index2+1) < self.text.length) {
                    if ([[self.text substringWithRange:NSMakeRange(index2, 1)] integerValue] + 1 == [[self.text substringWithRange:NSMakeRange(index2+1, 1)] integerValue]) {
                        index2 ++;
                    }else{
                        isNotAscending = YES;
                    }
                }
                
                NSUInteger index3 = 0;
                BOOL isNotDescending = NO;
                while ((!isNotDescending) && (index3+1) < self.text.length) {
                    if ([[self.text substringWithRange:NSMakeRange(index3, 1)] integerValue] - 1 == [[self.text substringWithRange:NSMakeRange(index3+1, 1)] integerValue]) {
                        index3 ++;
                    }else{
                        isNotDescending = YES;
                    }
                }
                
                
                if (!isNotAllEnqual || !isNotAscending || !isNotDescending || [self.text isEqualToString:@"123456"] ||  [self.text isEqualToString:@"654321"]) {
                    errorDescription = @"为了您的账户安全，请避免输入过于简单的支付密码";
                }
            }
                break;
            default:
                break;
        }
    
    }
    NSError *inputError = nil;
    if (errorDescription) {
        inputError = [NSError errorWithDomain:@"FInputError" code:9999 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
    }
    return inputError;
}

-(NSString *)text{
    return [[super text] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


-(void)textFieldTextDidChange:(NSNotification *)notification{
    if (self.f_inputType == FBankCardNumberInput) {
        NSMutableString *string = [self.text mutableCopy];

        while ([[string componentsSeparatedByString:@" "] lastObject].length > 4) {
            NSUInteger spaceNumber = [string componentsSeparatedByString:@" "].count-1;
            [string insertString:@" " atIndex:spaceNumber+(spaceNumber+1)*4];
        }
        self.text = string;
        
        if (self.text.length>19){
            self.text = [self.text substringToIndex:19];
        }
    }else if (self.f_inputType == FPhoneNumberInput){
        NSMutableString *string = [self.text mutableCopy];
        
        while ([[string componentsSeparatedByString:@" "] lastObject].length > ((string.length<7)?3:4)) {
            NSUInteger spaceNumber = [string componentsSeparatedByString:@" "].count-1;
            if (string.length<7) {
                [string insertString:@" " atIndex:3];
            }else{
                [string insertString:@" " atIndex:3+spaceNumber+spaceNumber*4];
            }
            
        }
        self.text = string;
        
        if (self.text.length > 11){
            self.text = [self.text substringToIndex:11];
        }
    }else if (self.f_inputType == FMoneyInput){
        if ([self.text rangeOfString:@"."].length && [[self.text componentsSeparatedByString:@"."] lastObject].length >2) {
            self.text = [self.text substringToIndex:4];
        }else if (self.text.length>15){
            self.text = [self.text substringToIndex:15];
        }
    }else if (self.f_inputType == FIDCardNumberInput){
        if (self.text.length>18) {
            self.text = [self.text substringToIndex:18];
        }
    }else if (self.f_inputType == FIndateInput){
        if (self.text.length>4) {
            self.text = [self.text substringToIndex:4];
        }
    }else if (self.f_inputType == FCVV2Input){
        if (self.text.length>3) {
            self.text = [self.text substringToIndex:3];
        }
    }else if (self.f_inputType == VerificationCode){
        if (self.text.length>6) {
            self.text = [self.text substringToIndex:6];
        }
    }else if (self.f_inputType == FPasswordInput){
        if (self.text.length > 16) {
            self.text = [self.text substringToIndex:16];
        }
    }else if (self.f_inputType == FPayPasswordInput){
        if (self.text.length > 6) {
            self.text = [self.text substringToIndex:6];
        }
    }else if (self.f_inputType == FPercentInput){
        if (self.text.integerValue > 100) {
            self.text = @"100";
        }
    }
}

+(BOOL)textField:(LBFunctionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![textField isKindOfClass:[UITextField class]]) {
        return YES;
    }
    if (string.length && [textField isKindOfClass:[LBFunctionalTextField class]]) {
        if (textField.f_inputType == FBankCardNumberInput) {
            if (textField.text.length>=19){
                return NO;
            }
        }else if (textField.f_inputType == FMoneyInput){
            if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
                return NO;
            }else if (!textField.text.length && [string isEqualToString:@"."]){
                textField.text = @"0";
                return YES;
            }else if ([textField.text rangeOfString:@"."].length){
                if ([[textField.text componentsSeparatedByString:@"."] lastObject].length >=2) {
                    return NO;
                }else if ([string isEqualToString:@"."]){
                    return NO;
                }
            }
        }else if (textField.f_inputType == FIDCardNumberInput){
            if (textField.text.length>17) {
                return NO;
            }
        }else if (textField.f_inputType == FPhoneNumberInput){
            if (textField.text.length > 10){
                return NO;
            }
        }else if (textField.f_inputType == FIndateInput){
            if (textField.text.length>3) {
                return NO;
            }
        }else if (textField.f_inputType == FCVV2Input){
            if (textField.text.length>2) {
                return NO;
            }
        }else if (textField.f_inputType == VerificationCode){
            if (textField.text.length>5) {
                return NO;
            }
        }else if (textField.f_inputType == FPasswordInput){
            if (textField.text.length > 15) {
                return NO;
            }
        }else if (textField.f_inputType == FPayPasswordInput){
            if (textField.text.length > 5) {
                return NO;
            }
        }else if (textField.f_inputType == FPercentInput){
            if (textField.text.integerValue >= 100) {
                return NO;
            }
        }
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation UIResponder (TextFieldDelegateResolveInvocation)
-(BOOL)respondsToSelector:(SEL)aSelector{
    if (aSelector == @selector(textField:shouldChangeCharactersInRange:replacementString:)) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}
//当delegate未实现代理方法的时候将会走将forwardingTargetForSelector，此时让自定义对象去实现
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(textField:shouldChangeCharactersInRange:replacementString:)) {
        if ([LBFunctionalTextField respondsToSelector: aSelector]) {
            return LBFunctionalTextField.self;
        }
    }
    return [super forwardingTargetForSelector: aSelector];
}
//fdasfa
@end

