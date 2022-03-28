//
//  ParentifyWidget.swift
//  ParentifyWidget
//
//  Created by Uwais Alqadri on 3/27/22.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct Provider: IntentTimelineProvider {

  private var sampleEntry: SimpleEntry = {
    return SimpleEntry(
      configuration: ConfigurationIntent(),
      assignment: .init(
        iconName: "briefcase.fill",
        title: "Mengerjakan PR",
        description: "",
        type: .needToDone ,
        dateCreated: Date(),
        attachments: [],
        assignedTo: []
      ),
      message: .init(
        message: "Jangan lupa ngerjain PR ya bil, udah ditagih sama bu guru",
        role: .mother,
        sentDate: Date()
      )
    )
  }()

  func placeholder(in context: Context) -> SimpleEntry {
    sampleEntry
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    completion(sampleEntry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let firebaseManager: FirebaseManager = DefaultFirebaseManager()
    var entries: [SimpleEntry] = []

    firebaseManager.fetchAssignmentWithMessage { result in
      switch result {
      case .success(let data):
        let entry = SimpleEntry(
          configuration: configuration,
          assignment: data.assignment.map(),
          message: data.message.map()
        )

        entries.append(entry)

      case .failure(let error):
        print(error)
      }

      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date = Date()
  let configuration: ConfigurationIntent
  let assignment: Assignment
  let message: Message
}

struct WidgetAssignmentRow: View {
  var entry: Provider.Entry

  var body: some View {
    HStack {
      Image(systemName: entry.assignment.iconName)
        .scaleEffect(0.84)
        .foregroundColor(.white)
        .background(
          Color("PurpleColor")
            .frame(width: 27, height: 27, alignment: .center)
            .cornerRadius(8)
        )

      VStack(alignment: .leading) {
        Text(entry.assignment.title)
          .foregroundColor(.black)
          .font(.system(size: 8, weight: .semibold))
          .padding(.bottom, 1)
          .lineLimit(1)

        Text(entry.assignment.dateCreated.toString(format: "MMMM d, yyyy"))
          .foregroundColor(.gray)
          .font(.system(size: 8, weight: .regular))
          .padding(.top, -6)
      }
      .padding(.leading, 5)
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .cardShadow(cornerRadius: 19)
    .padding(.horizontal, 10)

  }
}

struct WidgetMessagesRow: View {
  var entry: Provider.Entry

  var roleName: String {
    switch entry.message.role {
    case .father:
      return "Ayah"
    case .mother:
      return "Ibu"
    case .children:
      return "unknown"
    }
  }

  var body: some View {
    HStack {
      text
        .lineLimit(3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    .cardShadow(cornerRadius: 19)
    .padding(.horizontal, 10)
  }

  var text: some View {
    Text("\(roleName): ")
      .font(.system(size: 8, weight: .semibold))
      .foregroundColor(.purpleColor)
    +
    Text(entry.message.message)
      .foregroundColor(.black)
      .font(.system(size: 8, weight: .regular))
  }
}

struct ParentifyWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Image("Icon")
        .scaleEffect(0.95)
        .padding(.top, -9)

      WidgetAssignmentRow(entry: entry)

      WidgetMessagesRow(entry: entry)
    }
  }
}

@main
struct ParentifyWidget: Widget {

  init() {
    FirebaseApp.configure()
  }

  let kind: String = "ParentifyWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      ParentifyWidgetEntryView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("WidgetBackground"))
    }
    .configurationDisplayName("Parentify")
    .description("See the current Assignment and recent Important Message ")
    .supportedFamilies([.systemSmall])
  }
}
