import Foundation

struct Question: Identifiable, Decodable {
    let id: Int
    let questionText: String
    let infoMarkdown: String
    let options: [String]
    let correctIndex: Int
    let helpPromptMarkdown: String
}
