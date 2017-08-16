//
//  DFAlbumCell.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFAlbumCell.h"
#import "DFPhotoAndVideoManager+UIConvenience.h"

@interface DFAlbumCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;

@property (nonatomic) PHImageRequestID requestId;

@end

@implementation DFAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coverImage.layer.cornerRadius = 3;
    self.coverImage.clipsToBounds = YES;
}

- (void)setAlbum:(PHAssetCollection *)album {
    _album = album;
    
    [[DFPhotoAndVideoManager manager] cancelImageRequest:self.requestId];
    [[DFPhotoAndVideoManager manager] fetchAllItemsFromAlbum:_album withCompletion:^(NSArray<PHAsset *> *assets) {
        self.itemCountLabel.text = [NSString stringWithFormat:@"%ld",assets.count];
        self.requestId = [[DFPhotoAndVideoManager manager] requestImageForAsset:assets.lastObject targetSize:CGSizeMake(self.coverImage.frame.size.width*2, self.coverImage.frame.size.height*2) resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    self.coverImage.image = result;
                } else if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(placeHolderImageForEmptyAlbumCover)]) {
                    self.coverImage.image = [[DFPhotoAndVideoManager manager].uiDelegate placeHolderImageForEmptyAlbumCover];
                } else {
                    self.coverImage.image = nil;
                }
            });
        }];
    }];
    self.albumNameLabel.text = self.album.localizedTitle;
    
}

@end
