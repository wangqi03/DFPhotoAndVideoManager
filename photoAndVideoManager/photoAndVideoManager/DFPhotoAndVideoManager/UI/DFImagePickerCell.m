//
//  HCYImagePickerCell.m
//
//  Created by wanghaojiao on 2017/8/8.
//

#import "DFImagePickerCell.h"
#import "DFPhotoAndVideoManager.h"

@interface DFImagePickerCell()
@property (nonatomic,assign) PHImageRequestID requestId;
@end

@implementation DFImagePickerCell

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    if (self.requestId != -1) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
    }
    self.myImage.image = nil;
    
    
    if (_asset) {
        PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        self.requestId = [[DFPhotoAndVideoManager manager] requestImageForAsset:_asset targetSize:self.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myImage.image = result;
            });
        }];
        
    } else {
        self.requestId = -1;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.requestId = -1;
}

@end
