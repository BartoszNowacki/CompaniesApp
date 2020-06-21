//
//  ViewController.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 19/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RxSwift

class CompaniesVC: UIViewController, INavigatedInstantiate {
    
    // MARK: STATIC
    
    static var navigationControllerIdentifier = "CompaniesNC"
    static var storyboardName = "Main"
    static var viewControllerIdentifier = "CompaniesVC"
    
    // MARK: OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: CompaniesViewModelProtocol?
    
    static func instantiateWithNav(viewModel: CompaniesViewModelProtocol = CompaniesViewModel()) -> (UINavigationController, CompaniesVC) {
        let (nc, vc) = CompaniesVC.instantiateInNavigationController()
        vc.viewModel = viewModel
        return (nc, vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        setupTableView()
    }
    
    private func bindUI() {
        viewModel?.companies.asDriver(onErrorJustReturn: [Company]())
            .drive(onNext: { [weak self] _ in
                self?.updateTableView()
            }).disposed(by: disposeBag)
        
        viewModel?.errorMessage.asDriver()
            .drive(onNext: { [weak self] message in
                self?.display(message: message)
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.backgroundColor = .white
        tableView.refreshControl?.tintColor = .black
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Przeciągnij aby odświeżyć")
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshCoins),
            for: .valueChanged
        )
    }
    
    private func updateTableView() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    @objc private func refreshCoins() {
        viewModel?.getCompaniesList()
    }
}

extension CompaniesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.companiesCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableCell", for: indexPath)
        
        if let cell = cell as? CompanyTableCell {
            if let company = viewModel?.getCompany(row: indexPath.row) {
                cell.setup(with: company)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.onShowCompanyDetails?(indexPath.row)
    }
}


