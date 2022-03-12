//
//  ChatView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatView: View {

  @ObservedObject var presenter: ChatPresenter
  @State private var inputText: String = ""

  @State var sender: User = .initialize

  var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .bottom) {
        VStack {
          ScrollView {
            ForEach(presenter.chatsState.value?.reversed() ?? [], id: \.id) { chat in
              ChatItemView(chat: chat, isSender: chat.sender.userId == sender.userId)
            }
            .animation(.interactiveSpring(), value: presenter.chatsState)
            .padding(.top, 25)
          }

          ChatInputField(text: $inputText) { text in
            presenter.uploadChat(chat: .init(sender: sender, message: text, sentDate: Date(), seenBy: []))
          }
        }
      }
      .navigationBarTitle("Chat")
      .overlay(
        ImageCard(profileImage: sender.profilePict)
          .frame(width: 48, height: 48)
          .padding(.trailing, 20)
          .offset(x: 0, y: -80)
        , alignment: .topTrailing
      )
      .onTapGesture {
        hideKeyboard()
      }
      .onAppear {
        presenter.getChats()
      }
      .onReceive(presenter.$uploadChatState) { state in
        if case .success = state {
          withAnimation(.linear) {
            presenter.getChats()
          }
        }
      }
      .onReceive(presenter.$chatsState) { state in
        if case .success(let chats) = state {
          proxy.scrollTo(chats.count - 1, anchor: .bottom)
        }
      }

    }
  }
}

struct ChatView_Previews: PreviewProvider {

  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    ChatView(presenter: assembler.resolve())
  }
}


struct TestAnimationInStack: View {
  @State var ContentArray = ["A","B","C", "D", "E", "F", "G", "I", "J"]
  var body: some View {
    ScrollView{
      VStack{
        ForEach(Array(ContentArray.enumerated()), id: \.element){ (i, item) in // << 1) !
          ZStack{
            // Object
            Text(item)
              .frame(width:100,height:100)
              .background(Color.gray)
              .cornerRadius(20)
              .padding()
            //Delete button
            Button(action: {
              withAnimation { () -> () in              // << 2) !!
                self.ContentArray.remove(at: i)
              }
            }){
              Text("✕")
                .foregroundColor(.white)
                .frame(width:40,height:40)
                .background(Color.red)
                .cornerRadius(100)
            }.offset(x:40,y:-40)
          }.transition(AnyTransition.scale)              // << 3) !!!
        }
      }
    }
  }
}
