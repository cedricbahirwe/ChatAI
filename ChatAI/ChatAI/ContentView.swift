//
//  ContentView.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var chatStore = ChatStore()

    var body: some View {
        ScrollView {
            ForEach(chatStore.messages, content: MessageBubble.init)
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

    
    var emptyView: some View {
        Group {
            if chatStore.messages.isEmpty {
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
                           text: $chatStore.editedMessage.message)
            .submitLabel(.go)
            .onSubmit {
                Task { await chatStore.performSearch() }
            }
            Spacer()
            Button {
                Task { await chatStore.performSearch() }
            } label: {
                Group {
                    if chatStore.isAnswering {
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
                .disabled(chatStore.isAnswering)
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
