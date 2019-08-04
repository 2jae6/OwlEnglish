import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let type, service, version: String
    let result: Result
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case service = "@service"
        case version = "@version"
        case result
    }
}

// MARK: - Result
struct Result: Codable {
    let translatedText, srcLangType: String
}
