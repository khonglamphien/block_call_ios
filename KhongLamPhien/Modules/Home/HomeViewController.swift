//
//  HomeViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 09/12/2022.
//

import UIKit
import CallKit
import Contacts
import GoogleMobileAds

class HomeViewController: BaseViewController, GADBannerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    var dataSearch = [SearchModel]()
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObserver()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

        bannerView.adUnitID = "ca-app-pub-5451113167300018/8453727592"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    private func setupView() {
        tableView.registerCell(BlockTableViewCell.self)
        viewModel.searchAll(page: 1, limit: 20)
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
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
