//
//  PhoneViewController.m
//  TextFieldForm
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PhoneViewController.h"
#import "ELTextInputForm.h"
@interface PhoneViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.textInputForm = [PhoneInputForm phoneInputForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)confrimPress:(id)sender {
    NSLog(@"form str %@",[self.textField.textInputForm isRightForm]);
}

@end
