# Instalação no iPhone sem Mac

A compilação remota via GitHub Actions não gera, por si só, um IPA instalável. A instalação no iPhone requer assinatura de código Apple para o app e a extensão WidgetKit, com identificadores e capacidades apropriados.

Uma conta Apple gratuita permite provisionamento de desenvolvimento com limites e expiração curta, mas não substitui uma cadeia de assinatura no dispositivo nem garante App Groups para compartilhamento entre app e widget.

Ferramentas alternativas de sideload podem exigir computador inicial, re-assinatura periódica e podem falhar com extensões. Não publique chaves privadas ou certificados no repositório.

## Build
Actions > iOS Build > Run workflow. Um build verde confirma compilação, não instalação no iPhone.
