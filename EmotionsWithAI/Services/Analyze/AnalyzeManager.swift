//
//  AnalyzeManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 12.06.2025.
//

import Foundation
import MBWebService

@MainActor
final class AnalyzeManager {
    
    private let webService: MBWebServiceProtocol
    private let userManager: UserManager
    init(webService: MBWebServiceProtocol, userManager: UserManager) {
        self.webService = webService
        self.userManager = userManager
    }
    
    func analyzeWhatsappChat(text: String) async throws -> WhatsappAnalysisResponseModel {
        let wpRequest: WhatsappTextRequestModel = .init(text: text)
        let textData = try JSONEncoder().encode(wpRequest)
        let data =  try await webService.fethcData(
            urlString: "http://127.0.0.1:8000/api/v1/analyze/whatsapp",
            queryItems: nil,
            header: .defaultHttpHeader,
            method: .POST,
            body: textData,
            checkStatusCode: false,
            timeoutInterval: 120
        )
        let decoder = JSONDecoder()

        let _ = DateFormatter()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(ApiResponseModel<WhatsappAnalysisResponseModel>.self, from: data)
        if response.success {
            try userManager.increaseRequestCount()
            guard let data = response.data else {
                throw GenericError.detail("Couldn't find data on \(#function)")
            }
            return data
        }else {
            throw GenericError.detail("Response failed \(#function)")
        }
        
        
    }
    
    func getMaxInputSize() async throws -> Int {
        
        let data = try await webService.fethcData(
            urlString: "http://127.0.0.1:8000/api/v1/model/max-input-size",
            queryItems: nil,
            header: .defaultHttpHeader,
            method: .GET,
            body: nil,
            checkStatusCode: false,
            timeoutInterval: 60
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(ApiResponseModel<MaxInputSizeData>.self, from: data)
        
        if decoded.success {
            guard let data = decoded.data else {
                throw URLError(.badServerResponse)
            }
            return Int(data.approx_size_kb)
        }else {
            throw GenericError.detail(decoded.error?.message ?? "\(#function) error")
        }
    }
    
    func analyzeOneTime(text: String) async throws -> Emotion {
        let oneTimeRequest: OneTimeTextRequestModel = .init(text: text)
        let textData = try JSONEncoder().encode(oneTimeRequest)
        let data = try await webService.fethcData(
            urlString: "http://127.0.0.1:8000/api/v1/analyze/one-time",
            queryItems: nil,
            header: .defaultHttpHeader,
            method: .POST,
            body: textData,
            checkStatusCode: false,
            timeoutInterval: 60
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(ApiResponseModel<EmotionModel>.self, from: data)
        
       
        if decoded.success {
            guard let data = decoded.data else {
                throw GenericError.detail("Couldn't find data on \(#function)")
            }
            return data.convertToEmotion()
        }else {
            throw GenericError.detail("Response failed \(#function)")
        }
    }

}


