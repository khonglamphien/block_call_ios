//
//  HomeViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 09/12/2022.
//

import UIKit
import CallKit
import Contacts

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    var dataSearch = [SearchModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObserver()
    }
    
    private func setupView() {
        tableView.registerCell(BlockTableViewCell.self)
        viewModel.searchAll(page: 1, limit: 20)
    }

}

extension HomeViewController {
    
    func addObserver() {
        viewModel.searchAllApiResponse.subscribe(onNext: {[weak self] (response) in
            guard let self = self else { return }
            self.dataSearch = response.data
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.responseSubject.subscribe(onNext: { (message) in
//            AlertManager.shared.showAlertDefault("", message: message.message, buttons: ["OK"], completed: nil)
//            Utils.hideLoadingIndicator()
        }).disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: BlockTableViewCell.self, forIndexPath: indexPath)
        let data = dataSearch[indexPath.row]
        cell.phoneNumberLabel.text = data.phoneNumber
        cell.nameLabel.text = ""
        cell.imageRight.image = UIImage(named: "next_icon")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDetaiVC = UIStoryboard.storyBoard("SearchDetailViewController").viewController(of: SearchDetailViewController.self)
        searchDetaiVC.dataSearchDetail = dataSearch[indexPath.row]
        navigationController?.pushViewController(searchDetaiVC, animated: true)
    }
    
}
