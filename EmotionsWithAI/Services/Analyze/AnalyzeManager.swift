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
    
    init(webService: MBWebServiceProtocol) {
        self.webService = webService
    }
    
    func analyzeWhatsappChat(text: String) async throws -> ApiResponseModel<WhatsappAnalysisResponseModel> {
        let defaultHttpHeader = HttpHeader(
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        )
        let wpRequest: WhatsappTextRequest = .init(text: text)
        let textData = try JSONEncoder().encode(wpRequest)
        let data =  try await webService.fethcData(
            urlString: "http://127.0.0.1:8000/api/v1/analyze/whatsapp",
            queryItems: nil,
            header: defaultHttpHeader,
            method: .POST,
            body: textData,
            checkStatusCode: false
        )
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Zaman dilimi yok
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .iso8601
        
        
        
        let returnData = try decoder.decode(ApiResponseModel<WhatsappAnalysisResponseModel>.self, from: data)
        return returnData
    }

}
