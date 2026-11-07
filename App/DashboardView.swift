import SwiftUI
struct DashboardView: View {
    @State private var metrics = TokensStore.load()
    @State private var showingAdd = false
    var body: some View {
        NavigationStack {
            List {
                Section("Cotas informadas manualmente") {
                    ForEach(metrics) { metric in TokenRow(metric: metric) }
                        .onDelete { offsets in
                            metrics.remove(atOffsets: offsets)
                            TokensStore.save(metrics)
                        }
                    if metrics.isEmpty { Text("Adicione uma LLM para começar").foregroundStyle(.secondary) }
                }
                Section {
                    Text("O saldo das assinaturas pessoais ChatGPT e Claude não é fornecido automaticamente pelas APIs públicas.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("MyTokens")
            .toolbar { Button { showingAdd = true } label: { Image(systemName: "plus") } }
            .sheet(isPresented: $showingAdd) {
                AddMetricView { metric in
                    metrics.append(metric)
                    TokensStore.save(metrics)
                }
            }
        }
    }
}
struct AddMetricView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var provider = "ChatGPT"
    @State private var remaining = "50"
    @State private var limit = "100"
    let onAdd: (UsageMetric) -> Void
    var body: some View {
        NavigationStack {
            Form {
                TextField("LLM", text: $provider)
                TextField("Restante", text: $remaining).keyboardType(.decimalPad)
                TextField("Limite", text: $limit).keyboardType(.decimalPad)
                Text("Valores inseridos manualmente").font(.caption).foregroundStyle(.secondary)
            }
            .navigationTitle("Adicionar LLM")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        guard let r = Double(remaining), let l = Double(limit), l > 0, r >= 0, r <= l else { return }
                        onAdd(UsageMetric(provider: provider, remaining: r, limit: l))
                        dismiss()
                    }
                }
            }
        }
    }
}