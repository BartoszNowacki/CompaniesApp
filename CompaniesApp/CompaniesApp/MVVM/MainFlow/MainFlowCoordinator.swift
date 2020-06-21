//
//  MainFlowCoordinator.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import UIKit

final class MainFlowCoordinator: FlowCoordinator {
    var rootNavigationController: UINavigationController?
    private var window: UIWindow?
    
    var currentViewController: UIViewController? {
        return UIApplication.shared.visibleViewController
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showMainView()
    }
    
    func stop() {
        FlowManager.shared.mainFlow = nil
    }
    
    private func showMainView() {
       }
}
