//
//  FlowCoordinator.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 20/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

protocol FlowCoordinator: class {
    var rootNavigationController: UINavigationController? { get }
    func start()
    func stop()
}

final class FlowManager: Coordinator {
    
    static let shared = FlowManager(window: UIWindow(frame: UIScreen.main.bounds))
    
    private let window: UIWindow
    
    var mainFlow: FlowCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startMainFlow()
    }
    
    func startMainFlow() {
        mainFlow = MainFlowCoordinator(window: window)
        mainFlow?.start()
    }
}
