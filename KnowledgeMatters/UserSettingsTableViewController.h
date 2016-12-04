//
//  UserSettingsTableViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 30/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface UserSettingsTableViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageBox;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *DOBPickerProperty;
@property (weak, nonatomic) IBOutlet MKMapView *mapKitProperty;

@end
