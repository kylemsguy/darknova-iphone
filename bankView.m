#import "bankView.h"
#import "bankViewController.h"
#import "S1AppDelegate.h"


@implementation bankView

- (void)viewDidAppear:(BOOL)animated  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	bankViewController * bankView = [app mainBankViewController];
	[bankView UpdateView];
}

@end
