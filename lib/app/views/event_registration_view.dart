import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../models/event_registration_model.dart';

class EventRegistrationView extends StatefulWidget {
  final Event event;

  const EventRegistrationView({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventRegistrationView> createState() => _EventRegistrationViewState();
}

class _EventRegistrationViewState extends State<EventRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _collegeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    _collegeController.dispose();
    _departmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('تسجيل الحضور'),
        backgroundColor: widget.event.categoryColor,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Info Card
              _buildEventInfoCard(),
              
              SizedBox(height: 24.h),
              
              // Registration Form
              _buildRegistrationForm(),
              
              SizedBox(height: 24.h),
              
              // Submit Button
              _buildSubmitButton(),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: widget.event.categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.event.categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                color: widget.event.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات الفعالية',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.event.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.event.dateRange,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.event.location,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات التسجيل',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Full Name
        _buildTextField(
          controller: _fullNameController,
          label: 'الاسم الكامل',
          hint: 'أدخل اسمك الكامل',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الاسم الكامل مطلوب';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // Email
        _buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          hint: 'example@email.com',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'البريد الإلكتروني مطلوب';
            }
            if (!GetUtils.isEmail(value)) {
              return 'البريد الإلكتروني غير صحيح';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // Phone Number
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          hint: '07xxxxxxxx',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'رقم الهاتف مطلوب';
            }
            if (value.length < 10) {
              return 'رقم الهاتف قصير جداً';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // Student ID
        _buildTextField(
          controller: _studentIdController,
          label: 'رقم الطالب',
          hint: 'أدخل رقمك الجامعي',
          icon: Icons.badge,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'رقم الطالب مطلوب';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // College
        _buildTextField(
          controller: _collegeController,
          label: 'الكلية',
          hint: 'أدخل اسم الكلية',
          icon: Icons.school,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الكلية مطلوبة';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // Department
        _buildTextField(
          controller: _departmentController,
          label: 'القسم',
          hint: 'أدخل اسم القسم',
          icon: Icons.account_balance,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'القسم مطلوب';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16.h),
        
        // Notes
        _buildTextField(
          controller: _notesController,
          label: 'ملاحظات (اختياري)',
          hint: 'أي ملاحظات إضافية...',
          icon: Icons.note,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: widget.event.categoryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.textHint),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.textHint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: widget.event.categoryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _submitRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.event.categoryColor,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
        child: Text(
          'تسجيل الحضور',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      // Create registration object
      final registration = EventRegistration(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        eventId: widget.event.id,
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        studentId: _studentIdController.text,
        college: _collegeController.text,
        department: _departmentController.text,
        registrationDate: DateTime.now(),
        status: RegistrationStatus.pending,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // TODO: Save registration to database or send to server
      print('Registration submitted: ${registration.id}');

      // Show success message
      Get.snackbar(
        'تم التسجيل بنجاح',
        'تم تسجيلك في الفعالية بنجاح. ستتلقى تأكيداً قريباً.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: AppColors.textOnPrimary,
        duration: Duration(seconds: 3),
      );

      // Close the registration form
      Get.back();
    }
  }
}
