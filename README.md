# 🎵 Cisound

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-Database-FF9E0F?style=for-the-badge)
![Provider](https://img.shields.io/badge/Provider-State_Management-4CAF50?style=for-the-badge)

**Cisound** é um aplicativo mobile desenvolvido em Flutter para exploração e gerenciamento de álbuns musicais. Consumindo a API pública do Last.fm, o aplicativo permite pesquisar álbuns, visualizar detalhes (como tracklists e tags) e salvar os álbuns favoritos localmente no dispositivo para acesso offline. O design adota uma estética minimalista focada no *dark mode* e alto contraste.

---

## 📱 Telas do Aplicativo

<img width="1040" height="610" alt="image" src="https://github.com/user-attachments/assets/89919da5-6f5a-4562-a3d1-46e252b7201c" />

1. **Mock Login:** Tela inicial de credenciamento simples. O nome de usuário é persistido para garantir que cada pessoa tenha sua própria "estante" de favoritos no dispositivo.
2. **Pesquisa (Explorar):** Interface reativa para busca de álbuns na API do Last.fm, exibindo resultados com *lazy loading* para garantir alta performance.
3. **Detalhes do Álbum:** Exibe a capa em destaque, metadados, tags de gênero e a lista de faixas musicais (tracklist). Inclui a ação de favoritar.
4. **Meus Favoritos:** Estante offline do usuário, com suporte a remoção de itens via gesto de deslize (*swipe-to-dismiss*).

---

## 🏗️ Arquitetura e Decisões Técnicas

O projeto foi rigorosamente estruturado utilizando o padrão **MVVM (Model-View-ViewModel)**, garantindo a separação de responsabilidades (SRP - *Single Responsibility Principle*).

### 1. Padrão MVVM
* **Model:** Entidades de dados (`Album`, `Track`, `AlbumDetails`) e serviços de infraestrutura (`LastFmService`, `StorageService`).
* **View:** Componentes visuais declarativos, restritos a desenhar a interface e escutar as notificações de estado. Sem lógicas de negócio.
* **ViewModel:** Classes orquestradoras que gerenciam o estado em memória, disparam requisições assíncronas e emitem `notifyListeners()` para reatividade da UI.

### 2. Gerenciamento de Estado (Provider)
O pacote `provider` foi adotado por sua relação custo-benefício pragmática.
* **Estado Global:** O `FavoritesViewModel` e o `AuthViewModel` garantem consistência da identidade do usuário e de sua estante através de toda a árvore de widgets.
* **Estado Efêmero:** ViewModels como `SearchViewModel` e `AlbumDetailsViewModel` encapsulam regras de interface momentâneas (como o controle de variáveis `isLoading` e `errorMessage`).

### 3. Persistência de Dados (Hive)
Para armazenamento offline, adotou-se o banco de dados NoSQL **Hive**. A escolha evita o *over-engineering* de soluções relacionais (como SQLite), operando objetos Dart nativamente em formato binário (O(1) de complexidade).
* **Isolamento Multitenancy:** O `StorageService` utiliza *Caixas Dinâmicas* (ex: `favorites_joao.hive`). Cada usuário logado possui um arquivo físico segregado no sistema, garantindo que as estantes nunca se misturem.
* **Estratégia de Persistência Mínima:** Apenas a entidade `Album` (id, título, artista, capa) é persistida com anotações `@HiveType`. O modelo `AlbumDetails` (que contém *tracks* e *tags*) não é salvo no banco, sendo buscado sob demanda da API. Isso evita redundância de dados e bancos de dados inflados desnecessariamente.

---

## 🛠️ Tecnologias e Pacotes Utilizados

As dependências principais incluem:

* `flutter`: Framework UI (SDK ^3.12.2).
* `http`: Cliente HTTP nativo para comunicação REST com a API Last.fm.
* `provider`: Injeção de dependência e gerência de estado.
* `hive` / `hive_flutter`: Banco de dados NoSQL de chave-valor de alta performance.
* `build_runner` / `hive_generator`: Geração de código automatizada para serialização de objetos (TypeAdapters).
* `flutter_dotenv`: Ocultação e injeção de variáveis de ambiente.
* `flutter_native_splash` / `flutter_launcher_icons`: Geração de ícones de aplicativo e telas de *splash* nativas.

---

## 🚀 Como Executar o Projeto

Siga as instruções abaixo para configurar o ambiente e compilar o aplicativo:

### Pré-requisitos
* Flutter SDK instalado na máquina.
* Uma chave de API gratuita do [Last.fm](https://www.last.fm/api).

### Passo a Passo

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/seu-usuario/cisound.git
   cd cisound
   ```

2. **Instale as dependências:**

   ```bash
   flutter pub get
   ```

3. **Configure as Variáveis de Ambiente:**

   Como o projeto utiliza o pacote `flutter_dotenv`, é necessário criar o arquivo `.env` na raiz do projeto contendo as suas credenciais.

   ```env
   # Arquivo .env
   API_KEY=sua_chave_aqui
   BASE_URL=https://ws.audioscrobbler.com/2.0/
   ```

4. **Gere os TypeAdapters do Hive:**

   Para garantir o funcionamento da persistência de dados, execute o build runner para criar os arquivos `.g.dart`:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Gere a Splash Screen e os Ícones (Opcional):**

   ```bash
   flutter pub run flutter_native_splash:create
   flutter pub run flutter_launcher_icons
   ```

6. **Execute o aplicativo:**

   ```bash
   flutter run
   ```
