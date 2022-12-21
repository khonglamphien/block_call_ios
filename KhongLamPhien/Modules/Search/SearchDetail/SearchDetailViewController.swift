//
//  SearchDetailViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 15/12/2022.
//

import UIKit
import PopupDialog

class SearchDetailViewController: BaseViewController {
    
    struct DataShowDetail {
        var title = ""
        var content = ""
        
        init(_ title: String, _ content: String) {
            self.title = title
            self.content = content
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSearchDetail: SearchModel?
    var dataShowDetail = [[DataShowDetail]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        tableView.registerCell(SearchDetailTableViewCell.self)
        guard let data = dataSearchDetail else {
            return
        }
        dataShowDetail = [[DataShowDetail("Số thuê bao", data.phoneNumber), DataShowDetail("Tìm kiếm", data.countSearch), DataShowDetail("Hậu thuẫn", data.backerBy), DataShowDetail("Mô tả", data.phoneDesription)], [DataShowDetail("Nhà cung cấp", data.supplier), DataShowDetail("Tên doanh nghiệp", data.nameBusiness), DataShowDetail("Ngành công nghiệp", data.industry), DataShowDetail("Địa chỉ", data.address)], [DataShowDetail("", "")]]
    }
    
    @IBAction func onSelectBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSelectReportButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupUnblockViewController").viewController(of: PopupUnblockViewController.self)
        alertViewController.numberBlock = dataSearchDetail?.phoneNumber ?? ""
        alertViewController.typeScreen = .report
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
    @IBAction func onSelectBlockButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupUnblockViewController").viewController(of: PopupUnblockViewController.self)
        alertViewController.listBlock = getBlockedContacts()
        alertViewController.numberBlock = dataSearchDetail?.phoneNumber ?? ""
        alertViewController.typeScreen = .block
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
    func getBlockedContacts() -> [String] {
        let defaults = UserDefaults(suiteName: "group.bcs.kuhb")
        let blockedContacts = defaults?.value(forKey: "blockList") ?? []
        return blockedContacts as! [String]
    }
    
}

extension SearchDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 4
            case 1:
                return 4
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: SearchDetailTableViewCell.self, forIndexPath: indexPath)
        cell.titleLabel.text = dataShowDetail[indexPath.section][indexPath.row].title
        cell.contentLabel.text = dataShowDetail[indexPath.section][indexPath.row].content.isEmpty ? "Đang cập nhật" : dataShowDetail[indexPath.section][indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Thông tin cơ bản"
            case 1:
                return "Thông tin chi tiết"
            default:
                return "Mô tả chi tiết"
        }
    }
    
}
