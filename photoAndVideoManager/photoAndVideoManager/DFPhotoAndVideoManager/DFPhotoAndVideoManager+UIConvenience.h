//
//  DFPhotoAndVideoManager+UIConvenience.h
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFPhotoAndVideoManager.h"

@protocol DFPhotoAndVideoManagerUIDelegate <NSObject>

- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset*>*_Nullable)assets;
- (UIImage*_Nonnull)placeHolderImageForEmptyAlbumCover;

- (UIColor*_Nonnull)tintColorForImagePicker;
- (UIColor*_Nonnull)navigationItemColorForImagePicker;

- (NSString*_Nonnull)finishButtonTitleForImagePicker;
- (UIColor*_Nonnull)finishButtonTitleColorForImagePicker;

- (NSString*_Nonnull)cancelButtonTitleForImagePicker;

@optional
- (void)imagePickerReachedMaxmiumSelection;


@end

@interface DFPhotoAndVideoManager (UIConvenience)

@property (nonatomic,weak) _Nullable id<DFPhotoAndVideoManagerUIDelegate> uiDelegate;

//convenience ui components. you provide a navigation controller and present it.
- (void)embedImagePickerOfType:(DFPAVMediaType)type inNavigationController:(UINavigationController* _Nonnull)navigationController;
- (void)embedImagePickerOfType:(DFPAVMediaType)type inNavigationController:(UINavigationController* _Nonnull)navigationController defaultAlbumSelectionBlock:(BOOL (^)(PHAssetCollection*))selectionBlock maxmumSelectionCount:(NSInteger)count;//set to 0 if no limit

//you don't need to call this
- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset*>*)assets;

@end
