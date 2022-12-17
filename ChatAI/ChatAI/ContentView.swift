//
//  ContentView.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    @State private var messages = [Message]()
    @State private var editedMessage = Message("", isSender: true)
    @State private var isAnswering = false
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            ForEach(messages) { message in
                MessageBubble(message: message)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.85), ignoresSafeAreaEdges: .all)
        .background { emptyView }
        .safeAreaInset(edge: .bottom,
                       alignment: .center,
                       spacing: 15) {
            inputField
                .preferredColorScheme(.dark)
        }
    }

    private func performSearch() async {
        guard !editedMessage.message.isEmpty else { return }
        guard let openAPIKey = ProcessInfo.processInfo.environment["apiKey"] else { fatalError() }
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

    var emptyView: some View {
        Group {
            if messages.isEmpty {
                Text("Nothing here like your crush chat!")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fixedSize()
            }
        }
    }

    var inputField: some View {
        HStack {
            TextField.init("Enter your prompt",
                           text: $editedMessage.message)
            .submitLabel(.go)
            .onSubmit {
                Task { await performSearch() }
            }
            Spacer()
            Button {
                Task { await performSearch() }
            } label: {
                Group {
                    if isAnswering {
                        ProgressView.init()
                            .progressViewStyle(.circular)
                    } else {
                        Image(systemName: "paperplane")
                            .symbolRenderingMode(.hierarchical)
                            .resizable()
                            .symbolVariant(.fill)
                    }
                }
                .tint(.white)
                .scaledToFit()
                .padding(10)
                .frame(width: 40)
                .background(.blue)
                .clipShape(Circle())
                .disabled(isAnswering)
            }
        }
        .padding()
        .background(.regularMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice.init(rawValue: "iPhone 12"))
    }
}
