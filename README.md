# ForgeFit 🏋️‍♂️

App de acompanhamento de treinos e evolução física, criado para **estudar e praticar tecnologias modernas do ecossistema Apple** (e Firebase), aplicando também práticas de arquitetura e organização usadas em empresas.

Este README serve como registro do que já foi aprendido e desenvolvido — pra eu (ou quem mais der uma olhada) conseguir relembrar rápido o que foi feito e por quê, sem precisar reler o projeto inteiro.

---

## 🎯 Objetivo do projeto

Construir um app real, do zero, pra fixar na prática:

`SwiftUI` · `Swift Concurrency` · `MainActor` · `Observation Framework` · `Swift Testing` · `MVVM-C` · `Clean Architecture` · `Dependency Injection` · `Firebase` · `SwiftData` · `Swift Charts` · `Widgets` · `Live Activities` · `HealthKit` · `CI/CD`

---

## 🧱 Arquitetura

- **Padrão**: MVVM-C (Model-View-ViewModel-Coordinator)
- **Camadas**: Clean Architecture, com separação entre `Domain` (contratos/regras de negócio) e `Data` (implementações concretas — mock, Firebase, etc.)
- **Navegação**: `Repository Pattern` + `Dependency Injection`, modularização por features
- **Injeção de dependência**: hoje simplificada (serviços instanciados direto no `RootView`); container de DI mais estruturado é um item pendente para revisitar

### Estrutura de pastas

```
ForgeFit
 ├─ App              → entry point, RootView, AppCoordinator, AppRoute
 ├─ Core
 │   └─ DesignSystem  → Colors, Components, Spacing, Typography
 ├─ Domain            → protocolos e modelos de negócio (não sabe de Firebase/mock)
 ├─ Data              → implementações concretas dos protocolos (mock hoje, Firebase depois)
 └─ Features          → uma pasta por feature (Login, SignUp, ...), cada uma com View + ViewModel
```

---

## 🧭 Navegação (Coordinator Pattern)

- `AppCoordinator`: `@MainActor` `@Observable`, guarda um `path: [AppRoute]` (array tipado, escolhido no lugar de `NavigationPath` por dar type-safety e facilitar testes)
- `AppRoute`: enum com as rotas empilháveis (`login`, `home`, `profile`, `workout`, `signUp`)
- Login/SignUp → Home usa uma flag simples (`isAuthenticated`) no `RootView`, pois é uma troca de contexto raiz (sem "voltar")
- Login → SignUp usa o Coordinator de verdade (`goToSignUp()`), pois é uma tela auxiliar empilhada (com "voltar")

---

## 🎨 Design System

Paleta **Dark + Ember** (fundo escuro + laranja de destaque, remetendo a "forja"), com suporte completo a light/dark mode via Color Sets no `Assets.xcassets`.

| Camada | Arquivo | O que tem |
|---|---|---|
| Cores | `FFColors.swift` | Referências a Color Sets (`FFBackground`, `FFSurface`, `FFAccent`, textos, cores semânticas) |
| Espaçamento | `FFSpacing.swift` | Grid de 4pt (`xxs` a `xxl`) |
| Tipografia | `FFTypography.swift` | `Font.system` baseado em `TextStyle`, com suporte automático a Dynamic Type |
| Componentes | `FFButton`, `FFCard`, `FFTextField` | Reutilizáveis, já com suporte a loading, estilos e clear button opcional |

**Aprendizado-chave**: o dark mode é resolvido inteiramente no Assets.xcassets (Appearances "Any, Dark" em cada Color Set) — o código Swift não precisa saber que existem duas variantes, só referencia por nome.

---

## 🔐 Autenticação (mockada — Sprint 3 vai trocar pelo Firebase)

- `AuthServiceProtocol`: contrato (`login`, `signUp`, `logout`) — não sabe nada de Firebase ou mock
- `MockAuthService`: implementação fake com delay simulado (`Task.sleep`) e erros via `LocalizedError`
- `LoginViewModel` / `SignUpViewModel`: `@MainActor` `@Observable`, recebem o serviço via `init` (inversão de dependência) e avisam sucesso via **closure** (`onLoginSuccess` / `onSignUpSuccess`) em vez de depender do `AppCoordinator` diretamente — mantém o ViewModel testável sem precisar de navegação real

**Aprendizado-chave**: validações locais e instantâneas (ex: senha ≠ confirmação) devem rodar **antes** de `isLoading = true` — senão o usuário vê um spinner de loading por algo que nem chegou a chamar a rede.

---

## 📦 Progresso por sprint

- [x] **Sprint 1** — Estrutura inicial, Design System, navegação, Coordinator Pattern, componentes reutilizáveis
- [x] **Sprint 2** — Swift Concurrency, serviços mockados, MainActor, Observation Framework (fluxo de Login e SignUp completos)
- [ ] **Sprint 3** — Firebase Authentication: login, cadastro, logout, recuperação de senha, Keychain
- [ ] **Sprint 4** — Firestore: perfil do usuário, persistência remota, sincronização básica
- [ ] **Sprint 5** — CRUD de treinos e exercícios
- [ ] **Sprint 6** — Execução de treino, registro de séries, repetições e cargas
- [ ] **Sprint 7** — Timer de descanso, notificações locais, experiência de treino
- [ ] **Sprint 8** — Swift Charts, dashboard, evolução física
- [ ] **Sprint 9** — SwiftData e cache offline
- [ ] **Sprint 10** — Swift Testing, testes unitários e de integração
- [ ] **Sprint 11** — Crashlytics, Analytics, Remote Config, Feature Flags
- [ ] **Sprint 12** — Widgets, Live Activities, HealthKit, Apple Watch, CI/CD

---

## 📝 Pendências / débitos técnicos anotados

- [ ] Revisitar um container de **Dependency Injection** mais estruturado (hoje os serviços são instanciados direto no `RootView`)
- [ ] Considerar um `enum` de erro dedicado quando as validações locais dos ViewModels crescerem (hoje tudo é `String?`)

---

## 💡 Principais decisões técnicas (e por quê)

| Decisão | Alternativa considerada | Motivo |
|---|---|---|
| `[AppRoute]` no Coordinator | `NavigationPath` | Type-safety e testabilidade (`switch` exaustivo, dá pra inspecionar o path em testes) |
| Closure de callback no ViewModel (`onLoginSuccess`) | Injetar o `AppCoordinator` direto no ViewModel | Mantém o ViewModel desacoplado de navegação — mais fácil de testar isoladamente |
| Cores via Asset Catalog (`Color("Nome")`) | Hex hardcoded no código | Dark mode automático, sem `if colorScheme == .dark` espalhado pelo app |
| Tipografia via `Font.system(.style, ...)` | Tamanho fixo (`size: 34`) | Suporte automático a Dynamic Type (acessibilidade) |

---

## 🔗 Links

- Repositório: [github.com/jeff77araujo/ForgeFit](https://github.com/jeff77araujo/ForgeFit)
