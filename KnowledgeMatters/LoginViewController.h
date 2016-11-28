//
//  LoginViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController : UIViewController<FBSDKLoginButtonDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)loginButton:(id)sender;

@end
