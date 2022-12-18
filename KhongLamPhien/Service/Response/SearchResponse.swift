//
//  SearchResponse.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 14/12/2022.
//

import UIKit

class SearchResponse: ApiResponse {

    var data = [SearchModel]()
    
    override func parsingData(json: JSON) {
        super.parsingData(json: json)
        data = json["data"].arrayValue.map({ SearchModel($0) })
    }
    
}
