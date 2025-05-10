
# Módulo Menu (Navegação Principal)

Este módulo representa a tela principal da aplicação, com uma navegação inferior (`CurvedNavigationBar`) que permite alternar entre os módulos de **Produtos**, **Dashboard** (Home) e **Movimentações**.



##  Estrutura do módulo

```
lib/
└── features/
    └── menu/
        └── menu_page.dart
```

---

##  Funcionalidades

- Navegação por abas com ícones
- Integração com:
  - `ProductListPage`
  - `HomePage`
  - `InOutPage`
- Registro dos controllers (`ProductController` e `MovementController`) caso ainda não estejam ativos



##  Integração com GetX

A `MenuPage` garante que os controllers estejam prontos ao iniciar:

```
if (!Get.isRegistered<ProductController>()) {
  Get.put(ProductController());
}
```

O índice da página ativa é controlado via `setState`, e as páginas são exibidas conforme a posição do `CurvedNavigationBar`.
