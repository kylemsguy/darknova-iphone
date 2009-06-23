#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "retireShipDestroyedView.h"
#import "poorEndGameView.h"
#import "happyEndView.h"


@interface EndOfGameViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet retireShipDestroyedView * shipDestroyedView;
	IBOutlet happyEndView* shipHappyEndView;
	IBOutlet poorEndGameView * shipPoorEndGameView;
	IBOutlet retireShipDestroyedView * shipDestroyedWithPodView;	
}

-(void)showShipDestroyedImage;
-(void)showPoorEndGameImage;
-(void)showHappyEndImage;

-(IBAction) startNewGame;
@end
