//
//  ViewController.m
//  TextFieldForm
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "ELTextInputForm.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ELTextInputForm *textInputForm = [[ELTextInputForm alloc] init];
//    [textInputForm.ignoreStrs addObject:@" "];
    textInputForm.maxLen = 6;
    textInputForm.minLen = 2;
    self.textField.textInputForm = textInputForm;
    
    NSString *text = @"123456";
    for (NSString *tempStr in [text componentsSeparatedByString:text]) {
        NSLog(@"tempStr %@",tempStr);
    }
    NSLog(@"test test -%@-",[text substringFromIndex:6]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPress:(id)sender {
    NSLog(@"test %@",[self.textField.textInputForm isRightForm]);
}

@end
