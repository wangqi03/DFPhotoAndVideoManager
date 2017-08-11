//
//  DFAlbumCell.h
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DFAlbumCell : UICollectionViewCell

@property (nonatomic,strong) PHAssetCollection* album;

@end
