//
//  ViewController.h
//  500pxSesioPhotos1
//
//  Created by Sergio Becerril on 11/11/14.
//  Copyright (c) 2014 Sergio Becerril. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    
    NSMutableArray *datos;
    
}

@property (strong, nonatomic) NSDictionary *datosFotos;

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@property (strong, nonatomic) DetailViewController *detailViewController;



@end
