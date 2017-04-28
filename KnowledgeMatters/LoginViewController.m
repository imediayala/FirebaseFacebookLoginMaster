
//
//  LoginViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomLoginViewController.h"

@import MediaPlayer;
@import Firebase;

@interface LoginViewController ()

@property UISlider *slider;
@property UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (weak, nonatomic) IBOutlet UIView *referencedView;
-(IBAction)connectedActionsViewTouchedUp:(UIButton*) button;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *userLabelPlaceholder;

@end


@implementation LoginViewController{
    
    NSURL* videoURL;
    AVQueuePlayer* queue;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];

    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
    }

    [self playAndLoopLoginVideo];
    
    [self blurImage];
    
    // Instantiate a referenced view (assuming outlet has hooked up in XIB).
    [[NSBundle mainBundle] loadNibNamed:@"CustomLoginView" owner:self options:nil];
    
    // Controller's outlet has been bound during nib loading, so we can access view trough the outlet.
    [self.view addSubview:self.referencedView];
    
    [self.userTextField setDelegate:self];

    
    // Create LoginButton Facebook
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    
    // Optional: Place the button in the center of your view.
    loginButton.center = CGPointMake(200,700);
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    


}


//-(void) awakeFromNib{
//
//
//    self.userTextField.placeholder = @"Usuario";
//    
//    // Extract attributes
//    NSDictionary * attributes = (NSMutableDictionary *)[ (NSAttributedString *)self.userTextField.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
//    NSMutableDictionary * newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
//    [newAttributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//    
//    // Set new text with extracted attributes
//    self.userTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.userTextField.attributedPlaceholder string] attributes:newAttributes];
//
//
//
//
//}




-(IBAction)connectedActionsViewTouchedUp:(UIButton*) button
{

    NSLog(@"Login Button OK");
    
    [self checksUserCredentials];
    
}


-(IBAction)updateValue:(id)sender{
    float sVaLue = _slider.value;
    _visualEffectView.alpha = sVaLue;
}



-(bool) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag==1) {
        //Caso del campo del usuario
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self checksUserCredentials];
    }
    return YES;

}
-(bool)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([self.userTextField.text isEqualToString:@""]) {
        self.userLabelPlaceholder.hidden = YES;

    }

    return YES;
}


-(bool)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([self.userTextField.text isEqualToString:@""]) {
        self.userLabelPlaceholder.hidden = NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButton:) name:UITextFieldTextDidChangeNotification object:nil];


    return YES;
}

-(void) updateButton:(NSNotification *)notification {

    NSLog(@"Watching TextFields Characters");
    
    if ([self.userTextField.text isEqualToString:@""]) {
        self.userLabelPlaceholder.hidden = NO;
    }else{
        if (![self.userTextField.text isEqualToString:@""]) {
            self.userLabelPlaceholder.hidden = YES;

        }
    }

    
    
}

-(void) checksUserCredentials{
    //    [usuarioTextField resignFirstResponder];
    //    [passTextField resignFirstResponder];
    NSString* usuario=_userTextField.text;
    NSString* pass=_passwordTextField.text;
    if ([usuario isEqualToString:@"admin"]
        && [pass isEqualToString:@"admin"]
        ) {
        NSLog(@"El usuario y la contraseña validan");
        [self performSegueWithIdentifier:@"goHome" sender:self];

    } else {
        NSLog(@"El usuario o la contraseña no son válidos");
    }
    
}




-(void) playAndLoopLoginVideo{

    NSString *resourceName = @"video.mov";
    NSString* movieFilePath = [[NSBundle mainBundle]
                               pathForResource:resourceName ofType:nil];
    videoURL = [NSURL fileURLWithPath:movieFilePath];
    
    AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
    queue = [[AVQueuePlayer alloc] initWithItems:@ [video]];
    video = [[AVPlayerItem alloc] initWithURL:videoURL];
    AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:queue];
    
    self.player = queue;
    self.showsPlaybackControls = FALSE;
    [self.player play];
    [queue insertItem:video afterItem:nil];
    
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {
                            AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
                            [queue insertItem:video afterItem:nil];
                        }];
    
//    if (self.player.status == AVPlayerStatusReadyToPlay) {
//        if([((AVPlayerLayer *)[self.videoContainer layer]).videoGravity isEqualToString:AVLayerVideoGravityResizeAspect])
//            ((AVPlayerLayer *)[self.videoContainer layer]).videoGravity = AVLayerVideoGravityResizeAspectFill;
//        else
//            ((AVPlayerLayer *)[self.videoContainer layer]).videoGravity = AVLayerVideoGravityResizeAspect;
//        
//        ((AVPlayerLayer *)[self.videoContainer layer]).bounds = ((AVPlayerLayer *)[self.videoContainer layer]).bounds;
//    }
//

}


- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginButton:didCompleteWithResult:error:) name: FBSDKAccessTokenDidChangeNotification object:nil];
        
        
        // ...
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      // ...
                                      NSLog(@"FireBaseLogged Initialize");
                                      
                                      FIRUser *userFace = [FIRAuth auth].currentUser;
                                      
                                      NSString* userFaceName;
                                      
                                      userFaceName = userFace.displayName;
                                      
                                      NSLog(@"%@", userFaceName);
                                      [self nextView];



                                  }];
        
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loginButtonClicked
//{
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login
//     logInWithReadPermissions: @[@"public_profile"]
//     fromViewController:self
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         if (error) {
//             NSLog(@"Process error");
//         } else if (result.isCancelled) {
//             NSLog(@"Cancelled");
//         } else {
//             NSLog(@"Logged in");
//         }
//     }];
//}

    
    
-(void) nextView{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        [self performSegueWithIdentifier:@"goHome" sender:self];
    }
    
}
    
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void) blurImage{
    
    //VisableRect = 100,100,200,200
    
    //Add a backgroun picture
    UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageV.image = [UIImage imageNamed:@"icoFormularioPrincipal@2x.png"];
    [self.view addSubview:imageV];
    
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _visualEffectView.frame = imageV.frame;
    _visualEffectView.alpha = 1.0;
    [self.view addSubview:_visualEffectView];
    
    //create path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:imageV.bounds];
//    UIBezierPath *otherPath = [[UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 200, 200)] bezierPathByReversingPath];
//    [maskPath appendPath:otherPath];
    
    //set mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    [_visualEffectView.layer setMask:maskLayer];
    
//    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, imageV.frame.size.height, 200, 20)];
//    _slider.minimumValue = 0;
//    _slider.maximumValue = 1;
//    _slider.value = 1;
//    [_slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_slider];
}

@end
