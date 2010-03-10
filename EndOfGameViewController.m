/*
    Dark Nova © Copyright 2009 Dead Jim Studios
    This file is part of Dark Nova.

    Dark Nova is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Dark Nova is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dark Nova.  If not, see <http://www.gnu.org/licenses/>
*/

#import "EndOfGameViewController.h"
#import "S1AppDelegate.h"
#import "StartGameViewController.h"
#import "HighScoresViewController.h"

@implementation EndOfGameViewController


-(void)showShipDestroyedImage {
	self.view = shipDestroyedView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (app.gamePlayer.escapePod)
		self.view = shipDestroyedWithPodView;

	[app.gamePlayer playSound:eYouLose];		
	[app.gamePlayer eraseAutoSave];
}

-(void)showPoorEndGameImage {
	self.view = shipPoorEndGameView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer playSound:eYouRetirePoorly];	
	[app.gamePlayer eraseAutoSave];	
}

-(void)showHappyEndImage {
	self.view = shipHappyEndView;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer playSound:eYouRetirelavishly];
	[app.gamePlayer eraseAutoSave];	
}


-(IBAction) startNewGame {
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
		UIViewController* highScores = [[HighScoresViewController alloc] initWithNibName:@"highScores" bundle:nil];;
		[app.navigationController pushViewController:highScores animated:TRUE];
		[highScores release];
	}
}

@end
