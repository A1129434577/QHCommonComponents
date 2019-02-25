//
//  FunctionalTextField.h
//  FunctionalTextField
//
//  Created by 刘彬 on 16/3/28.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FTextFieldInputType) {
    FBankCardNumberInput = 1,
    FMoneyInput,
    FIDCardNumberInput,
    FPhoneNumberInput,
    FIndateInput,
    FCVV2Input,
    VerificationCode,
    FPasswordInput,
    FPayPasswordInput,
    FPercentInput
};
@interface LBFunctionalTextField : UITextField
@property(nonatomic,getter=the_inputType)FTextFieldInputType f_inputType;
@property(nonatomic,readonly,strong)NSError *f_inputError;

+(BOOL)textField:(LBFunctionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end


