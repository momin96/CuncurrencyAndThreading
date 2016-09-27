//
//  ViewController.m
//  NSRThreadExample
//
//  Created by Nasir Ahmed Momin on 11/09/16.
//  Copyright © 2016 MNSInfinite. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel* currentValue;
@property (weak, nonatomic) IBOutlet UISlider* slider;
@property (weak, nonatomic) IBOutlet UIButton* startThreadButton;
@property (weak, nonatomic) IBOutlet UIProgressView* progressView;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@property (strong, nonatomic) NSString* urlString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _urlString = @"https://api.mapbox.com/styles/v1/mobinius/cisrb7kf0000j2xqtwhyyj5fl/static/12.940689,77.576518,11/800x800?access_token=pk.eyJ1IjoibW9iaW5pdXMiLCJhIjoiY2lwN3gzNndvMDBuNmVhbnJ1dDFiYnZyaSJ9.Hh7KFM8AASCANZErUDiKhA";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startMyThreadButton:(UIButton*)sender{
    
//    [self downloadImage];
    
//    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];

//    [self downloadImageUsingGCD];
    
//    [self downloadImageUsingGCD];
    
//    [self downloadImageUsingBlockOperation];
    
    [self downloadImageUsingInvocationOperation];
    
    self.startThreadButton.selected = !self.startThreadButton.selected;
}

- (IBAction)tappedNextViewController:(UIButton*)sender{
    SecondViewController* secondVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    secondVC.urlString = _urlString;
    
    [secondVC.navigationController pushViewController:secondVC animated:YES];
}

- (UIImage*)imageFromImageData{
    NSURL* imageURL = [NSURL URLWithString:_urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *tileImgage = [[UIImage alloc] initWithData:imageData];
    
    NSLog(@"image data %@",imageData);
    NSLog(@"File size is : %.8f KB",(float)imageData.length/1024.0f);
    
    return tileImgage;
}

-(void)downloadImage{
    self.imageView.image = [self imageFromImageData];
}
- (void)downloadImageUsingGCD{
    // Fetching image tile on background queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *tileImgage = [self imageFromImageData];
        
        // Once fetching of tile image is completed, need to update data to the main queue.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = tileImgage;
        });
    });
}

- (void)downloadImageUsingBlockOperation{
    
    NSBlockOperation* downloadImageOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage *tileImgage = [self imageFromImageData];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = tileImgage;
        }];
        
    }];
    
    [downloadImageOperation start];
}

- (void)downloadImageUsingInvocationOperation{
    NSInvocationOperation* downloadImageOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchImage:) object:_urlString];
    
    NSOperationQueue *differentQueue = [[NSOperationQueue alloc] init];
    [differentQueue addOperation:downloadImageOperation];
}

- (void)fetchImage:(id)Object{
    UIImage *tileImgage = [self imageFromImageData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = tileImgage;
    }];
}

@end
