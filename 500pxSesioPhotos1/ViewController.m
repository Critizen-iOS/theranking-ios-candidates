//
//  ViewController.m
//  500pxSesioPhotos1
//
//  Created by Sergio Becerril on 11/11/14.
//  Copyright (c) 2014 Sergio Becerril. All rights reserved.
//

#import "ViewController.h"

//Importamos la clase de la celda cusomizada
#import "CustomCellCollectionViewCell.h"
//Importamos la clase del API 500px
#import <PXAPI/PXAPI.h>
//Importamos la clase de la vista detalle
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Registramos la celda customizada
    [self.photosCollectionView registerNib:[UINib nibWithNibName:@"CustomCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    // indicamos la url desde donde tomaremos los datos y los convertimos a un objeto NSDATA
    NSURL *url = [NSURL URLWithString:@"https://api.500px.com/v1/photos?feature=popular&page=1&consumer_key=Rspv4Pq9q2DzvrBFcQdvisEh5xedohf7pgHZWU3o"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    //Llamamos al método aParsear pasándole como parámetro el objeto NSData
    [self aParsear:urlData];
    
}


- (void) aParsear:(NSData *)urlData
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        
        // parseamos los datos de la URL.
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:urlData
                                                                options:0
                                                                  error:&error];
        // si hubo algún error en el parseo lo mostramos
        if (error != nil)
        {
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
        else {
            datos = [jsonDic objectForKey:@"photos"];
            
            NSLog(@"%@", datos = [jsonDic objectForKey:@"photos"] );
        }
        
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return datos.count;
}


- (CustomCellCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCellCollectionViewCell *cell = [self.photosCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    self.datosFotos = [datos objectAtIndex:indexPath.row];
    
    UILabel *rating = (UILabel *) [cell viewWithTag:300];
    
    rating.text = [NSString stringWithFormat:@"%@",[self.datosFotos objectForKey:@"rating"]];
    
    UILabel *namePhoto = (UILabel *)[cell viewWithTag:200];
    
    namePhoto.text = [self.datosFotos objectForKey:@"name"];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",[self.datosFotos objectForKey:@"image_url"]]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];

     [recipeImageView setImage:image];
    
       return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    NSDate *object = [datos objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
    

}




@end
