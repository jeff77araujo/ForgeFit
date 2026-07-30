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

### Fluxo de autenticação (`AppCoordinator`)

- `AppCoordinator`: `@MainActor` `@Observable`, guarda um `path: [AppRoute]` (array tipado, escolhido no lugar de `NavigationPath` por dar type-safety e facilitar testes)
- `AppRoute`: enum enxuto, só com as rotas do fluxo de auth (`signUp`, `forgotPassword`) — os cases antigos (`home`, `profile`, `workout`) foram removidos depois que a TabView passou a cuidar dessas telas
- Login/SignUp → Tabs usa uma flag simples (`isAuthenticated`) no `RootView`, pois é uma troca de contexto raiz (sem "voltar")
- Login → SignUp e Login → ForgotPassword usam o Coordinator de verdade (`goToSignUp()` / `goToForgotPassword()`), pois são telas auxiliares empilhadas (com "voltar")
- Ao abrir o app, um `.task` no `RootView` chama `authService.currentUser()` pra checar se já existe sessão válida (Firebase mantém isso via Keychain), evitando pedir login de novo toda vez

### Pós-login (`MainTabView` + coordinator por aba)

- `MainTabView`: uma `TabView` com 3 abas (Home, Perfil, Treinos), cada uma com sua própria `NavigationStack`
- Cada aba tem seu **próprio coordinator e enum de rota** (`HomeCoordinator`/`HomeRoute`, `ProfileCoordinator`/`ProfileRoute`, `WorkoutCoordinator`/`WorkoutRoute`) — evita um `AppRoute` único virando um "enum deus" conforme o app cresce
- Cada coordinator é `@State` dentro do `MainTabView`, injetado via `.environment(...)` só na `NavigationStack` da própria aba — trocar de aba não reseta o histórico de navegação de cada uma

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

## 🔐 Autenticação (Firebase Auth — Sprint 3 concluída)

- `AuthServiceProtocol`: contrato (`login`, `signUp`, `logout`, `resetPassword`, `currentUser`) — não sabe nada de Firebase ou mock
- `MockAuthService`: implementação fake com delay simulado (`Task.sleep`) e erros via `LocalizedError` — usada na Sprint 2 pra construir a UI antes do Firebase existir
- `FirebaseAuthService`: implementação real, usando `FirebaseAuth` via SPM — trocar mock por real foi **só mudar uma linha** no `RootView` (`MockAuthService()` → `FirebaseAuthService()`), sem tocar em nenhum ViewModel ou View
- `LoginViewModel` / `SignUpViewModel` / `ForgotPasswordViewModel`: `@MainActor` `@Observable`, recebem o serviço via `init` (inversão de dependência)
- Login/SignUp avisam sucesso via **closure** (`onLoginSuccess` / `onSignUpSuccess`) em vez de depender do `AppCoordinator` diretamente — mantém o ViewModel testável sem precisar de navegação real
- `ForgotPasswordView` usa `@Environment(\.dismiss)` em vez de closure, já que o destino após sucesso é sempre "voltar uma tela"
- Sessão persistida: `currentUser()` consulta `Auth.auth().currentUser` (síncrono, resolvido via Keychain internamente pelo Firebase) — checado uma vez ao abrir o app via `.task` no `RootView`
- Logout: `FFButton` temporário na Home placeholder chama `authService.logout()` e reseta `isAuthenticated`

**Aprendizados-chave**:
- Validações locais e instantâneas (ex: senha ≠ confirmação) devem rodar **antes** de `isLoading = true` — senão o usuário vê um spinner de loading por algo que nem chegou a chamar a rede
- No Firebase Console, **Authentication → Sign-in method → Email/Password** precisa estar ativado manualmente antes de qualquer chamada funcionar — sem isso o SDK retorna um erro genérico ("An internal error has occurred") difícil de diagnosticar
- `GoogleService-Info.plist` deve entrar no `.gitignore` (repositório é público)

---

## 👤 Perfil do usuário (Firestore — Sprint 4 concluída)

