//
//  UICollectionViewController+DFPicker.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "UICollectionViewController+DFPicker.h"
#import "DFPhotoAndVideoManager+UIConvenience.h"

@implementation UIViewController (DFPicker)

- (void)addACancelButton {
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)dismiss {
    [[DFPhotoAndVideoManager manager] imagePickerDidDismissWithAssets:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
