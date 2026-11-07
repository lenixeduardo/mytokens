import Foundation
import SwiftUI
import WidgetKit

struct UsageMetric: Codable, Identifiable {
    var id = UUID()
    var provider: String
    var remaining: Double
    var limit: Double
    var updatedAt = Date()
    var percentage: Int { limit > 0 ? Int(max(0, min(100, remaining / limit * 100))) : 0 }
}
enum TokensStore {
    static let group = "group.com.example.mytokens"
    static let key = "metrics"
    static func load() -> [UsageMetric] {
        guard let data = UserDefaults(suiteName: group)?.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([UsageMetric].self, from: data)) ?? []
    }
    static func save(_ metrics: [UsageMetric]) {
        guard let data = try? JSONEncoder().encode(metrics) else { return }
        UserDefaults(suiteName: group)?.set(data, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
enum TokenPalette {
    static func color(_ percent: Int) -> Color {
        switch percent {
        case 70...100: return .green
        case 40..<70: return .yellow
        case 10..<40: return .orange
        default: return .red
        }
    }
}
struct TokenRow: View {
    let metric: UsageMetric
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(metric.provider).font(.subheadline.bold())
                Spacer()
                Text("\(metric.percentage)%").monospacedDigit()
            }
            ProgressView(value: Double(metric.percentage), total: 100)
                .tint(TokenPalette.color(metric.percentage))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(metric.provider), \(metric.percentage) por cento disponível")
    }
}