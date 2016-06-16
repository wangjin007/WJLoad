//
//  ViewController.m
//  WJLoading1.0
//
//  Created by wangjin on 16/6/16.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "ViewController.h"
#import "WJLoadingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    /**
     *  show loading default we add it on keyWidow
     */
    
    [WJLoadingView showLoading];
    
    /**
     *  we can set center's image color and line's width
     */
    
    //[WJLoadingView setColor:[UIColor blueColor] andWidth:2.0 andImage:[UIImage imageNamed:@"loading"]];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    /**
     *  This,we hide loading View
     */
    if (![WJLoadingView hideLoading]) {
        
        [WJLoadingView showLoading];
    };

}


@end
