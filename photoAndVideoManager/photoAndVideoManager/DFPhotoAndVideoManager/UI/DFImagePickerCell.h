//
//  DFImagePickerCell.h
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DFImagePickerCell : UICollectionViewCell

@property (nonatomic,strong) PHAsset* asset;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@end
