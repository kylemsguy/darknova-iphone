#import "endOfGameViewController.h"
#import "S1AppDelegate.h"
#import "startGameViewController.h"
#import "highScoresViewController.h"

@implementation endOfGameViewController


-(void)showShipDestroyedImage
{
	self.view = shipDestroyedView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (app.gamePlayer.escapePod)
		self.view = shipDestroyedWithPodView;

	[app.gamePlayer playSound:eYouLose];		
	[app.gamePlayer eraseAutoSave];
}

-(void)showPoorEndGameImage
{
	self.view = shipPoorEndGameView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer playSound:eYouRetirePoorly];	
	[app.gamePlayer eraseAutoSave];	
}

-(void)showHappyEndImage
{
	self.view = shipHappyEndView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer playSound:eYouRetirelavishly];
	[app.gamePlayer eraseAutoSave];	
}


-(IBAction) startNewGame
{
	[self.view removeFromSuperview];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int status;
	if (self.view == shipDestroyedView)
		status = 0;
	else
	if (self.view == shipPoorEndGameView)
		status = 1;
	else
		status = 2;
	
	bool highScore = [app.gamePlayer EndOfGame:status];
	[app showStartGame];

	if (highScore) {
		UIViewController* highScores = [[highScoresViewController alloc] initWithNibName:@"highScores" bundle:nil];;
		[app.navigationController pushViewController:highScores animated:TRUE];
		
	}
}

@end
