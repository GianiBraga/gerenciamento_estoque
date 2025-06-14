import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee_controller.dart';
import '../../model/employee_model.dart';

/// Modal to search for an employee by name or matricula.
/// Returns the selected employee's matricula back to the calling screen.
class EmployeeSearchModal extends StatefulWidget {
  final void Function(String matriculaSelecionada) onSelect;

  const EmployeeSearchModal({super.key, required this.onSelect});

  @override
  State<EmployeeSearchModal> createState() => _EmployeeSearchModalState();
}

class _EmployeeSearchModalState extends State<EmployeeSearchModal> {
  final EmployeeController controller = Get.find();
  final TextEditingController searchController = TextEditingController();

  List<EmployeeModel> resultados = [];

  @override
  void initState() {
    super.initState();
    resultados = controller.employees;
    searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = searchController.text.toLowerCase();
    setState(() {
      resultados = controller.employees.where((e) {
        return e.nome.toLowerCase().contains(query) ||
            e.matricula.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1C4C9C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Buscar Funcionário',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Fechar',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar',
                  hintText: 'Nome ou matrícula',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final funcionario = resultados[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(funcionario.nome),
                    subtitle: Text('Matrícula: ${funcionario.matricula}'),
                    onTap: () {
                      widget.onSelect(funcionario.matricula);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
