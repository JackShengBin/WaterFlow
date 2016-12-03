//
//  ViewController.m
//  瀑布流
//
//  Created by 梦想 on 2016/12/3.
//  Copyright © 2016年 zhai. All rights reserved.
//

#import "ViewController.h"
#import "BINWaterFlowLayout.h"
#import "Model.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UICollectionViewDataSource, BINWaterFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation ViewController

static  NSString * const cellId = @"cellId";

- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self setupRefesh];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupLayout{
    BINWaterFlowLayout *layout = [[BINWaterFlowLayout alloc] init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor orangeColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

- (void)setupRefesh{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refeshData)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreModels)];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)refeshData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *modes = [Model mj_objectArrayWithFilename:@"1.plist"];
        
        [self.images removeAllObjects];
        [self.images addObjectsFromArray:modes];
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
    });
}

- (void)loadMoreModels{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *modes = [Model mj_objectArrayWithFilename:@"1.plist"];
        [self.images addObjectsFromArray:modes];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    });
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld",self.images.count);
    self.collectionView.mj_footer.hidden = self.images.count == 0;
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = self.images[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] init];
    [cell addSubview:imageView];
    imageView.frame = cell.bounds;
    NSURL *url = [NSURL URLWithString:model.img];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image.jpg"]];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
    
    return cell;
}

- (CGFloat)waterFlowLayout:(BINWaterFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)width{
    Model *model = self.images[index];
    return [model.w floatValue] * width / [model.h floatValue];
}

//- (CGFloat)columnCountInWaterFlowLayout:(BINWaterFlowLayout *)layout{
//    return 5;
//}

- (CGFloat)columnMarginInWaterFlowLayout:(BINWaterFlowLayout *)layout{
    return 20;
}

- (UIEdgeInsets)edgeInWaterFlowLayout:(BINWaterFlowLayout *)layout{
    return UIEdgeInsetsMake(50, 30, 50, 30);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
