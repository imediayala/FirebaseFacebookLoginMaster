//
//  LoginViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AVKit/AVKit.h>
#import "CustomLoginViewController.h"


@interface LoginViewController : AVPlayerViewController<FBSDKLoginButtonDelegate, UITextFieldDelegate>

@end
