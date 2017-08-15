//
//  DFPhotoAndVideoManager+UIConvenience.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFPhotoAndVideoManager+UIConvenience.h"
#import <objc/runtime.h>
#import "DFAlbumCollectionController.h"
#import "DFImagePickerController.h"

@implementation DFPhotoAndVideoManager (UIConvenience)

- (void)setUiDelegate:(id<DFPhotoAndVideoManagerUIDelegate>)uiDelegate {
    objc_setAssociatedObject(self, "uiDelegate", uiDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<DFPhotoAndVideoManagerUIDelegate>)uiDelegate {
    return objc_getAssociatedObject(self, "uiDelegate");
}

#pragma mark - uiassist
- (void)embedImagePickerOfType:(DFPAVMediaType)type inNavigationController:(UINavigationController *)navigationController {
    [self embedImagePickerOfType:type inNavigationController:navigationController defaultAlbumSelectionBlock:^BOOL (PHAssetCollection *album) {
        if ([album.localizedTitle isEqualToString:@"相机胶卷"]||[album.localizedTitle isEqualToString:@"Camera Roll"]) {
            return YES;
        }
        return NO;
    } maxmumSelectionCount:0];
}

- (void)embedImagePickerOfType:(DFPAVMediaType)type inNavigationController:(UINavigationController *)navigationController defaultAlbumSelectionBlock:(BOOL (^)(PHAssetCollection *))selectionBlock maxmumSelectionCount:(NSInteger)count {
    DFAlbumCollectionController* vc1 = [[DFAlbumCollectionController alloc] initWithNibName:@"DFAlbumCollectionController" bundle:nil];
    vc1.type = type;
    
    DFImagePickerController* vc2 = [[DFImagePickerController alloc] initWithNibName:@"DFImagePickerController" bundle:nil];
    vc2.maxSelectionCount = count;
    
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
        
        [self fetchAllItemsOfType:type fromAlbum:selected withCompletion:^(NSArray<PHAsset *> *items) {
            vc2.items = [items mutableCopy];
        }];
    }];
    
    navigationController.viewControllers = @[vc1,vc2];
    navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:navigationController action:@selector(dismissViewControllerAnimated: completion:)];
}

- (void)imagePickerDidDismissWithAssets:(NSArray<PHAsset *> *)assets {
    if ([self.uiDelegate respondsToSelector:@selector(imagePickerDidDismissWithAssets:)]) {
        [self.uiDelegate imagePickerDidDismissWithAssets:assets];
    }
}

@end
