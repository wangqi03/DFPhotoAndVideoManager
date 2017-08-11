//
//  DFAlbumListViewController.m
//  photoAndVideoManager
//
//  Created by wanghaojiao on 2017/8/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "DFAlbumListViewController.h"
#import "DFPhotoAndVideoManager.h"

@interface DFAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView* tableview;

@property (nonatomic,strong) NSArray<PHAssetCollection*>* albums;

@end

@implementation DFAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview = [self myTableView];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [[DFPhotoAndVideoManager manager] fetchAllAlbumsWithCompletion:^(NSArray<PHAssetCollection *> *albums) {
        self.albums = albums;
        [self.tableview reloadData];
    }];
}

- (UITableView*)myTableView {
    UITableView* tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"DFAlbumListViewControllerCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PHAssetCollection* album = [self.albums objectAtIndex:indexPath.row];
    PHFetchResult<PHAsset*> *result = [PHAsset fetchAssetsInAssetCollection:album options:nil];
    
    cell.textLabel.text = album.localizedTitle;
    
    if (cell.tag) {
        [[DFPhotoAndVideoManager manager] cancelImageRequest:cell.tag];
    }
    
    if (!cell.tag) {
        cell.tag = [[DFPhotoAndVideoManager manager] requestImageForAsset:result.lastObject targetSize:CGSizeMake(44, 44) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = result;
            });
        }];
    }
    
    return cell;
}

@end
