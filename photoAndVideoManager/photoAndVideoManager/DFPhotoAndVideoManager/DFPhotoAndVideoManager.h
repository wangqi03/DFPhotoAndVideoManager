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

@end

//********** enum
typedef enum {
    DFPAVMediaTypeAll=0,
    DFPAVMediaTypeImage=1,
    DFPAVMediaTypeVideo=2
} DFPAVMediaType;

//********** manager
@interface DFPhotoAndVideoManager : NSObject

//basis
+ (instancetype _Nonnull)manager;
@property (nonatomic,weak) _Nullable id <DFPhotoAndVideoManagerDelegate> delegate;

//albums list
- (void)fetchAllAlbumsWithCompletion:(void (^)(NSArray<PHAssetCollection*>*))completion;

//items list in album
- (void)fetchAllItemsFromAlbum:( PHAssetCollection* _Nonnull )collection withCompletion:(void (^)(NSArray<PHAsset*>*))completion;
- (void)fetchAllItemsOfType:(DFPAVMediaType)type fromAlbum:( PHAssetCollection* _Nonnull )collection withCompletion:(void (^)(NSArray<PHAsset*>*))completion;

//request thumb/image for item
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;
- (void)cancelImageRequest:(PHImageRequestID)requestId;

//request image

//request video

@end
