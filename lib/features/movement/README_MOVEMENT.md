
# Módulo Movement (Entrada e Saída de Produtos)

Este módulo permite registrar movimentações de **entrada** e **saída** de produtos no estoque. Ele segue o padrão **MVVM com GetX** e se comunica com o Supabase para armazenar os registros.


## Estrutura do módulo

```
lib/
└── features/
    └── movement/
        ├── controller/
        │   └── movement_controller.dart
        ├── data/
        │   └── movement_service.dart
        ├── model/
        │   └── movement_model.dart
        └── view/
            └── in_out_page.dart
```



##  Funcionalidades

- Cadastro de movimentações (Entrada ou Saída)
- Formulário com validação
- Seleção de tipo (Entrada / Saída)
- Controle de sessão e usuário vinculado
- Integração com Supabase (`movimentacoes`)
- GetX para gerenciamento de estado e injeção



##  Integração com GetX

A tela `InOutPage` usa `GetView<MovementController>` com campos reativos como:

```
Obx(() => DropdownButtonFormField(
  value: controller.tipoMovimentacao.value,
  onChanged: (value) => controller.tipoMovimentacao.value = value!,
))
```

E executa:

```
controller.saveMovement();
```

---

##  Tabela Supabase esperada: `movimentacoes`

| Campo           | Tipo       | Obrigatório | Descrição                         |
|-----------------|------------|-------------|------------------------------------|
| `id`            | int (PK)   | Sim         | Identificador da movimentação      |
| `codigo_produto`| text       | Sim         | Código informado do produto        |
| `quantidade`    | integer    | Sim         | Quantidade movimentada             |
| `tipo`          | text       | Sim         | Entrada ou Saída                   |
| `data`          | timestamp  | Sim         | Data/hora da movimentação          |
| `usuario_id`    | uuid       | Não         | ID do usuário que executou a ação  |

