import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/employee_model.dart';

/// Controller to fetch and manage the list of employees via Supabase
class EmployeeController extends GetxController {
  final _supabase = Supabase.instance.client;

  /// Reactive list of employees loaded from Supabase
  final employees = <EmployeeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  /// Fetches all employees in the 'funcionarios' table
  Future<void> fetchEmployees() async {
    try {
      // Performs the select and returns a List<dynamic>
      final data = await _supabase
          .from('funcionarios')
          .select('nome, matricula') as List<dynamic>;

      // Map each item into EmployeeModel
      employees.value = data
          .map((e) => EmployeeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      // Handle fetch errors
      print('Erro ao buscar funcionários: $error');
    }
  }
}
