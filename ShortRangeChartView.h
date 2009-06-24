#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShortRangeChartView : UIView/* Specify a superclass (eg: NSObject or NSView) */ {
	
	
	BOOL piecesOnTop;  // Keeps track of whether or not two or more pieces are on top of each other
	
	CGPoint startTouchPosition; 
	
	CGImageRef redDot;
	CGImageRef greenDot;
	CGImageRef blueDot;
	
	CGSize		redDotSize;
	CGSize		blueDotSize;
	CGSize		greenDotSize;

	CGImageRef background;
	CGSize		backgroundSize;
	
	
	int Index;
}

@end
