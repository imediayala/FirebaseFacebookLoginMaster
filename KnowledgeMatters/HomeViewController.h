//
//  HomeViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UINavigationControllerDelegate, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageBox;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)EditingBlogProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editingButtonProperty;
 ///
@end
