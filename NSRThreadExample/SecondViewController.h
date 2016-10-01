//
//  SecondViewController.h
//  NSRThreadExample
//
//  Created by Nasir Ahmed Momin on 27/09/16.
//  Copyright © 2016 MNSInfinite. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondViewController;
@protocol SecondViewControllerDelegate <NSObject>

@optional

- (void)secondViewController:(SecondViewController*)secondViewController updateImageWithImage:(UIImage*)image;

@end

@interface SecondViewController : UIViewController
@property (strong, nonatomic) NSString* urlString;

@property (strong, nonatomic) id <SecondViewControllerDelegate> delegate;
@end
