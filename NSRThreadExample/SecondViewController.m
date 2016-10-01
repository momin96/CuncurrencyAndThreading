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
@property (strong, nonatomic ) NSCache* cache;
@property (strong, nonatomic) NSOperationQueue* operationQueue;
@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"dealloc SecondViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cache = [[NSCache alloc]init];
    self.operationQueue = [[NSOperationQueue alloc] init];
    
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
    UIImage* image = [self.cache objectForKey:indexPath];
    if(image){
        NSLog(@"In main queue");
        cell.myImageView.image = image;
    }
    else{
//        [self imageDataUsingDispatchQueue:cell indexPath:indexPath];
        
        [self imageDataUsingDispatchQueue:cell indexPath:indexPath];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage* image = [self.cache objectForKey:indexPath];
    [self.navigationController popViewControllerAnimated:YES];
    if([self.delegate respondsToSelector:@selector(secondViewController:updateImageWithImage:)])
        [_delegate secondViewController:self updateImageWithImage:image];
    
}


- (UIImage*)imageFromImageData{
    NSURL* imageURL = [NSURL URLWithString:_urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *tileImgage = [[UIImage alloc] initWithData:imageData];
    
//    NSLog(@"image data %@",imageData);
    NSLog(@"File size is : %.8f KB",(float)imageData.length/1024.0f);
    
    return tileImgage;
}

- (void)imageDataUsingDispatchQueue:(CustomCellTableViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"In background queue");
        UIImage* image = [weakSelf imageFromImageData];
        [weakSelf.cache setObject:image forKey:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.myImageView.image = image;
        });
    });
}

- (void)imageDataUsingOperationQueue:(CustomCellTableViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    __weak typeof(self) weakSelf = self;

    NSBlockOperation* fetchImageDataOperation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage* image = [weakSelf imageFromImageData];
        [weakSelf.cache setObject:image forKey:indexPath];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.myImageView.image = image;
        }];
    }];
    
    [self.operationQueue addOperation:fetchImageDataOperation];
}
@end
