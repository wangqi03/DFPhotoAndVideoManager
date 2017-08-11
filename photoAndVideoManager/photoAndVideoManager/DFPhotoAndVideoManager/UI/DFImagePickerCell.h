//
//  HCYImagePickerCell.h
//
//  Created by wanghaojiao on 2017/8/8.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DFImagePickerCell : UICollectionViewCell
@property (nonatomic,strong) PHAsset* asset;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@end
