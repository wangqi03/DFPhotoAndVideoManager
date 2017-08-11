//
//  DFPhotoAndVideoManager.h
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

//********** delegate
@protocol DFPhotoAndVideoManagerDelegate <NSObject>

@optional
- (void)photoAndVideoManagerDidFailAccessingUserAlbum;
- (UIImage*_Nonnull)placeHolderImageForEmptyAlbumCover;
- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset*>*)assets;

@end

//********** manager
@interface DFPhotoAndVideoManager : NSObject

@property (nonatomic,weak) _Nullable id <DFPhotoAndVideoManagerDelegate> delegate;
+ (instancetype _Nonnull)manager;

//albums
- (void)fetchAllAlbumsWithCompletion:(void (^)(NSArray<PHAssetCollection*>*))completion;
- (void)fetchItemsFromAlbum:( PHAssetCollection* _Nonnull )collection withCompletion:(void (^)(NSArray<PHAsset*>*))completion;

//request thumb for assets
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;
- (void)cancelImageRequest:(PHImageRequestID)requestId;

//convenience ui components
- (void)embedImagePickerInNavigationController:(UINavigationController* _Nonnull)navigationController;
- (void)embedImagePickerInNavigationController:(UINavigationController* _Nonnull)navigationController defaultAlbumSelectionBlock:(BOOL (^)(PHAssetCollection*))selectionBlock;
- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset*>*)assets;

@end
