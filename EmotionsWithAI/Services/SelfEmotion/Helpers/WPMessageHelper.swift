//
//  WPMessageHelper.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation
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
    
    static func filterMessages(after cutoffDate: Date?, from rawText: String) -> String {
        let lines = rawText.components(separatedBy: .newlines)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        
        var filteredLines: [String] = []
        
        for line in lines {
            // Tarih etiketi yoksa doğrudan ekle (veya cutoffDate nil ise)
            guard let start = line.firstIndex(of: "["),
                  let end = line.firstIndex(of: "]") else {
                if cutoffDate == nil {
                    filteredLines.append(line)
                }
                continue
            }

            let dateString = String(line[line.index(after: start)..<end])
            
            // Tarih ayrıştırılamıyorsa, cutoffDate nil ise yine dahil et
            if let date = formatter.date(from: dateString) {
                if let cutoff = cutoffDate {
                    if date > cutoff {
                        filteredLines.append(line)
                    }
                } else {
                    filteredLines.append(line)
                }
            } else if cutoffDate == nil {
                filteredLines.append(line)
            }
        }
        
        return filteredLines.joined(separator: "\n")
    }

    
    static func compareDateString(with dateString: String, referenceDate: Date) -> Bool? {
        // Giriş formatını tanımla: "[DD.MM.YYYY, HH:mm:ss]"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "[dd.MM.yyyy, HH:mm:ss]"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(identifier: "Europe/Istanbul") // Türkiye zaman dilimi (+03:00)

        // String'i Date'e çevir
        guard let parsedDate = inputFormatter.date(from: dateString) else {
            print("Hatalı tarih formatı: \(dateString)")
            return nil
        }

        // Karşılaştırma: parsedDate > referenceDate
        let isAfter = parsedDate > referenceDate
        print("Parsed Date (\(parsedDate)): \(parsedDate.timeIntervalSinceReferenceDate)")
        print("Reference Date (\(referenceDate)): \(referenceDate.timeIntervalSinceReferenceDate)")
        print("Is \(parsedDate) after \(referenceDate)? \(isAfter)")
        
        return isAfter
    }

}
