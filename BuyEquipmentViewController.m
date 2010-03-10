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

#import "BuyEquipmentViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation BuyEquipmentViewController

- (void)awakeFromNib
{
	self.title = @"Buy Equipment";	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Buy Equipment";				
	}
	return self;
}

-(void)updateButtonAndLabels:(int)index button:(UIButton*)button labelName:(UILabel*)labelName labelPrice:(UILabel*)labelPrice
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	labelName.text = [app.gamePlayer getEquipmentName:index];
	if ([app.gamePlayer getEquipmentPrice:index] > 0) 
	{
		[self.view addSubview:button];
		labelPrice.text = [NSString stringWithFormat:@"%i cr.", [app.gamePlayer getEquipmentPrice:index]];
	}
	else {
		[button removeFromSuperview];
		labelPrice.text = @"not sold";
	}
}



-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[self updateButtonAndLabels:0 button:buy0 labelName:equipmentName0 labelPrice:equipmentPrice0];
	[self updateButtonAndLabels:1 button:buy1 labelName:equipmentName1 labelPrice:equipmentPrice1];
	[self updateButtonAndLabels:2 button:buy2 labelName:equipmentName2 labelPrice:equipmentPrice2];
	[self updateButtonAndLabels:3 button:buy3 labelName:equipmentName3 labelPrice:equipmentPrice3];
	[self updateButtonAndLabels:4 button:buy4 labelName:equipmentName4 labelPrice:equipmentPrice4];
	[self updateButtonAndLabels:5 button:buy5 labelName:equipmentName5 labelPrice:equipmentPrice5];
	[self updateButtonAndLabels:6 button:buy6 labelName:equipmentName6 labelPrice:equipmentPrice6];	
	[self updateButtonAndLabels:7 button:buy7 labelName:equipmentName7 labelPrice:equipmentPrice7];
	[self updateButtonAndLabels:8 button:buy8 labelName:equipmentName8 labelPrice:equipmentPrice8];
	[self updateButtonAndLabels:9 button:buy9 labelName:equipmentName9 labelPrice:equipmentPrice9];
	
	cash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits];	
}

-(void)buyStuff:(int)index
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer buyItem:index controller:self];
	[self UpdateView];
}

- (void)loadView
{
	[super loadView];
	[self UpdateView];
}

-(IBAction) pressBuy0;
{
	[self buyStuff:0];
}

-(IBAction) pressBuy1
{
	[self buyStuff:1];	
}

-(IBAction) pressBuy2
{
	[self buyStuff:2];	
}

-(IBAction) pressBuy3
{
	[self buyStuff:3];	
}

-(IBAction) pressBuy4
{
	[self buyStuff:4];	
}

-(IBAction) pressBuy5
{
	[self buyStuff:5];	
}

-(IBAction) pressBuy6
{
	[self buyStuff:6];	
}

-(IBAction) pressBuy7
{
	[self buyStuff:7];	
}

-(IBAction) pressBuy8
{
	[self buyStuff:8];	
}

-(IBAction) pressBuy9
{
	[self buyStuff:9];	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self UpdateView];
}

@end
