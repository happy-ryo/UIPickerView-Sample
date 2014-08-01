//
//  ViewController.m
//  picker-sample
//
//  Created by happy_ryo on 2014/08/01.
//  Copyright (c) 2014年 happy_ryo. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *_titleStringArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _titleStringArray = @[@"hoge", @"fuga", @"piyo"];
}

- (IBAction)loadHud {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(removeHud) withObject:nil afterDelay:2];
}

- (void)removeHud {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (IBAction)loadPickerView {
    // 2重表示チェック
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIPickerView class]]) {
            return;
        }
    }

    CGRect bounds = [UIScreen mainScreen].bounds;

    // 一旦画面外に配置する
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 200)];
    pickerView.backgroundColor = [UIColor blackColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];

    [UIView animateWithDuration:0.3 animations:^{
        // 自身の高さ分上に移動する
        pickerView.transform = CGAffineTransformMakeTranslation(0, pickerView.frame.size.height * -1);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _titleStringArray.count;
}

#pragma mark UIPickerViewDataSource

// 各行に表示する文字列を返す
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return _titleStringArray[(NSUInteger) row];
//}

// 各行の文字列のスタイルを返す
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:_titleStringArray[(NSUInteger) row] attributes:attributes];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sample"
                                                        message:_titleStringArray[(NSUInteger) selectedRow]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

    [UIView animateWithDuration:0.3 animations:^{
        // 位置を元に戻す
        pickerView.transform = CGAffineTransformIdentity;
    }                completion:^(BOOL finished) {
        // 位置が戻った後、取り除く
        if (finished) {
            [pickerView removeFromSuperview];
        }
    }];
}


@end
