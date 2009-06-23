#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RetireShipDestroyedViewRENAME.h"
#import "poorEndGameView.h"
#import "happyEndView.h"


@interface EndOfGameViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet RetireShipDestroyedViewRENAME * shipDestroyedView;
	IBOutlet happyEndView* shipHappyEndView;
	IBOutlet poorEndGameView * shipPoorEndGameView;
	IBOutlet RetireShipDestroyedViewRENAME * shipDestroyedWithPodView;	
}

-(void)showShipDestroyedImage;
-(void)showPoorEndGameImage;
-(void)showHappyEndImage;

-(IBAction) startNewGame;
@end
