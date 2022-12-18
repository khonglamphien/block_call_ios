//
//  SearchModel.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 15/12/2022.
//

import Foundation

struct SearchModel {

    let id: String
    let phoneNumber: String
    let phoneDesription: String
    let originImage: String
    let backerBy: String
    let phoneLongDesription: String
    let supplier: String
    let websiteUrl: String
    let taxCode: String
    let address: String
    let countSearch: String
    let countAccess: String
    let nameBusiness: String
    let industry: String
    let contactInformation: String
    let isBlocked: Bool
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let __entity: String

    init(_ json: JSON) {
        id = json["id"].stringValue
        phoneNumber = json["phoneNumber"].stringValue
        phoneDesription = json["phoneDesription"].stringValue
        originImage = json["originImage"].stringValue
        backerBy = json["backerBy"].stringValue
        phoneLongDesription = json["phoneLongDesription"].stringValue
        supplier = json["supplier"].stringValue
        websiteUrl = json["websiteUrl"].stringValue
        taxCode = json["taxCode"].stringValue
        address = json["address"].stringValue
        countSearch = json["countSearch"].stringValue
        countAccess = json["countAccess"].stringValue
        nameBusiness = json["nameBusiness"].stringValue
        industry = json["industry"].stringValue
        contactInformation = json["contactInformation"].stringValue
        isBlocked = json["isBlocked"].boolValue
        isDeleted = json["isDeleted"].boolValue
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        deletedAt = json["deletedAt"].stringValue
        __entity = json["__entity"].stringValue
    }

}
