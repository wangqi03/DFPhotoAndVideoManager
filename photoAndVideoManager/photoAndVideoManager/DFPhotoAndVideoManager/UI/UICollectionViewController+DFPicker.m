//
//  UICollectionViewController+DFPicker.m
//
//  Created by wanghaojiao on 2017/8/10.
//

#import "UICollectionViewController+DFPicker.h"

@implementation UIViewController (DFPicker)

- (void)addACancelButton {
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
