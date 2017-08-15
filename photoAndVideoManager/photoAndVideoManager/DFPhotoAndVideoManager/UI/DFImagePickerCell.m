//
//  DFImagePickerCell.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFImagePickerCell.h"
#import "DFPhotoAndVideoManager+UIConvenience.h"

@interface DFImagePickerCell()
@property (nonatomic,assign) PHImageRequestID requestId;
@property (weak, nonatomic) IBOutlet UIImageView *selectTick;
@property (nonatomic,assign) PHImageRequestID videoRequestId;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation DFImagePickerCell

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    if (self.requestId != -1) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
    }
    self.myImage.image = nil;
    
    self.durationLabel.hidden = YES;
    if (_asset) {
        PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        self.requestId = [[DFPhotoAndVideoManager manager] requestImageForAsset:_asset targetSize:CGSizeMake(self.frame.size.width*2, self.frame.size.height*2) resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myImage.image = result;
            });
        }];
        
        if (_asset.mediaType == PHAssetMediaTypeVideo) {
            self.videoRequestId = [[DFPhotoAndVideoManager manager] requestAVAssetForVideo:_asset resultHandler:^(AVURLAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.durationLabel.text = [self timeDisplayFromCMTime:asset.duration];
                    self.durationLabel.hidden = NO;
                });
            }];
        }
        
    } else {
        self.requestId = -1;
        self.videoRequestId = -1;
    }
}

- (NSString*)timeDisplayFromCMTime:(CMTime)duration {
    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    if (dHours) {
        return [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
    } else {
        return [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.requestId = -1;
    self.selectTick.layer.cornerRadius = self.selectTick.frame.size.width/2;
    self.selectTick.clipsToBounds = YES;
    
//    self.selectTick.layer.borderWidth = 1;
//    self.selectTick.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor* color = nil;
    if ([[DFPhotoAndVideoManager manager].uiDelegate respondsToSelector:@selector(tintColorForImagePicker)]) {
        color = [[DFPhotoAndVideoManager manager].uiDelegate tintColorForImagePicker];
    }
    
    if (!color) {
        color = [UIColor blueColor];
    }
    
    self.selectTick.backgroundColor = color;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.selectTick.hidden = !selected;
    self.myImage.alpha = selected?.6:1;
}

@end
