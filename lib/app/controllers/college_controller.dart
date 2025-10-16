import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/college_model.dart';
import '../../data/college_data.dart';

class CollegeController extends BaseController {
  final RxList<College> colleges = <College>[].obs;
  final RxList<College> filteredColleges = <College>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadColleges();
  }

  Future<void> loadColleges() async {
    try {
      setLoading(true);
      clearError();
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      colleges.value = CollegeData.getColleges();
      filteredColleges.value = colleges;
      
    } catch (e) {
      setError('فشل في تحميل الكليات: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الكليات');
    } finally {
      setLoading(false);
    }
  }

  void searchColleges(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
    
    if (query.isEmpty) {
      filteredColleges.value = colleges;
    } else {
      filteredColleges.value = colleges.where((college) {
        return college.name.toLowerCase().contains(query.toLowerCase()) ||
               college.description.toLowerCase().contains(query.toLowerCase()) ||
               college.departments.any((dept) => 
                 dept.name.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
    filteredColleges.value = colleges;
  }

  College? getCollegeById(String id) {
    try {
      return colleges.firstWhere((college) => college.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Department> getDepartmentsByCollegeId(String collegeId) {
    final college = getCollegeById(collegeId);
    return college?.departments ?? [];
  }
}

