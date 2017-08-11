//
//  DFAlbumOrImagePickerController.h
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoAndVideoManager.h"

@interface DFAlbumCollectionController : UICollectionViewController

@property (nonatomic,strong) NSMutableArray<PHAssetCollection*>* albums;
@property (nonatomic) DFPAVMediaType type;

@end
