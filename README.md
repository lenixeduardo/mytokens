# MyTokens

Widget iOS para acompanhar cotas de uso de modelos de IA.

## Stack
SwiftUI, WidgetKit, App Intents, Keychain e GitHub Actions.

## Limitações
A autenticação de API OpenAI/Anthropic não fornece automaticamente o saldo das assinaturas pessoais ChatGPT/Claude. Valores manuais devem ser identificados como tais. O build sem assinatura não é instalável no iPhone; para WidgetKit, aplicativo e extensão precisam de assinatura e provisionamento compatíveis.

## Próximas etapas
Publicar fontes do MVP e assets C1, compilar em runner macOS, corrigir erros de build e validar instalação e acessibilidade em dispositivo real.
