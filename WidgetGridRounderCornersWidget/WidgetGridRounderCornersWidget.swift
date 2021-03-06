//
//  WidgetGridRounderCornersWidget.swift
//  WidgetGridRounderCornersWidget
//
//  Created by Geoff Hackworth on 23/09/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetGridRounderCornersWidgetEntryView : View {
    var entry: Provider.Entry

    private let outerPadding = 12.0
    private let innerPadding = 12.0
    private let numberOfRows = 4
    private let numberOfColumns = 4

    var body: some View {
        GeometryReader { geometry in
            let rowHeight = (geometry.size.height - CGFloat(numberOfRows - 1) * innerPadding) / CGFloat(numberOfRows)

            VStack {
                ZStack {
                    // The first row
                    rowView(forRowNumber: 0)

                    // Subsequent rows will be on top of the first row (as we're in a ZStack) but offset downwards to where they ought to appear
                    ForEach(1..<numberOfRows) { rowNumber in
                        rowView(forRowNumber: rowNumber)
                            .frame(height: rowHeight)
                            .offset(x: 0,
                                    y: CGFloat(rowNumber) * (rowHeight + innerPadding))
                    }
                }

                // We need spacers for where the 1..<numberOfRows should appear to ensure the first row's height is calculated correctly
                ForEach(1..<numberOfRows) { rowNumber in
                    Spacer(minLength: innerPadding)
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .padding()
    }

    private func rowView(forRowNumber rowNumber: Int) -> some View {
        HStack {
            ForEach(0..<numberOfColumns) { columnNumber in
                if columnNumber != 0 {
                    Spacer(minLength: innerPadding)
                }

                cellView(forIndex: rowNumber * numberOfColumns + columnNumber)
                    .clipShape(ContainerRelativeShape())
            }
        }
    }

    private func cellView(forIndex index: Int) -> some View {
        ZStack {
            Color(.red)
            Text("\(index)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@main
struct WidgetGridRounderCornersWidget: Widget {
    let kind: String = "WidgetGridRounderCornersWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetGridRounderCornersWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemExtraLarge])
    }
}

struct WidgetGridRounderCornersWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetGridRounderCornersWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
