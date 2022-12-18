//
//  BaseViewModel.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 08/12/2022.
//

import UIKit

// API Name, such as login, register ...
typealias ApiName = String

// Response Subject
typealias ApiResponseSubject = (api: ApiName, isRequestSuccess: Bool, message: String?)

class BaseViewModel: NSObject {

    let disposeBag = DisposeBag()
    
    var message = PublishSubject<String>()
    var responseSubject = PublishSubject<ApiResponseSubject>()
    var isShowLoading = PublishSubject<Bool>()
    
}
