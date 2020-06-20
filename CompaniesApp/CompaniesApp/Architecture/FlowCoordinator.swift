//
//  FlowCoordinator.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 20/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import UIKit

protocol FlowCoordinator: class {
    var navigationController: UINavigationController { get }
    func start()
    func stop()
}

final class FlowManager {
    static let shared = FlowManager()
    
    var mainFlow: FlowCoordinator?
    var companiesFlow: FlowCoordinator?
}
