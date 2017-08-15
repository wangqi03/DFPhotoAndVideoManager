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
    NSString* cancel = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(cancelButtonTitleForImagePicker)]) {
        cancel = [[DFPhotoAndVideoManager manager].uiDelegate cancelButtonTitleForImagePicker];
    }
    if (!cancel) {
        cancel = @"取消";
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(__dfpav_dismiss) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:cancel forState:UIControlStateNormal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIColor* color = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(navigationItemColorForImagePicker)]) {
        color = [[DFPhotoAndVideoManager manager].uiDelegate navigationItemColorForImagePicker];
    }
    if (!color) {
        color = [UIColor blueColor];
    }
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -30;
    
    self.navigationItem.rightBarButtonItems = @[item,space];
}

- (void)__dfpav_dismiss {
    [[DFPhotoAndVideoManager manager] imagePickerDidDismissWithAssets:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
