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
        let viewModel = CompaniesViewModel()
        viewModel.onShowCompanyDetails = { [weak self] companyID in
            self?.showDetailsView(with: companyID)
        }
        let (nc, _) = CompaniesVC.instantiateWithNav(viewModel: viewModel)
        self.rootNavigationController = nc
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
    
    private func showDetailsView(with companyID: Int) {
        let viewModel = CompanyDetailsViewModel(companyID: companyID)
        viewModel.onError = { [weak self] message in
            self?.currentViewController?.dismiss(animated: true) {
                self?.currentViewController?.display(message: message)
            }
        }
        let vc = CompanyDetailsVC.instantiate(viewModel: viewModel)
        self.rootNavigationController?.pushViewController(vc, animated: true)
    }
}
