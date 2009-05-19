#import "helloViewController.h"

@implementation helloViewController
- (IBAction)helpGame {
 [self.tabBarController dismissModalViewControllerAnimated:YES];        
}

- (IBAction)loadGame {
 [self.tabBarController dismissModalViewControllerAnimated:YES];        
}

- (IBAction)newGame {
 [self.tabBarController dismissModalViewControllerAnimated:YES];        
}
@end
