import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/college_model.dart';
import '../../models/college_api.dart' as api;
import '../../data/colleges_repository.dart';

class CollegeController extends BaseController {
  final RxList<College> colleges = <College>[].obs;
  final RxList<College> filteredColleges = <College>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  final CollegesRepository _repository = CollegesRepository();

  @override
  void onInit() {
    super.onInit();
    loadColleges();
  }

  Future<void> loadColleges() async {
    try {
      setLoading(true);
      clearError();
      
      final paginatedColleges = await _repository.fetchColleges(
        page: 1,
        limit: 100, // جلب عدد كبير للحصول على جميع الكليات
      );
      
      colleges.assignAll(paginatedColleges.colleges.map(_convertToCollege).toList());
      filteredColleges.value = colleges;
      
    } catch (e) {
      debugPrint('Error fetching colleges: $e');
      setError('فشل في تحميل الكليات: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الكليات');
    } finally {
      setLoading(false);
    }
  }

  College _convertToCollege(api.CollegeApi apiCollege) {
    return College(
      id: apiCollege.id,
      name: apiCollege.name,
      description: apiCollege.description,
      iconPath: apiCollege.iconPath,
      imageUrl: apiCollege.imageUrl ?? '',
      primaryColor: _parseColor(apiCollege.primaryColor),
      secondaryColor: _parseColor(apiCollege.secondaryColor),
      departments: apiCollege.departments.map(_convertToDepartment).toList(),
      facultyMembers: apiCollege.facultyMembers.map(_convertToFacultyMember).toList(),
      admissionGuide: _convertToAdmissionGuide(apiCollege.admissionGuide),
    );
  }

  Department _convertToDepartment(api.DepartmentApi apiDept) {
    return Department(
      id: apiDept.id,
      name: apiDept.name,
      description: apiDept.description,
      studentCount: apiDept.studentCount,
      degree: apiDept.degree,
      subjects: apiDept.subjects,
    );
  }

  FacultyMember _convertToFacultyMember(api.FacultyMemberApi apiMember) {
    return FacultyMember(
      id: apiMember.id,
      name: apiMember.name,
      title: apiMember.title,
      specialization: apiMember.specialization,
      bio: apiMember.bio,
      imageUrl: apiMember.imageUrl ?? '',
      email: apiMember.email,
      qualifications: apiMember.qualifications,
      experienceYears: apiMember.experienceYears,
      researchAreas: apiMember.researchAreas,
    );
  }

  AdmissionGuide _convertToAdmissionGuide(api.AdmissionGuideApi apiGuide) {
    return AdmissionGuide(
      requiredGPA: apiGuide.requiredGPA,
      requirements: apiGuide.requirements,
      documents: apiGuide.documents.map(_convertToAdmissionDocument).toList(),
      additionalInfo: apiGuide.additionalInfo,
    );
  }

  AdmissionDocument _convertToAdmissionDocument(api.AdmissionDocumentApi apiDoc) {
    return AdmissionDocument(
      name: apiDoc.name,
      type: apiDoc.type,
      downloadUrl: apiDoc.downloadUrl,
      description: apiDoc.description,
    );
  }

  Color _parseColor(String colorHex) {
    try {
      // إزالة # إذا كانت موجودة
      final hex = colorHex.replaceAll('#', '');
      // تحويل من hex string إلى int ثم إلى Color
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      debugPrint('Error parsing color: $colorHex, error: $e');
      return const Color(0xFF1976D2); // لون افتراضي
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

