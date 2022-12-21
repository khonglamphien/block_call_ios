//
//  SearchViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 14/12/2022.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var numberPhoneTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    var dataSearch = [SearchModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        setupView()
    }
    
    private func setupView() {
        tableView.registerCell(BlockTableViewCell.self)
    }
    
    @IBAction func onSelectSearchButton(_ sender: Any) {
        guard let phoneNumber = numberPhoneTF.text else {
            return
        }
        viewModel.searchPhoneNumber(phoneNumber: phoneNumber, page: 1, limit: 10)
    }

}

extension SearchViewController {
    
    func addObserver() {
        viewModel.searchApiResponse.subscribe(onNext: {[weak self] (response) in
            guard let self = self else { return }
            self.dataSearch = response.data
            self.tableView.reloadData()
            self.tableView.isHidden = response.data.isEmpty
        }).disposed(by: disposeBag)
        
        viewModel.responseSubject.subscribe(onNext: { (message) in
//            AlertManager.shared.showAlertDefault("", message: message.message, buttons: ["OK"], completed: nil)
//            Utils.hideLoadingIndicator()
        }).disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
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
