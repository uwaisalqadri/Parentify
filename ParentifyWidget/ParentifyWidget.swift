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
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), iconName: "shippingbox.fill", title: "Not Found", message: "No task founded")
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, iconName: "shippingbox.fill", title: "Not Found", message: "No task founded")
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let firebaseManager: FirebaseManager = DefaultFirebaseManager()
    var entries: [SimpleEntry] = []

    firebaseManager.fetchAssignments { result in
      switch result {
      case .success(let assignments):

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        for assignment in assignments {
          let entry = SimpleEntry(
            date: assignment.dateCreated?.date ?? Date(),
            configuration: configuration,
            iconName: assignment.iconName ?? "",
            title: assignment.title ?? "",
            message: assignment.description ?? ""
          )
          entries.append(entry)
        }

      case .failure(let error):
        print(error)
      }

      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let iconName: String
  let title: String
  let message: String
}

struct WidgetAssignmentRow: View {

  var entry: Provider.Entry

  var body: some View {
    HStack {
      Image(systemName: entry.iconName)
        .resizable()
        .frame(width: 14, height: 10)
        .foregroundColor(.white)
        .background(
          Color("PurpleColor")
            .frame(width: 27, height: 27, alignment: .center)
            .cornerRadius(8)
        )
        .padding(.leading, 4)

      VStack(alignment: .leading) {
        Text(entry.title)
          .foregroundColor(.black)
          .font(.system(size: 8, weight: .semibold))
          .padding(.bottom, 1)
          .lineLimit(1)

        Text(entry.date.toString(format: "MMMM d, yyyy"))
          .foregroundColor(.gray)
          .font(.system(size: 8, weight: .regular))
          .padding(.top, -6)
      }
      .padding(.leading, 5)
    }
    .padding(16)
    .cardShadow(cornerRadius: 19)

  }
}

struct WidgetMessagesRow: View {

  var body: some View {
    HStack {
      text
        .lineLimit(3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    .cardShadow(cornerRadius: 19)
    .padding(.horizontal, 16)
  }

  var text: some View {
    Text("Ayah: ")
      .font(.system(size: 7, weight: .semibold))
      .foregroundColor(.purpleColor)
    +
    Text("Jangan lupa ngerjain PR ya bil, udah ditagih sama bu guru Fatimah")
      .foregroundColor(.black)
      .font(.system(size: 7, weight: .regular))
  }
}

struct ParentifyWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Image("Icon")
        .scaleEffect(0.7)
        .padding(.top, -10)

      WidgetAssignmentRow(entry: entry)
        .padding(.top, -4)

      WidgetMessagesRow()
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
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemSmall])
  }
}
