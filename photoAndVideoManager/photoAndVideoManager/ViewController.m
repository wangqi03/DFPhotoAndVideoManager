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
    [[DFPhotoAndVideoManager manager] embedImagePickerOfType:DFPAVMediaTypeAll inNavigationController:navi];
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
    self.resultLabel.text = [NSString stringWithFormat:@"%lu assets selected",(unsigned long)assets.count];
    
    PHAsset* asset = [assets lastObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [[DFPhotoAndVideoManager manager] requestImageDataForAsset:asset resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            NSLog(@"%@",info);
            
        }];
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        [[DFPhotoAndVideoManager manager] requestAVAssetForVideo:asset resultHandler:^(AVURLAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
        }];
    }
}

- (void)putFileToAppTempFolderAtPath:(NSString*)originalPath {
    
}

@end
