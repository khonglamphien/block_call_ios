//
//  ApiResponse.swift
//
//  Created by Nguyen Anh on 14/07/2021.
//

import Foundation
import SwiftyJSON
import Moya

public class ApiResponse {
    
    let error: NSError?
    let jsonData: JSON?
    let statusCode: Int?
    let status: Int?
    let message: String?
    
    var isSuccess: Bool {
        return status == 200
    }
    
    required init(response: Response) {
        // Success case
        statusCode = response.statusCode
        let json = JSON(response.data)
        print("===", json)
        status = json["status"].intValue
        message = json["message"].stringValue
        //Session.shared.accessToken = json["id_token"].stringValue
        let code = json["code"].stringValue
        if response.isSuccess {
            if status == 200 && code == "00" {
                 self.error = nil
            } else {
                let code = json["status"].intValue
                self.error = NSError(
                    domain: ServiceHelper.errorServiceDomain,
                    code: code,
                    userInfo: [NSLocalizedDescriptionKey: message ?? "error"])
            }
            let jsonData = json
            if jsonData.exists() {
                self.jsonData = jsonData
                self.parsingData(json: jsonData)
            } else {
                self.jsonData = json
            }
            return
        }
        
        // Error cases
        if response.isUnauthenticated || code == "SESSION_TIMEOUT" {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: ServiceHelper.errorCodeUnauthorized,
                userInfo: [NSLocalizedDescriptionKey: "sectionTimeout"])
            self.jsonData = nil
//            if let token = Session.shared.accessToken, !token.isEmpty {
//                AlertManager.shared.showAlertDefault("", message: "Phiên đăng nhập hết hạn", buttons: ["OK"], completed: {_ in
//                    Session.shared.logout()
//                })
//            }
            return
        } else if response.isGatewayTimeOut {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: ServiceHelper.errorCodeGatewayTimeOut,
                userInfo: [NSLocalizedDescriptionKey: "connectionError"])
            self.jsonData = nil
            return
        }
        
        let messageJson = JSON(response.data)["message"]
        if messageJson.exists() {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: response.statusCode,
                userInfo: [NSLocalizedDescriptionKey: messageJson.stringValue])
            self.jsonData = nil
            return
        } else {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: response.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "unknowError"])
            self.jsonData = nil
        }
    }
    
    required init(error: Error) {
        let nsError = error as NSError
        
        self.error = NSError(
            domain: nsError.domain,
            code: nsError.code,
            userInfo: [NSLocalizedDescriptionKey: nsError.localizedDescription])
        self.jsonData = nil
        self.status = nil
        self.statusCode = nsError.code
        self.message = nsError.localizedDescription
    }
    
    // Override to parsing data
    func parsingData(json: JSON) {
        
    }
    
}
