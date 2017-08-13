//
//  DFImagePickerCell.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFImagePickerCell.h"
#import "DFPhotoAndVideoManager.h"

@interface DFImagePickerCell()
@property (nonatomic,assign) PHImageRequestID requestId;
@property (weak, nonatomic) IBOutlet UIImageView *selectTick;
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
        
        self.requestId = [[DFPhotoAndVideoManager manager] requestImageForAsset:_asset targetSize:CGSizeMake(self.frame.size.width*2, self.frame.size.height*2) resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
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
    self.selectTick.layer.cornerRadius = self.selectTick.frame.size.width/2;
    self.selectTick.clipsToBounds = YES;
    
    self.selectTick.layer.borderWidth = 1;
    self.selectTick.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.selectTick.hidden = !selected;
    self.myImage.alpha = selected?.6:1;
}

@end
