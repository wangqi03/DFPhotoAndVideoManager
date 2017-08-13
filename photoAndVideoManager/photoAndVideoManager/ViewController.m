//
//  ViewController.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "ViewController.h"
#import "DFPhotoAndVideoManager+UIConvenience.h"

@interface ViewController ()<DFPhotoAndVideoManagerDelegate,DFPhotoAndVideoManagerUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController


- (IBAction)showImagePicker:(id)sender {
    [DFPhotoAndVideoManager manager].delegate = self;
    [DFPhotoAndVideoManager manager].uiDelegate = self;
    UINavigationController* navi = [[UINavigationController alloc] init];
    [[DFPhotoAndVideoManager manager] embedImagePickerOfType:DFPAVMediaTypeImage inNavigationController:navi];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - DFPhotoAndVideoManagerDelegate
- (void)photoAndVideoManagerDidFailAccessingUserAlbum {
    NSLog(@"ERROR: failed to get photo library access");
}

- (UIImage*_Nonnull)placeHolderImageForEmptyAlbumCover {
    return nil;
}

- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset*>*)assets {
    self.resultLabel.text = [NSString stringWithFormat:@"%d assets selected",assets.count];
}

@end
