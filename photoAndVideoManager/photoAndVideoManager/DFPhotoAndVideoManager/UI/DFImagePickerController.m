//
//  DFImagePickerController.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFImagePickerController.h"
#import "DFImagePickerCell.h"
#import "DFPhotoAndVideoManager+UIConvenience.h"
#import "UICollectionViewController+DFPicker.h"

#define SPACING 3

@interface DFImagePickerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView* collectionview;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;


@property (nonatomic,strong) NSMutableArray<PHAsset*>* selectedItems;

@end

@implementation DFImagePickerController

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.items.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DFImagePickerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFImagePickerCell" forIndexPath:indexPath];
    
    cell.asset = [self.items objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - actions
- (IBAction)clickedDone:(id)sender {
    [[DFPhotoAndVideoManager manager] imagePickerDidDismissWithAssets:self.selectedItems];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maxSelectionCount&&self.selectedItems.count>=self.maxSelectionCount) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(imagePickerReachedMaxmiumSelection)]) {
            [[DFPhotoAndVideoManager manager].uiDelegate imagePickerReachedMaxmiumSelection];
        }
        return;
    }
    
    [self.selectedItems addObject:[self.items objectAtIndex:indexPath.row]];
    [self refreshTitle];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems removeObject:[self.items objectAtIndex:indexPath.row]];
    [self refreshTitle];
}

- (void)refreshTitle {
    
    NSString* doneText = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(finishButtonTitleForImagePicker)]) {
        doneText = [[DFPhotoAndVideoManager manager].uiDelegate finishButtonTitleForImagePicker];
    }
    
    if (!doneText) {
        doneText = @"完成";
    }
    
    if (self.selectedItems.count) {
        [self.finishButton setTitle:[NSString stringWithFormat:@"%@(%lu)",doneText,(unsigned long)self.selectedItems.count] forState:UIControlStateNormal];
        self.finishButton.enabled = YES;
        self.finishButton.alpha = 1;
    } else {
        [self.finishButton setTitle:doneText forState:UIControlStateNormal];
        self.finishButton.enabled = NO;
        self.finishButton.alpha = .6;
    }
}

#pragma mark - basis
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //config collection view
    self.collectionview = [self myCollectionView];
    self.collectionview.allowsMultipleSelection = YES;
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"DFImagePickerCell" bundle:nil] forCellWithReuseIdentifier:@"DFImagePickerCell"];
    
    [self addACancelButton];
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
    
    UIColor* color = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(tintColorForImagePicker)]) {
        color = [[DFPhotoAndVideoManager manager].uiDelegate tintColorForImagePicker];
    }
    if (!color) {
        color = [UIColor blueColor];
    }
    
    self.finishButton.backgroundColor = color;
    
    color = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(finishButtonTitleColorForImagePicker)]) {
        color = [[DFPhotoAndVideoManager manager].uiDelegate finishButtonTitleColorForImagePicker];
    }
    
    if (!color) {
        color = [UIColor whiteColor];
    }
    
    [self refreshTitle];
    
    [self.finishButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)setItems:(NSMutableArray<PHAsset *> *)items {
    _items = items;
    [self.collectionview reloadData];
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
}

- (void)scrollToBottom {
    if (_items.count) {
        [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_items.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

- (UICollectionView*)myCollectionView {
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = SPACING;
    layout.minimumInteritemSpacing = SPACING;

    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.contentInset = UIEdgeInsetsMake(SPACING, SPACING, self.finishButton.frame.size.height+SPACING, SPACING);
    
    [self.view insertSubview:collectionView belowSubview:self.finishButton];
    
    return collectionView;
}

#pragma mark - collection view size etc
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (collectionView.frame.size.width-SPACING*5)/4;
    
    return CGSizeMake(width, width);
}

- (NSMutableArray<PHAsset*>*)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc] init];
    }
    
    return _selectedItems;
}

@end
