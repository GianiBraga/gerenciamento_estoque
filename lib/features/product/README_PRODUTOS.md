
#  Módulo `Produtos`

Este módulo é responsável pelo **cadastro, listagem, edição e exclusão de produtos** na aplicação, integrando com o Supabase como backend e utilizando o padrão **MVVM** com **GetX** como gerenciador de estado.


##  Estrutura de pastas

```
lib/
└── features/
    └── product/
        ├── controller/
        │   └── product_controller.dart
        ├── data/
        │   └── product_service.dart
        ├── model/
        │   └── product_model.dart
        └── view/
            ├── product_list_page.dart
            └── widgets/
                └── product_form.dart
```


##  Arquitetura aplicada

| Camada       | Responsabilidade                                                                 |
|--------------|-----------------------------------------------------------------------------------|
| **Model**    | Representa os dados da entidade `ProductModel`, com conversões `fromMap/toMap`.  |
| **View**     | Interface com o usuário (listagem e formulário), usando `Obx` para reatividade.   |
| **Controller** | Gerencia o estado e as ações: salvar, excluir, atualizar e carregar produtos.   |
| **Service**  | Faz a ponte com o Supabase, realizando as operações de banco de dados.            |



##  Funcionalidades implementadas

- [x] Listagem de produtos com animação e busca
- [x] Cadastro de produto com imagem
- [x] Edição de produto com preenchimento do formulário
- [x] Exclusão com confirmação
- [x] Upload de imagem no Supabase Storage
- [x] Controle de estado via GetX (reactivo)
- [x] Filtros reativos com `RxString filtro`



##  Como usar

1. **Registrar o controller** no início da aplicação:

```
void main() {
  runApp(
    GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController());
      }),
      home: ProductListPage(),
    ),
  );
}
```

2. **Exibir a lista de produtos**:

```dart
const ProductListPage();
```

3. **Formulário é aberto via `Dialog`** para **cadastro** ou **edição**, já integrado com o controller.


##  Campos utilizados no Supabase

A tabela `produtos` deve conter as colunas:

| Campo          | Tipo       | Obrigatório | Descrição                    |
|----------------|------------|-------------|------------------------------|
| `id`           | int        | Sim (PK)    | Identificador único          |
| `codigo`       | text       | Sim         | Código do produto            |
| `nome`         | text       | Sim         | Nome do produto              |
| `valor`        | numeric    | Sim         | Valor unitário               |
| `categoria`    | text       | Sim         | Categoria do produto         |
| `quantidade`   | int        | Sim         | Estoque atual                |
| `descricao`    | text       | Não         | Descrição adicional          |
| `validade`     | text/date  | Não         | Data de validade             |
| `imagem_url`   | text       | Não         | URL da imagem (pública)      |


