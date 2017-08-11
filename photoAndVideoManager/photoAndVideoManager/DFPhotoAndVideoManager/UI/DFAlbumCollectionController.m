//
//  DFAlbumOrImagePickerController.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFAlbumCollectionController.h"
#import "DFAlbumCell.h"
#import "DFImagePickerController.h"
#import "UICollectionViewController+DFPicker.h"

@interface DFAlbumCollectionController ()<UICollectionViewDelegateFlowLayout>

@end

@implementation DFAlbumCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"DFAlbumCell" bundle:nil] forCellWithReuseIdentifier:@"DFAlbumCell"];
    
    [self addACancelButton];
    self.title = @"相册";
}

- (void)setAlbums:(NSMutableArray<PHAssetCollection*>*)albums {
    _albums = albums;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DFImagePickerController* vc2 = [[DFImagePickerController alloc] initWithNibName:@"DFImagePickerController" bundle:nil];
    
    PHAssetCollection* album = [self.albums objectAtIndex:indexPath.row];
    
    vc2.title = album.localizedTitle;
    
    [[DFPhotoAndVideoManager manager] fetchItemsFromAlbum:album withCompletion:^(NSArray<PHAsset *> *items) {
        vc2.items = [items mutableCopy];
    }];
    
    [self.navigationController pushViewController:vc2 animated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DFAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFAlbumCell" forIndexPath:indexPath];
    
    cell.album = [self.albums objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.width/1.8);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
