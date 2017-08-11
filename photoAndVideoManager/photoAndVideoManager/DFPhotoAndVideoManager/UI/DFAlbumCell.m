//
//  DFAlbumCell.m
//
//  Created by wanghaojiao on 2017/8/10.
//

#import "DFAlbumCell.h"
#import "DFPhotoAndVideoManager.h"

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
    [[DFPhotoAndVideoManager manager] fetchItemsFromAlbum:_album withCompletion:^(NSArray<PHAsset *> *assets) {
        self.itemCountLabel.text = [NSString stringWithFormat:@"%ld",assets.count];
        self.requestId = [[DFPhotoAndVideoManager manager] requestImageForAsset:assets.lastObject targetSize:self.coverImage.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    self.coverImage.image = result;
                } else if ([[DFPhotoAndVideoManager manager].delegate respondsToSelector:@selector(placeHolderImageForEmptyAlbumCover)]) {
                    self.coverImage.image = [[DFPhotoAndVideoManager manager].delegate placeHolderImageForEmptyAlbumCover];
                }
            });
        }];
    }];
    self.albumNameLabel.text = self.album.localizedTitle;
    
}

@end
