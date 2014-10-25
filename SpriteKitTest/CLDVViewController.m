//
//  CLDVViewController.m
//  MyGame1
//
//  Created by Jean-Luc on 24/02/2014.
//  Copyright (c) 2014 Celedev. All rights reserved.
//

#import "CLDVViewController.h"

#import "CIMLua/CIMLua.h"
#import "CIMLua/CIMLuaContextMonitor.h"

@interface CLDVViewController ()
{
    CIMLuaContext* _luaContext;
    CIMLuaContextMonitor* _contextMonitor;
}

@end

@implementation CLDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Create the Lua context for the SKScene
    _luaContext = [[CIMLuaContext alloc] initWithName:@"SKGame"];
    _contextMonitor = [[CIMLuaContextMonitor alloc] initWithLuaContext:_luaContext connectionTimeout:5.0];
    
    // Set this controller as global in the Lua Context
    _luaContext [@"skViewController"] = self;
    
    // Execute a Lua module to run the game
    [_luaContext loadLuaModuleNamed:@"CreateGame" withCompletionBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
