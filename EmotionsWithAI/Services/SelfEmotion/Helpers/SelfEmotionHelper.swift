//
//  SelfEmotionHelper.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation
import ZIPFoundation

struct SelfEmotionHelper {
    static func convertSelfUserEntityToSelfUser(_ selfUserEntity: SelfUserEntity) -> SelfUser {
        return SelfUser(
            id: selfUserEntity.id,
            chartDatas: Self.getChartDatas(from: selfUserEntity),
            mostEmotionLabel: Self.getMostEmotionLabel(from: selfUserEntity),
            analysisDates: selfUserEntity.analysisDates,
            countOfMessages: Self.getCountOfMessages(from: selfUserEntity)
        )
    }
    
    private static func getChartDatas(from selfUserEntity: SelfUserEntity) -> [ChartData] {
        //MARK: - TODO
        return []
    }
    
    private static func getMostEmotionLabel(from selfUserEntity: SelfUserEntity) -> SentimentLabel {
        //MARK: - TODO
        return .joy
    }
    
    private static func getCountOfMessages(from selfUserEntity: SelfUserEntity) -> Int {
        //MARK: - TODO
        return 0
    }
}


struct WPMessageHelper {
    static func getStringFormat(from fileURL: URL) throws -> String {
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("ExtractedZip")

        // Remove the extraction folder if it already exists
        try? FileManager.default.removeItem(at: destinationURL)

        // Extract the ZIP file to the destination directory
        try FileManager.default.unzipItem(at: fileURL, to: destinationURL)

        // Look for the first .txt file inside the extracted content
        let txtFiles = try FileManager.default.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "txt" }

        guard let txtFileURL = txtFiles.first else {
            throw NSError(
                domain: "ZipMessageParser",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "No .txt file found in the ZIP archive."]
            )
        }

        // Read the content of the .txt file
        let content = try String(contentsOf: txtFileURL, encoding: .utf8)
        return content
    }
    
    static func extractParticipants(from rawText: String) -> [String] {
        let lines = rawText.components(separatedBy: .newlines)
        var participants = Set<String>()
        
        for line in lines {
            // Skip lines without sender format
            guard let dateEndIndex = line.firstIndex(of: "]") else { continue }
            let messageBody = line[line.index(after: dateEndIndex)...].trimmingCharacters(in: .whitespaces)
            
            // Format: "Sender Name: message text"
            if let senderSeparator = messageBody.firstIndex(of: ":") {
                let sender = String(messageBody[..<senderSeparator]).trimmingCharacters(in: .whitespaces)
                if !sender.isEmpty {
                    participants.insert(sender)
                }
            }
        }
        
        return Array(participants).sorted()
    }
    
    static func filterMessages(after cutoffDate: Date, from rawText: String) -> String {
        let lines = rawText.components(separatedBy: .newlines)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        
        var filteredLines: [String] = []
        
        for line in lines {
            // Extract timestamp from "[...]" part
            guard let start = line.firstIndex(of: "["),
                  let end = line.firstIndex(of: "]") else {
                continue
            }

            let dateString = String(line[line.index(after: start)..<end]) // e.g. "14.03.2025, 00:46:54"
            
            if let date = formatter.date(from: dateString), date >= cutoffDate {
                filteredLines.append(line)
            }
        }
        
        return filteredLines.joined(separator: "\n")
    }

}


