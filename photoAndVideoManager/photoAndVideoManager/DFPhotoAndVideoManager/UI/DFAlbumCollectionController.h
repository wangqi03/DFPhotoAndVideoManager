//
//  DFAlbumOrImagePickerController.h
//
//  Created by wanghaojiao on 2017/8/10.
//

#import <UIKit/UIKit.h>
#import "DFPhotoAndVideoManager.h"

@interface DFAlbumCollectionController : UICollectionViewController

@property (nonatomic,strong) NSMutableArray<PHAssetCollection*>* albums;

@end
