//
//  main.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//
import UIKit

let appDelegateClass: AnyClass =
    NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass)
)
