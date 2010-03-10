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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PricesView : UIView<UIAlertViewDelegate> {
	IBOutlet UILabel * water;
	IBOutlet UILabel * furs;
	IBOutlet UILabel * food;
	IBOutlet UILabel * ore;	
	IBOutlet UILabel * games;
	IBOutlet UILabel * firearms;
	IBOutlet UILabel * medicine;
	IBOutlet UILabel * machines;
	IBOutlet UILabel * narcotics;	
	IBOutlet UILabel * robots;
	IBOutlet UILabel * bays;
	IBOutlet UILabel * name;	
	IBOutlet UILabel * resources;	
	IBOutlet UIButton * absolutePricesButton;		
	bool absolutePrices;
	IBOutlet UILabel * cash;
	int itemsPrice[10];
	int itemsMax[10];
	
	int activeTradeItem;
}

-(IBAction) buyWater;
-(IBAction) buyFurs;
-(IBAction) buyFood;
-(IBAction) buyOre;
-(IBAction) buyGames;
-(IBAction) buyFirearms;
-(IBAction) buyMedicine;
-(IBAction) buyMachines;
-(IBAction) buyNarcotics;
-(IBAction) buyRobots;
-(IBAction) showAbsolutePrices;

-(void)UpdateWindow;


@end
