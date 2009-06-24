#import "BankViewRENAME.h"
#import "BankViewController.h"
#import "S1AppDelegate.h"


@implementation BankViewRENAME

- (void)viewDidAppear:(BOOL)animated  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	BankViewController * bankView = [app mainBankViewController];
	[bankView UpdateView];
}

@end
