//
//  ChatStore.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import Foundation
import OpenAISwift

final class ChatStore: ObservableObject {
    @Published var editedMessage = Message("", isSender: true)
    @Published private(set) var isAnswering = false
    @Published private(set) var messages = [Message]()


    func performSearch() async {
        guard !editedMessage.message.isEmpty else { return }
        let openAPIKey = Constant.apiKey
        let openAPI = OpenAISwift(authToken: openAPIKey)
        isAnswering = true
        messages.append(editedMessage)
        editedMessage = Message()

        do {
            let result = try await openAPI.sendCompletion(
                with: editedMessage.message,
                maxTokens: 100)
            print("Res", result)
            var content = result.choices.map(\.text).joined()
            content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            let newMessage = Message(content, isSender: false)
            messages.append(newMessage)
            isAnswering = false
        } catch {
            isAnswering = false
            print(error.localizedDescription)
        }
    }

}
