
#  Módulo Dashboard (HomePage)

Este módulo exibe uma visão geral do sistema, com foco na **identificação de produtos com estoque baixo** e **saudação personalizada ao usuário logado**.


## Localização do módulo

```bash
lib/
└── features/
    └── dashboard/
        └── view/
            └── home_page.dart
```



## Funcionalidades

- Saudação com nome do usuário logado
- Listagem reativa de produtos com quantidade menor ou igual a 5
- Detecção automática de estoque crítico com destaque visual
- Botão de logout (limpa a sessão e redireciona para a tela de login)
- Layout responsivo com `ListView` e `Card`



##  Integração com GetX

Este módulo **reutiliza o `ProductController`** já registrado globalmente via GetX. Ele acessa:

```
final ProductController controller = Get.find();
```

E utiliza o `Obx()` para observar mudanças na lista de produtos:

```
Obx(() {
  final produtosCriticos = controller.products
      .where((p) => p.quantidade <= 5)
      .toList();
  return ListView(...);
})
```


## Sessão do Usuário

O nome do usuário é carregado da sessão armazenada localmente com `SharedPreferences`, via:

```
final name = await UserSessionUtil.getUserName();
```



##  Dependências utilizadas

- GetX (gerenciamento de estado e navegação)
- SharedPreferences (sessão local)
- Widgets customizados: `decoration.dart`, `user_session_util.dart`




