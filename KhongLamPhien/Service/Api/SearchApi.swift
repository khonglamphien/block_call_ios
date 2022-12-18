//
//  SearchApi.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 14/12/2022.
//

import Foundation

public enum SearchApi {
    case search(phoneNumber: String, page: Int, limit: Int)
    case searchAll(page: Int, limit: Int)
    case report(phoneNumber: String)
}

extension SearchApi: TargetType {
    public var baseURL: URL {
        return URL(string: "https://backend.wecheck999.com/api")!
    }
    
    public var path: String {
        switch self {
        case .search(let phoneNumber, _, _):
            return "/v1/phonesearch/search/\(phoneNumber)"
        case .searchAll:
            return "/v1/phonesearch"
            case .report:
                return "/v1/phonechart/createReport"
        }
    }
 
    public var method: Moya.Method {
        switch self {
        case .search, .searchAll:
            return .get
            case .report:
                return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .search(_, let page, let limit):
            let params = [
                "page": page,
                "limit": limit
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .searchAll( let page, let limit):
            let params = [
                "page": page,
                "limit": limit
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .report(let phoneNumber):
                let params: [String: Any] = [
                    "phoneNumber": phoneNumber,
                    "countScam": 1,
                    "countBother": 1,
                    "countAgency": 1,
                    "countDues": 1,
                    "countSpam": 1
                ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    public var headers: [String: String]? {
        let token = ""
        return ["Authorization": "Bearer " + token]
    }
}
