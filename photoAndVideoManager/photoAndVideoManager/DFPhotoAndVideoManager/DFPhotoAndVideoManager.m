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
            [collection addObject:obj];
        }];
        
        completion(collection);
    }];
}

- (void)fetchItemsFromAlbum:( PHAssetCollection* _Nonnull )collection withCompletion:(void (^)(NSArray<PHAsset*>*))completion {
    [self guaranteeAuthBeforeDoing:^{
        
        NSMutableArray<PHAsset*>* photos = [[NSMutableArray alloc] init];
        
        PHFetchResult<PHAsset*> *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [photos addObject:obj];
        }];
        
        completion(photos);
    }];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options resultHandler:(void (^)(UIImage * _Nullable, NSDictionary * _Nullable))resultHandler {
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

#pragma mark - uiassist
- (void)embedImagePickerInNavigationController:(UINavigationController *)navigationController {
    [self embedImagePickerInNavigationController:navigationController defaultAlbumSelectionBlock:^BOOL (PHAssetCollection *album) {
        if ([album.localizedTitle isEqualToString:@"相机胶卷"]||[album.localizedTitle isEqualToString:@"Camera Roll"]) {
            return YES;
        }
        return NO;
    }];
}

- (void)embedImagePickerInNavigationController:(UINavigationController *)navigationController defaultAlbumSelectionBlock:(BOOL (^)(PHAssetCollection *))selectionBlock {
    DFAlbumCollectionController* vc1 = [[DFAlbumCollectionController alloc] initWithNibName:@"DFAlbumCollectionController" bundle:nil];
    
    DFImagePickerController* vc2 = [[DFImagePickerController alloc] initWithNibName:@"DFImagePickerController" bundle:nil];
    
    [self fetchAllAlbumsWithCompletion:^(NSArray<PHAssetCollection *> *albums) {
        vc1.albums = [albums mutableCopy];
        PHAssetCollection* selected = nil;
        for (PHAssetCollection* collection in vc1.albums) {
            if (selectionBlock(collection)) {
                selected = collection;
                break;
            }
        }
        
        if (!selected) {
            selected = albums.lastObject;
        }
        vc2.title = selected.localizedTitle;
        [self fetchItemsFromAlbum:selected withCompletion:^(NSArray<PHAsset *> *items) {
            vc2.items = [items mutableCopy];
        }];
    }];
    
    navigationController.viewControllers = @[vc1,vc2];
    navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:navigationController action:@selector(dismissViewControllerAnimated: completion:)];
}

- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset *> *)assets {
    if ([self.delegate respondsToSelector:@selector(imagePickerDidDismissWithAssets:)]) {
        [self.delegate imagePickerDidDismissWithAssets:assets];
    }
}

@end