- `UserProfile`: modelo `Codable` (nome, foto, data de nascimento, peso/altura, meta de treino via enum `WorkoutGoal`) — `id` é o mesmo `uid` do Firebase Auth, evitando ter dois IDs pra linkar
- `UserRepositoryProtocol`: contrato (`createProfile`, `fetchProfile`, `updateProfile`) — separado do `AuthServiceProtocol` de propósito, já que autenticação e dados de perfil são responsabilidades diferentes
- `FirestoreUserRepository`: implementação real, usa `setData(from:)`/`data(as:)` (Codable) pra converter `UserProfile` ↔ documento do Firestore automaticamente, sem montar `[String: Any]` na mão
- `MockUserRepository`: implementação fake em memória (`[String: UserProfile]`), com `init(seed:)` pra popular dados de teste (essencial pros previews mostrarem algo além de tela em branco)
- `ProfileViewModel`/`ProfileView`: tela de leitura **e edição** — usa `Binding($viewModel.profile)` pra "desembrulhar" o `UserProfile?` num `Binding` não-opcional pro formulário, com `Binding(get:set:)` manuais pra traduzir `Double?` ↔ `String` nos campos de peso/altura
- Ao cadastrar uma conta, o `SignUpViewModel` já cria o perfil inicial no Firestore (chama `authService.signUp` e `userRepository.createProfile` em sequência)

**Aprendizados-chave**:
- Um repository "vazio" (mock sem dados) não é um erro — `fetchProfile` retorna `nil` normalmente. A `ProfileView` precisa tratar esse caso explicitamente (senão a tela fica em branco silenciosamente, sem erro nenhum aparecendo)
- `@ViewBuilder` é obrigatório em qualquer `var`/função de view que tenha `if`/`switch` sem um tipo de retorno único — o `body` já ganha isso de graça (via protocolo `View`), mas views extraídas em propriedades separadas (como `form` no `ProfileView`) precisam do atributo explícito

---

## 🏋️ Treinos (CRUD — Sprint 5 concluída)

- `Workout`/`Exercise`/`PlannedSet`: modelagem em camadas — um `Workout` é um **molde reutilizável** (ex: "Treino A - Peito"), não uma sessão executada; isso separa "o que está planejado" de "o que aconteceu de fato" (conceito que volta na Sprint 6 com execução real)
- `id` de `Workout`/`Exercise`/`PlannedSet` gerado com `UUID().uuidString` (diferente do `UserProfile`, que reaproveitava o `uid` do Auth — aqui não existe identidade natural pra reaproveitar)
- `WorkoutRepositoryProtocol`: CRUD completo (`create`, `fetch` retornando array — 1 usuário tem N treinos —, `update`, `delete`)
- `FirestoreWorkoutRepository`: primeira **query** real do projeto (`whereField` + `order`), exigiu criar um **índice composto** no Firestore
- Lista de treinos mora na aba **Treinos** (`WorkoutListView`/`WorkoutCoordinator`), não na Home — Home é reservada para um dashboard/resumo futuro (Sprint 8)
- Lista usa `List` (não `ScrollView`) com `DisclosureGroup` por treino (expande mostrando os exercícios) e `.swipeActions` com **dois** botões (Excluir + Editar)
- `CreateWorkoutView` serve tanto para criar quanto editar (mesmo ViewModel, `existingWorkout: Workout?` no `init` decide o modo) — usa `ForEach` com bindings aninhados (`ForEach($viewModel.exercises)`, e dentro `ForEach(exercise.sets)`) para editar arrays em todos os níveis sem código manual de índice

**Aprendizados-chave**:
- **Índice composto do Firestore**: sempre que uma query combina `whereField` (filtro) com `order(by:)` num campo diferente, o Firestore exige um índice específico para essa combinação — sem ele, a query falha com um erro que já vem com o link pronto pra criar o índice no Console
- **`.swipeActions` só funciona dentro de `List`** (não em `ScrollView` + `VStack`) — migrar exigiu `.listRowBackground(.clear)`, `.listRowSeparator(.hidden)` e `.scrollContentBackground(.hidden)` para o visual não conflitar com os componentes do Design System
- **`NavigationStack` aninhado é um bug silencioso**: colocar uma `TabView` (com `NavigationStack` próprio em cada aba) dentro de outro `NavigationStack` externo faz `.navigationTitle`/`.toolbar` da stack interna serem ignorados, sem nenhum erro — a correção foi restringir o `NavigationStack` externo só ao fluxo de autenticação

---

## ✅ Execução de treino (Sprint 6 concluída)

- `WorkoutSession`/`CompletedExercise`/`CompletedSet`: modelo separado do `Workout` (molde) — representa o que **de fato aconteceu** num dia de treino, podendo divergir do planejado
- `workoutId` + `workoutName` guardados juntos na sessão: `workoutId` referencia o molde original, mas `workoutName` é uma cópia — assim, editar/deletar o `Workout` depois não quebra o histórico de sessões antigas
- Ao iniciar uma sessão, o `WorkoutSessionViewModel` **clona** os dados do `Workout` (reps/peso planejados como sugestão inicial, `isDone: false` em cada série) — usuário só ajusta o que mudou durante o treino
- `WorkoutSessionRepositoryProtocol` não tem `delete` (intencional — sessão já executada é histórico, não algo que normalmente se apaga)
- `WorkoutSessionView`: séries agrupadas por exercício com `Section`, checkbox por série (toggle via ViewModel, não binding direto — é uma ação de negócio), botão "Finalizar treino" fixo na tela com `.safeAreaInset(edge: .bottom)`
- Histórico de sessões finalizadas vive na aba **Home** (que assume de vez o papel de dashboard/resumo)

