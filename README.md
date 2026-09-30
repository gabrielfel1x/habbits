# 🐰 Habbits

App mobile de controle de hábitos feito com Flutter. Crie hábitos com ícone e dias da semana, marque o que já fez no dia e acompanhe a evolução em gráficos.

![Flutter](https://img.shields.io/badge/Flutter-3.8+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/State-Provider-7EA18D?style=for-the-badge)

## 📋 Sumário

- [Funcionalidades](#-funcionalidades)
- [Telas](#-telas)
- [Stack](#-stack)
- [Pré-requisitos](#-pré-requisitos)
- [Como rodar](#-como-rodar)
- [Configuração da API](#-configuração-da-api)
- [Estrutura do projeto](#-estrutura-do-projeto)
- [Arquitetura](#-arquitetura)
- [Componentes](#-componentes)
- [Design](#-design)
- [Comandos úteis](#-comandos-úteis)
- [Autor](#-autor)

## ✨ Funcionalidades

- **Autenticação**: cadastro e login com validação de formulário. O token fica salvo no aparelho (`shared_preferences`) e a sessão é restaurada ao abrir o app.
- **Hábitos**: criar, editar e excluir, com nome, ícone e dias da semana em que o hábito se repete.
- **Check diário**: marque os hábitos do dia como concluídos (ou desfaça) direto na home.
- **Dashboard**: card com o progresso do dia e lista dos hábitos agendados para hoje.
- **Gráficos** (`fl_chart`):
  - linha de evolução;
  - barras de desempenho por dia da semana;
  - pizza com a distribuição dos hábitos.
- **Frase motivacional**: uma frase aleatória vinda da API na home.
- **Notificações in-app**: feedback visual de sucesso e erro nas ações.

## 📱 Telas

| Tela | Arquivo | O que faz |
| --- | --- | --- |
| Login | `lib/pages/login_page.dart` | Entrar com e-mail e senha |
| Cadastro | `lib/pages/register_page.dart` | Criar conta |
| Home | `lib/pages/home_page.dart` | Progresso do dia, frase e hábitos de hoje |
| Meus hábitos | `lib/pages/my_habits_page.dart` | Lista de hábitos, acesso à edição |
| Criar hábito | `lib/pages/create_habit_page.dart` | Nome, ícone e dias da semana |
| Editar hábito | `lib/pages/edit_habit_page.dart` | Alterar ou excluir um hábito |
| Gráficos | `lib/pages/graphics_page.dart` | Evolução, desempenho semanal e distribuição |
| Perfil | `lib/pages/profile_page.dart` | Dados do usuário e logout |

A navegação principal é uma barra inferior com cinco abas: Home, Meus hábitos, Criar, Gráficos e Perfil.

## 🧰 Stack

| Pacote | Uso |
| --- | --- |
| `provider` | Estado de autenticação |
| `dio` / `http` | Chamadas à API |
| `shared_preferences` | Persistência local da sessão |
| `fl_chart` | Gráficos |
| `google_fonts` | Fonte Inter |
| `flutter_svg` | Logo e ilustrações do coelho |
| `lucide_icons` | Ícones dos hábitos e da interface |

## 🛠️ Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.8 ou superior (Dart `^3.8.1`)
- Android Studio ou VS Code com as extensões de Flutter/Dart
- Um emulador ou dispositivo físico
- A API do Habbits rodando (veja [Configuração da API](#-configuração-da-api))

## 🚀 Como rodar

```bash
git clone https://github.com/gabrielfel1x/habbits.git
cd habbits

flutter doctor      # confere o ambiente
flutter pub get     # instala as dependências
flutter run         # roda no dispositivo/emulador conectado
```

Outras plataformas:

```bash
flutter run -d chrome    # Web
flutter run -d windows   # Windows
flutter run -d macos     # macOS
flutter run -d linux     # Linux
```

## 🌐 Configuração da API

O app consome uma API REST própria. A URL base fica em `lib/core/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  // ...
}
```

> No **emulador Android**, `localhost` aponta para o próprio emulador. Use `http://10.0.2.2:3000/api` para alcançar a API da sua máquina. Em dispositivo físico, use o IP da máquina na rede local.

Endpoints usados pelo app:

| Método | Rota | Uso |
| --- | --- | --- |
| `POST` | `/register` | Cadastro |
| `POST` | `/login` | Login |
| `GET` / `POST` | `/habits` | Listar e criar hábitos |
| `PUT` / `DELETE` | `/habits/:id` | Editar e excluir hábito |
| `GET` | `/habit-checks` | Checks dos hábitos |
| `PUT` | `/habit-checks/:id/check` | Marcar ou desmarcar um hábito |
| `GET` | `/dashboard` | Dados de progresso e gráficos |
| `GET` | `/phrases/random` | Frase motivacional |

## 📁 Estrutura do projeto

```
habbits/
├── android/ ios/ web/ windows/ linux/ macos/   # plataformas
├── assets/                  # rabbit.svg, rabbit_white.svg, rabbit_gray.svg
├── test/                    # testes
└── lib/
    ├── main.dart            # entrada, AuthWrapper e navegação principal
    ├── components/          # widgets reutilizáveis
    ├── core/                # cores, API, validadores, datas, ícones
    ├── models/              # User e Habbit
    ├── pages/               # telas
    ├── providers/           # AuthProvider
    ├── routes/              # rotas nomeadas
    └── services/            # acesso à API por domínio
```

## 🏗️ Arquitetura

Organização em camadas simples, sem pacotes extras de arquitetura:

```
Pages / Components  →  Providers  →  Services  →  ApiService (Dio)  →  API
```

- **Pages** montam a tela e chamam services ou providers.
- **Providers** guardam estado compartilhado. Hoje só o `AuthProvider` (logado, carregando, usuário atual, erro).
- **Services** têm uma classe por domínio: `AuthService`, `HabbitService`, `HabitCheckService`, `DashboardService`, `PhraseService`.
- **ApiService** centraliza a configuração do cliente HTTP, headers e timeouts.
- **AuthWrapper** (`main.dart`) decide a tela inicial: loading, login ou app principal.

## 🧩 Componentes

| Componente | Função |
| --- | --- |
| `AppHeader` | Cabeçalho com título e subtítulo |
| `AppBottomNavigationBar` | Barra de navegação inferior |
| `AppLogo` | Logo do coelho |
| `AppNotification` | Notificação de sucesso/erro dentro do app |
| `CustomTextField` / `CustomTextFieldLight` | Campos de texto (tema escuro e claro) |
| `CustomButton` / `CustomActionButton` | Botões |
| `AuthLinks` | Links entre login e cadastro |
| `HabitCard` | Card de um hábito na lista |
| `HabitNameInput` | Campo do nome do hábito |
| `IconPicker` | Seletor de ícone do hábito |
| `WeekDaysSelector` | Seletor dos dias da semana |
| `DailyHabitsList` | Lista de hábitos do dia com check |
| `DailyProgressCard` | Progresso do dia |
| `QuoteCard` | Frase motivacional |

## 🎨 Design

Paleta verde definida em `lib/core/colors.dart`:

| Cor | Hex |
| --- | --- |
| `primaryColor` | `#7EA18D` |
| `secondaryColor` | `#B7D0C1` |
| `warningColor` | `#EC624F` |
| `gray` | `#808080` |
| `grayLight` | `#AAAAAA` |
| `grayVeryLight` | `#F0F0F0` |

Tipografia: [Inter](https://fonts.google.com/specimen/Inter) via `google_fonts`. Material Design com `ColorScheme.fromSeed`.

## 🔧 Comandos úteis

```bash
flutter pub upgrade        # atualiza dependências
flutter clean && flutter pub get   # limpa o cache de build
flutter analyze            # análise estática (flutter_lints)
flutter test               # testes

flutter build apk --release        # APK
flutter build appbundle --release  # Android App Bundle
flutter build web --release        # Web
```

## 👤 Autor

Feito por **Gabriel Felix** ([@gabrielfel1x](https://github.com/gabrielfel1x)).
