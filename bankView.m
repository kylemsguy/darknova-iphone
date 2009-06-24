#import "bankView.h"
#import "BankViewControllerRENAME.h"
#import "S1AppDelegate.h"


@implementation bankView

- (void)viewDidAppear:(BOOL)animated  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	BankViewControllerRENAME * bankView = [app mainBankViewController];
	[bankView UpdateView];
}

@end
