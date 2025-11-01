class CollegeApi {
  const CollegeApi({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.imageUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.departments,
    required this.facultyMembers,
    required this.admissionGuide,
  });

  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String? imageUrl;
  final String primaryColor;
  final String secondaryColor;
  final List<DepartmentApi> departments;
  final List<FacultyMemberApi> facultyMembers;
  final AdmissionGuideApi admissionGuide;

  static CollegeApi fromJson(Map<String, dynamic> json) {
    return CollegeApi(
      id: (json['_id'] ?? json['id']).toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      iconPath: (json['iconPath'] ?? 'school').toString(),
      imageUrl: json['imageUrl']?.toString(),
      primaryColor: (json['primaryColor'] ?? '#1976D2').toString(),
      secondaryColor: (json['secondaryColor'] ?? '#42A5F5').toString(),
      departments: json['departments'] is List
          ? (json['departments'] as List)
              .map((e) => DepartmentApi.fromJson(e as Map<String, dynamic>))
              .toList()
          : <DepartmentApi>[],
      facultyMembers: json['facultyMembers'] is List
          ? (json['facultyMembers'] as List)
              .map((e) => FacultyMemberApi.fromJson(e as Map<String, dynamic>))
              .toList()
          : <FacultyMemberApi>[],
      admissionGuide: json['admissionGuide'] != null
          ? AdmissionGuideApi.fromJson(json['admissionGuide'] as Map<String, dynamic>)
          : AdmissionGuideApi.empty(),
    );
  }
}

class DepartmentApi {
  const DepartmentApi({
    required this.id,
    required this.name,
    required this.description,
    required this.studentCount,
    required this.degree,
    required this.subjects,
  });

  final String id;
  final String name;
  final String description;
  final int studentCount;
  final String degree;
  final List<String> subjects;

  static DepartmentApi fromJson(Map<String, dynamic> json) {
    return DepartmentApi(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      studentCount: json['studentCount'] is int
          ? json['studentCount'] as int
          : int.tryParse('${json['studentCount'] ?? 0}') ?? 0,
      degree: (json['degree'] ?? 'بكالوريوس').toString(),
      subjects: json['subjects'] is List
          ? (json['subjects'] as List).map((e) => e.toString()).toList()
          : <String>[],
    );
  }
}

class FacultyMemberApi {
  const FacultyMemberApi({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
    required this.bio,
    required this.imageUrl,
    required this.email,
    required this.qualifications,
    required this.experienceYears,
    required this.researchAreas,
  });

  final String id;
  final String name;
  final String title;
  final String specialization;
  final String bio;
  final String? imageUrl;
  final String email;
  final List<String> qualifications;
  final int experienceYears;
  final List<String> researchAreas;

  static FacultyMemberApi fromJson(Map<String, dynamic> json) {
    return FacultyMemberApi(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      email: (json['email'] ?? '').toString(),
      qualifications: json['qualifications'] is List
          ? (json['qualifications'] as List).map((e) => e.toString()).toList()
          : <String>[],
      experienceYears: json['experienceYears'] is int
          ? json['experienceYears'] as int
          : int.tryParse('${json['experienceYears'] ?? 0}') ?? 0,
      researchAreas: json['researchAreas'] is List
          ? (json['researchAreas'] as List).map((e) => e.toString()).toList()
          : <String>[],
    );
  }
}

class AdmissionGuideApi {
  const AdmissionGuideApi({
    required this.requiredGPA,
    required this.requirements,
    required this.documents,
    required this.additionalInfo,
  });

  final double requiredGPA;
  final List<String> requirements;
  final List<AdmissionDocumentApi> documents;
  final String additionalInfo;

  static AdmissionGuideApi fromJson(Map<String, dynamic> json) {
    return AdmissionGuideApi(
      requiredGPA: json['requiredGPA'] is num
          ? (json['requiredGPA'] as num).toDouble()
          : double.tryParse('${json['requiredGPA'] ?? 0}') ?? 0.0,
      requirements: json['requirements'] is List
          ? (json['requirements'] as List).map((e) => e.toString()).toList()
          : <String>[],
      documents: json['documents'] is List
          ? (json['documents'] as List)
              .map((e) => AdmissionDocumentApi.fromJson(e as Map<String, dynamic>))
              .toList()
          : <AdmissionDocumentApi>[],
      additionalInfo: (json['additionalInfo'] ?? '').toString(),
    );
  }

  static AdmissionGuideApi empty() {
    return const AdmissionGuideApi(
      requiredGPA: 0.0,
      requirements: <String>[],
      documents: <AdmissionDocumentApi>[],
      additionalInfo: '',
    );
  }
}

class AdmissionDocumentApi {
  const AdmissionDocumentApi({
    required this.id,
    required this.name,
    required this.type,
    required this.downloadUrl,
    required this.description,
  });

  final String id;
  final String name;
  final String type;
  final String downloadUrl;
  final String description;

  static AdmissionDocumentApi fromJson(Map<String, dynamic> json) {
    return AdmissionDocumentApi(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? 'pdf').toString(),
      downloadUrl: (json['downloadUrl'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
    );
  }
}

class PaginatedColleges {
  const PaginatedColleges({
    required this.colleges,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<CollegeApi> colleges;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  static PaginatedColleges fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = json['meta'] ?? const {};
    final pagination = meta['pagination'] ?? const {};
    
    final colleges = data is List
        ? data.map<CollegeApi>((e) => CollegeApi.fromJson(e as Map<String, dynamic>)).toList()
        : <CollegeApi>[];

    return PaginatedColleges(
      colleges: colleges,
      page: pagination['currentPage'] is int
          ? pagination['currentPage'] as int
          : int.tryParse('${pagination['currentPage'] ?? 1}') ?? 1,
      limit: pagination['itemsPerPage'] is int
          ? pagination['itemsPerPage'] as int
          : int.tryParse('${pagination['itemsPerPage'] ?? 10}') ?? 10,
      total: pagination['totalItems'] is int
          ? pagination['totalItems'] as int
          : int.tryParse('${pagination['totalItems'] ?? colleges.length}') ?? colleges.length,
      totalPages: pagination['totalPages'] is int
          ? pagination['totalPages'] as int
          : int.tryParse('${pagination['totalPages'] ?? 1}') ?? 1,
    );
  }
}

