//
//  ViewController.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 19/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
        searchBar.delegate = self
        setupTableView()
    }
    
     // MARK: SETUP
    
    private func bindUI() {
        viewModel?.companies.asDriver(onErrorJustReturn: [Company]())
            .drive(onNext: { [weak self] _ in
                self?.updateTableView()
                self?.loadingIndicator.stopAnimating()
            }).disposed(by: disposeBag)
        
        viewModel?.errorMessage.asDriver()
            .drive(onNext: { [weak self] message in
                self?.display(message: message)
                self?.loadingIndicator.stopAnimating()
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }

    @objc private func refreshList() {
        viewModel?.getCompaniesList()
    }
}

extension CompaniesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.companiesCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableCell", for: indexPath)
        cell.selectionStyle = .none
        if let cell = cell as? CompanyTableCell {
            if let company = viewModel?.getCompany(row: indexPath.row) {
                cell.setup(with: company)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let company = viewModel?.getCompany(row: indexPath.row) {
            viewModel?.onShowCompanyDetails?(company.id)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dataCount = viewModel?.companiesCount, indexPath.row == dataCount - 1 {
            refreshList()
        }
    }
}

extension CompaniesVC: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            loadingIndicator.startAnimating()
            viewModel?.getSearchedCompaniesList(for: text)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}


