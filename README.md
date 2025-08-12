# Rick and Morty App

Aplicativo Flutter que consome a [API do Rick and Morty](https://rickandmortyapi.com/api) para exibir personagens, localizações e episódios da série.

## Arquitetura e Padrões

### **Padrão Arquitetural: Repository Pattern**

O projeto foi desenvolvido seguindo o **Repository Pattern**, uma arquitetura que separa a lógica de negócio da fonte de dados, proporcionando:

- **Separação de Responsabilidades**: Cada camada tem uma responsabilidade específica
- **Testabilidade**: Fácil de criar testes unitários e de integração
- **Manutenibilidade**: Código organizado e fácil de manter
- **Extensibilidade**: Fácil de adicionar novas funcionalidades
- **Independência de Framework**: Lógica de negócio independente do Flutter

### **Estrutura de Pastas**

lib/
├── models/                    # Modelos de dados (Entidades)
│   ├── character.dart        # Modelo Character
│   ├── location.dart         # Modelo Location
│   └── episode.dart          # Modelo Episode
├── repositories/             # Camada de acesso a dados
│   ├── base_repository.dart  # Interface base para todos os repos
│   ├── character_repository.dart
│   ├── location_repository.dart
│   └── episode_repository.dart
└── main.dart                 # Ponto de entrada da aplicação


### **Camadas da Arquitetura**

#### **1. Presentation Layer (UI)**
- **Responsabilidade**: Interface do usuário e interações
- **Arquivos**: main.dart
- **Padrões**: Material Design, StatefulWidget

#### **2. Business Logic Layer (Repository)**
- **Responsabilidade**: Lógica de negócio e acesso a dados
- **Arquivos**: repositories/*.dart
- **Padrões**: Repository Pattern, Interface Segregation

#### **3. Data Layer (Models)**
- **Responsabilidade**: Estrutura de dados e serialização
- **Arquivos**: models/*.dart
- **Padrões**: Data Classes, JSON Serialization

## Tecnologias e Dependências

### **HTTP Client: DIO**
- **Versão**: ^5.9.0
- **Vantagens**:
  - Melhor tratamento de erros que HTTP nativo
  - Interceptors para logging e autenticação
  - Timeout configurável
  - Suporte a FormData e uploads
  - Cancelamento de requisições

### **Outras Dependências**
- **http**: ^1.1.0 (fallback para operações simples)
- **cupertino_icons**: ^1.0.8 (ícones iOS)
- **google_fonts**: ^6.3.0 (tipografia personalizada)

## Funcionalidades Implementadas

### **CharacterRepository**
- getAll() - Listar todos os personagens
- getById(id) - Buscar personagem por ID
- search(query) - Buscar por nome
- getCharactersByStatus(status) - Filtrar por status
- getCharactersBySpecies(species) - Filtrar por espécie
- getCharactersByGender(gender) - Filtrar por gênero
- getMultipleCharacters(ids) - Buscar múltiplos por IDs
- getCharactersWithPagination(page) - Paginação

### **LocationRepository**
- getAll() - Listar todas as localizações
- getById(id) - Buscar localização por ID
- search(query) - Buscar por nome
- getLocationsByType(type) - Filtrar por tipo
- getLocationsByDimension(dimension) - Filtrar por dimensão
- getLocationsWithPagination(page) - Paginação

### **EpisodeRepository**
- getAll() - Listar todos os episódios
- getById(id) - Buscar episódio por ID
- search(query) - Buscar por nome
- getEpisodesByCode(code) - Filtrar por código (S01E01)
- getMultipleEpisodes(ids) - Buscar múltiplos por IDs
- getEpisodesWithPagination(page) - Paginação

## Padrões de Design Utilizados

### **1. Repository Pattern**
dart
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<List<T>> search(String query);
}


### **2. Interface Segregation Principle**
- Cada repositório implementa apenas os métodos necessários
- Interfaces específicas para cada tipo de entidade

### **3. Dependency Injection**
- Repositórios são instanciados onde são necessários
- Fácil de substituir implementações para testes

### **4. Error Handling**
- Tratamento específico para cada tipo de erro da API
- Mensagens de erro amigáveis para o usuário
- Fallbacks para situações de falha

### **5. Async/Await Pattern**
- Uso consistente de operações assíncronas
- Loading states para melhor UX
- Tratamento de erros em operações assíncronas

## Como Executar

### **Pré-requisitos**
- Flutter SDK 3.8.1+
- Dart 3.8.1+
- Dependências instaladas

### **Instalação**
bash
# Clonar o projeto
git clone [url-do-repositorio]

# Entrar na pasta
cd rick_and_morty

# Instalar dependências
flutter pub get

# Executar o aplicativo
flutter run


### **Plataformas Suportadas**
- Web (Chrome, Firefox, Safari)
- macOS (requer CocoaPods)
- iOS (requer CocoaPods)
- Android (requer Android SDK)
- Linux
- Windows

## Testes

### **Estrutura de Testes Recomendada**
test/
├── unit/
│   ├── repositories/
│   └── models/
├── widget/
└── integration/


### **Exemplo de Teste Unitário**
dart
void main() {
  group('CharacterRepository', () {
    test('should return list of characters when getAll is called', () async {
      // Arrange
      final repository = CharacterRepository();
      
      // Act
      final result = await repository.getAll();
      
      // Assert
      expect(result, isA<List<Character>>());
      expect(result.isNotEmpty, true);
    });
  });
}


## Tratamento de Erros

### **Tipos de Erro Tratados**
- **Connection Timeout**: "Timeout de conexão. Verifique sua internet."
- **Receive Timeout**: "Timeout ao receber dados."
- **404 Not Found**: "Item não encontrado."
- **500 Server Error**: "Erro interno do servidor."
- **Network Errors**: "Erro de rede: [mensagem]"

### **Estratégias de Fallback**
- Retry automático para erros de rede
- Cache local para dados offline
- Mensagens de erro amigáveis
- Loading states para feedback visual

## Recursos e Referências

- [Flutter Documentation](https://docs.flutter.dev/)
- [DIO Package](https://pub.dev/packages/dio)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Rick and Morty API](https://rickandmortyapi.com/documentation)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)