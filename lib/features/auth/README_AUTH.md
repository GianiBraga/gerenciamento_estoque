
# Módulo Auth (Autenticação)

Este módulo é responsável pelo login de usuários na aplicação, utilizando **Supabase Auth** integrado ao padrão **MVVM com GetX**.



## Estrutura do módulo

```
lib/
└── features/
    └── auth/
        ├── controller/
        │   └── login_controller.dart
        └── view/
            └── login_page.dart
```


##  Funcionalidades

- Login com e-mail e senha via Supabase
- Validação de campos e mensagens de erro personalizadas
- Armazenamento do nome do usuário com `SharedPreferences`
- Redirecionamento para `MenuPage` com animação
- Uso de feedback visual com `SnackbarUtil`



##  Integração com GetX

O controller é registrado no início da aplicação com:

```
initialBinding: BindingsBuilder(() {
  Get.put(LoginController());
})
```

A `LoginPage` usa `GetView<LoginController>` e integra diretamente os campos e botões:

```
controller.emailController.text
controller.login()
```



##  Tabela Supabase: `usuarios`

| Campo  | Tipo   | Descrição               |
|--------|--------|--------------------------|
| `id`   | uuid   | ID igual ao de autenticação |
| `nome` | text   | Nome do usuário          |

> A busca é feita via `.from('usuarios').select('nome').eq('id', userId).single()`



## Dependências utilizadas

- GetX (estado e navegação)
- Supabase (auth + banco)
- SharedPreferences (sessão)
- Widgets: `decoration.dart`, `snackbar_util.dart`, `page_transition_util.dart`, `user_session_util.dart`