**Aprendizados-chave**:
- `.safeAreaInset(edge: .bottom)` fixa uma view na parte de baixo da tela, sempre visível mesmo com o conteúdo acima rolando — padrão comum para ações principais (ex: "Finalizar", "Continuar") que não deveriam exigir rolar até o fim para encontrar
- `.formatted(date:time:)` formata datas de forma moderna e localizada automaticamente (sem `DateFormatter` manual), respeitando o idioma/região do dispositivo
- Uma ação com significado de negócio (marcar série como concluída) fica melhor como método no ViewModel do que como binding direto na View — mesmo sendo "só um toggle", deixa a intenção explícita e testável

---

## 📦 Progresso por sprint

- [x] **Sprint 1** — Estrutura inicial, Design System, navegação, Coordinator Pattern, componentes reutilizáveis
- [x] **Sprint 2** — Swift Concurrency, serviços mockados, MainActor, Observation Framework (fluxo de Login e SignUp completos)
- [x] **Sprint 3** — Firebase Authentication: login, cadastro, logout, recuperação de senha, sessão persistida (Keychain via Firebase)
- [x] **Sprint 4** — Firestore: perfil do usuário (leitura e edição), persistência remota, sincronização básica + TabView com coordinator por aba (adicional)
- [x] **Sprint 5** — CRUD de treinos e exercícios (criar, listar/expandir, editar, excluir)
- [x] **Sprint 6** — Execução de treino, registro de séries/reps/cargas, histórico de sessões
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
- [ ] Refatorar `SignUpViewModel` para usar um `SignUpUseCase` em vez de depender direto de `AuthServiceProtocol` + `UserRepositoryProtocol` juntos (Single Responsibility)

---

## 💡 Principais decisões técnicas (e por quê)

| Decisão | Alternativa considerada | Motivo |
|---|---|---|
| `[AppRoute]` no Coordinator | `NavigationPath` | Type-safety e testabilidade (`switch` exaustivo, dá pra inspecionar o path em testes) |
| Closure de callback no ViewModel (`onLoginSuccess`) | Injetar o `AppCoordinator` direto no ViewModel | Mantém o ViewModel desacoplado de navegação — mais fácil de testar isoladamente |
| Cores via Asset Catalog (`Color("Nome")`) | Hex hardcoded no código | Dark mode automático, sem `if colorScheme == .dark` espalhado pelo app |
| Tipografia via `Font.system(.style, ...)` | Tamanho fixo (`size: 34`) | Suporte automático a Dynamic Type (acessibilidade) |
| `@Environment(\.dismiss)` no ForgotPassword | Closure de callback (padrão do Login/SignUp) | Não existe "próxima tela" após reset — só faz sentido voltar, então o `dismiss` nativo é mais simples |
| Coordinator + enum de rota por aba | Um `AppRoute` único compartilhado por tudo | Evita um enum gigante conforme o app cresce, e cada aba mantém histórico de navegação independente |
| `id` do `UserProfile` = `uid` do Firebase Auth | Gerar um ID novo pro documento do Firestore | Busca direta (`users/{uid}`), sem precisar de query extra pra linkar auth com perfil |
| `Workout` como molde reutilizável | Treino = sessão única já na Sprint 5 | Reflete como o usuário pensa na prática (reusa o treino, não recria toda vez) e prepara terreno pra separar planejado x executado na Sprint 6 |
| Lista de treinos na aba Treinos, não na Home | Deixar a lista onde foi criada primeiro (Home) | Home fica reservada para um dashboard/resumo (Sprint 8); Treinos é o nome que já sinalizava esse propósito |
| `WorkoutSession` separado de `Workout` | Um único modelo servindo de molde e execução | Permite divergir do planejado (peso/reps reais) sem afetar o molde, e mantém histórico íntegro mesmo se o molde for editado/apagado |
| Clonar dados do `Workout` ao iniciar sessão | Começar a sessão vazia, sem sugestão | Reduz fricção — usuário só ajusta o que mudou, em vez de digitar tudo de novo |

---

## 🔗 Links

- Repositório: [github.com/jeff77araujo/ForgeFit](https://github.com/jeff77araujo/ForgeFit)
