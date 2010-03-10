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

#import "HelpViewController.h"

@implementation HelpViewController

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DNHELP" ofType:@"html"];  
	NSData *htmlData = [NSData dataWithContentsOfFile:filePath];  
	if (htmlData) {  
		[webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://noplacehere.com"]];  
	} 
}
@end
