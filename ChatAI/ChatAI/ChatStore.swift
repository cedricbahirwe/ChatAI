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
        DispatchQueue.main.async {
            self.isAnswering = true
            self.messages.append(self.editedMessage)
            self.editedMessage = Message()
        }
        do {
            let result = try await openAPI.sendCompletion(
                with: editedMessage.message,
                maxTokens: 100)
            print("Res", result)
            DispatchQueue.main.async {
                self.updateUI(result)
            }
        } catch {
            isAnswering = false
            print(error.localizedDescription)
        }
    }

    private func updateUI(_ result: OpenAI) {
        var content = result.choices.map(\.text).joined()
        content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let newMessage = Message(content, isSender: false)

        self.messages.append(newMessage)
        isAnswering = false
    }
}
