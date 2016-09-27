//
//  SecondViewController.m
//  NSRThreadExample
//
//  Created by Nasir Ahmed Momin on 27/09/16.
//  Copyright © 2016 MNSInfinite. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomCellTableViewCell.h"

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* myTableView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"CustomCellTableViewCell";
    CustomCellTableViewCell* cell = (CustomCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.myImageView.image = [self imageFromImageData];
    return cell;
}

- (UIImage*)imageFromImageData{
    NSURL* imageURL = [NSURL URLWithString:_urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *tileImgage = [[UIImage alloc] initWithData:imageData];
    
    NSLog(@"image data %@",imageData);
    NSLog(@"File size is : %.8f KB",(float)imageData.length/1024.0f);
    
    return tileImgage;
}

@end
