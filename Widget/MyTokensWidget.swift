import WidgetKit
import SwiftUI
struct TokensEntry: TimelineEntry {
    let date: Date
    let metrics: [UsageMetric]
}
struct TokensProvider: TimelineProvider {
    func placeholder(in context: Context) -> TokensEntry { TokensEntry(date: .now, metrics: []) }
    func getSnapshot(in context: Context, completion: @escaping (TokensEntry) -> Void) {
        completion(TokensEntry(date: .now, metrics: TokensStore.load()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<TokensEntry>) -> Void) {
        completion(Timeline(entries: [TokensEntry(date: .now, metrics: TokensStore.load())], policy: .after(Date().addingTimeInterval(1800))))
    }
}
struct TokensWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: TokensEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MyTokens").font(.headline)
            if entry.metrics.isEmpty {
                Text("Sem dados").font(.subheadline)
                Text("Abra o app para adicionar").font(.caption2)
            } else {
                ForEach(Array(entry.metrics.prefix(family == .systemSmall ? 1 : family == .systemMedium ? 2 : 5))) { metric in
                    TokenRow(metric: metric)
                }
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .containerBackground(Color(red: 0.05, green: 0.08, blue: 0.11), for: .widget)
    }
}
@main struct MyTokensWidgetBundle: WidgetBundle {
    var body: some Widget {
        StaticConfiguration(kind: "MyTokensWidget", provider: TokensProvider()) { entry in
            TokensWidgetView(entry: entry)
        }
        .configurationDisplayName("MyTokens")
        .description("Cotas de LLMs")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}