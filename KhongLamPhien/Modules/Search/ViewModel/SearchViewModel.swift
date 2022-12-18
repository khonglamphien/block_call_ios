//
//  SearchViewModel.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 14/12/2022.
//

import UIKit

class SearchViewModel: BaseViewModel {
    
    var searchApiResponse = PublishSubject<SearchResponse>()
    var searchAllApiResponse = PublishSubject<SearchResponse>()
    var reportApiResponse = PublishSubject<SearchResponse>()

    func searchPhoneNumber(phoneNumber: String, page: Int, limit: Int) {
        let apiName = ApiName.searchApi
        firstly { () -> Promise<SearchResponse> in
            return ApiClient.shared.callApi(SearchApi.search(phoneNumber: phoneNumber, page: page, limit: limit))
        }.done { [weak self] (response) in
            self?.searchApiResponse.onNext(response)
            return
        }.catch { [weak self] (_) in
            self?.responseSubject.onNext((api: apiName,
                                          isRequestSuccess: false,
                                          message: "unknowError"))

        }
    }
    
    func searchAll(page: Int, limit: Int) {
        let apiName = ApiName.searchAllApi
        firstly { () -> Promise<SearchResponse> in
            return ApiClient.shared.callApi(SearchApi.searchAll(page: page, limit: limit))
        }.done { [weak self] (response) in
            self?.searchAllApiResponse.onNext(response)
            return
        }.catch { [weak self] (_) in
            self?.responseSubject.onNext((api: apiName,
                                          isRequestSuccess: false,
                                          message: "unknowError"))

        }
    }
    
    func report(phoneNumber: String) {
        let apiName = ApiName.reportApi
        firstly { () -> Promise<SearchResponse> in
            return ApiClient.shared.callApi(SearchApi.report(phoneNumber: phoneNumber))
        }.done { [weak self] (response) in
            self?.reportApiResponse.onNext(response)
            return
        }.catch { [weak self] (_) in
            self?.responseSubject.onNext((api: apiName,
                                          isRequestSuccess: false,
                                          message: "unknowError"))

        }
    }
    
}

extension SearchViewModel {
        
    struct ApiName {
        static let searchApi = "searchApi"
        static let searchAllApi = "searchAllApi"
        static let reportApi = "reportApi"
    }
        
}
