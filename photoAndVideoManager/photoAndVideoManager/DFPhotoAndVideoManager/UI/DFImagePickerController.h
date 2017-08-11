//
//  DFImagePickerController.h
//
//  Created by wanghaojiao on 2017/8/8.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DFImagePickerController : UIViewController

@property (nonatomic,strong) NSMutableArray<PHAsset*>* items;

@end
