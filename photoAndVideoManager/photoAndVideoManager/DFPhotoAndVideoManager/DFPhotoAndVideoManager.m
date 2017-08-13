//
//  DFPhotoAndVideoManager.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFPhotoAndVideoManager.h"
#import "DFAlbumCollectionController.h"
#import "DFImagePickerController.h"

@interface DFPhotoAndVideoManager()<PHPhotoLibraryChangeObserver>
@property (nonatomic) BOOL isObservingPhotoChange;
@end

@implementation DFPhotoAndVideoManager

#pragma mark - actions
- (void)fetchAllAlbumsWithCompletion:(void (^)(NSArray<PHAssetCollection*>*))completion {
    [self guaranteeAuthBeforeDoing:^{
        
        NSMutableArray<PHAssetCollection*>* collection = [[NSMutableArray alloc] init];
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.includeHiddenAssets = NO;
        
        PHFetchResult<PHAssetCollection*> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:option];
        
        [result enumerateObjectsUsingBlock:^(PHAssetCollection*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.localizedTitle isEqualToString:@"Hidden"]||[obj.localizedTitle isEqualToString:@"已隐藏"]) {
                
            } else {
                [collection addObject:obj];
            }
            
        }];
        
        completion(collection);
    }];
}

#pragma mark -
- (void)fetchAllItemsFromAlbum:( PHAssetCollection* _Nonnull )collection withCompletion:(void (^)(NSArray<PHAsset*>*))completion {
    [self __fetchAllVideosFromAlbum:collection withOption:nil withCompletion:completion];
}

- (void)fetchAllItemsOfType:(DFPAVMediaType)type fromAlbum:(PHAssetCollection *)collection withCompletion:(void (^)(NSArray<PHAsset *> *))completion {
    PHFetchOptions* option = nil;
    switch (type) {
        case DFPAVMediaTypeImage:
        {
            option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            //NSPredicate(format:"mediaType = %d", PHAssetMediaType.video.rawValue);
        }
            break;
        case DFPAVMediaTypeVideo:
        {
            option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
        }
            break;
            
        default:
            break;
    }
    
    [self __fetchAllVideosFromAlbum:collection withOption:option withCompletion:completion];
}

- (void)__fetchAllVideosFromAlbum:(PHAssetCollection *)collection withOption:(PHFetchOptions*)option withCompletion:(void (^)(NSArray<PHAsset *> *))completion {
    [self guaranteeAuthBeforeDoing:^{
        
        NSMutableArray<PHAsset*>* photos = [[NSMutableArray alloc] init];
        
        PHFetchResult<PHAsset*> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [photos addObject:obj];
        }];
        
        completion(photos);
    }];
}

#pragma mark -
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage * _Nullable, NSDictionary * _Nullable))resultHandler {
    return [self __requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:resultHandler];
}

- (PHImageRequestID)__requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options resultHandler:(void (^)(UIImage * _Nullable, NSDictionary * _Nullable))resultHandler {
    if (!asset) {
        resultHandler(nil,nil);
        return 0;
    }
    
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
}

- (void)cancelImageRequest:(PHImageRequestID)requestId {
    [[PHImageManager defaultManager] cancelImageRequest:requestId];
}

#pragma mark - initialize and auth
+ (instancetype)manager {
    static DFPhotoAndVideoManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initManager];
    });
    return sharedInstance;
}

- (void)initManager {
    
}

- (void)dealloc {
    self.isObservingPhotoChange = NO;
}

- (void)guaranteeAuthBeforeDoing:(void (^)())thingsToDo {
    
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
        {
            self.isObservingPhotoChange = YES;
            thingsToDo();
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            NSThread* thread = [NSThread currentThread];
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self performSelector:@selector(guaranteeAuthBeforeDoing:) onThread:thread withObject:thingsToDo waitUntilDone:NO];
            }];
        }
            break;
        default:
        {
            if ([self.delegate respondsToSelector:@selector(photoAndVideoManagerDidFailAccessingUserAlbum)]) {
                [self.delegate photoAndVideoManagerDidFailAccessingUserAlbum];
            }
            thingsToDo();
        }
            break;
    }
    
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)setIsObservingPhotoChange:(BOOL)isObservingPhotoChange {
    if (_isObservingPhotoChange == isObservingPhotoChange) {
        return;
    }
    
    _isObservingPhotoChange = isObservingPhotoChange;
    
    if (_isObservingPhotoChange) {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    } else {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // TODO: tbc...handler library change here
}

@end
