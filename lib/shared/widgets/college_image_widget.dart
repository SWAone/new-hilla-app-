import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/college_model.dart';
import '../../core/theme/app_colors.dart';

class CollegeImageWidget extends StatelessWidget {
  final College college;
  final double width;
  final double height;

  const CollegeImageWidget({
    Key? key,
    required this.college,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: college.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Background Image or Gradient
            Positioned.fill(
              child: college.imageUrl != null && college.imageUrl!.isNotEmpty
                  ? Image.network(
                      college.imageUrl!,
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      cacheHeight: 400,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                college.primaryColor,
                                college.secondaryColor,
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: CollegePatternPainter(
                              primaryColor: college.primaryColor,
                              secondaryColor: college.secondaryColor,
                              patternType: _getPatternType(college.iconPath),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                college.primaryColor,
                                college.secondaryColor,
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.textOnPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            college.primaryColor,
                            college.secondaryColor,
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: CollegePatternPainter(
                          primaryColor: college.primaryColor,
                          secondaryColor: college.secondaryColor,
                          patternType: _getPatternType(college.iconPath),
                        ),
                      ),
                    ),
            ),
            
            // Dark Overlay for better text visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            
            // Icon (always show as fallback)
            Center(
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getCollegeIcon(college.iconPath),
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
            
            // Department Count Badge
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${college.departments.length}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: college.primaryColor,
                  ),
                ),
              ),
            ),
            
            // College Initials
            Positioned(
              bottom: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  _getCollegeInitials(college.name),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCollegeIcon(String iconPath) {
    switch (iconPath) {
      case 'medical':
        return Icons.medical_services_rounded;
      case 'engineering':
        return Icons.engineering_rounded;
      case 'pharmacy':
        return Icons.medication_rounded;
      case 'dentistry':
        return Icons.health_and_safety_rounded;
      case 'nursing':
        return Icons.local_hospital_rounded;
      case 'management':
        return Icons.business_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _getCollegeInitials(String collegeName) {
    List<String> words = collegeName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}';
    } else if (words.isNotEmpty) {
      return words[0].substring(0, 2);
    }
    return 'كل';
  }

  PatternType _getPatternType(String iconPath) {
    switch (iconPath) {
      case 'medical':
        return PatternType.medical;
      case 'engineering':
        return PatternType.engineering;
      case 'pharmacy':
        return PatternType.pharmacy;
      case 'dentistry':
        return PatternType.dentistry;
      case 'nursing':
        return PatternType.nursing;
      case 'management':
        return PatternType.management;
      default:
        return PatternType.general;
    }
  }
}

enum PatternType {
  medical,
  engineering,
  pharmacy,
  dentistry,
  nursing,
  management,
  general,
}

class CollegePatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final PatternType patternType;

  CollegePatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.patternType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textOnPrimary.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    switch (patternType) {
      case PatternType.medical:
        _drawMedicalPattern(canvas, size, paint);
        break;
      case PatternType.engineering:
        _drawEngineeringPattern(canvas, size, paint);
        break;
      case PatternType.pharmacy:
        _drawPharmacyPattern(canvas, size, paint);
        break;
      case PatternType.dentistry:
        _drawDentistryPattern(canvas, size, paint);
        break;
      case PatternType.nursing:
        _drawNursingPattern(canvas, size, paint);
        break;
      case PatternType.management:
        _drawManagementPattern(canvas, size, paint);
        break;
      default:
        _drawGeneralPattern(canvas, size, paint);
    }
  }

  void _drawMedicalPattern(Canvas canvas, Size size, Paint paint) {
    // Cross pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final crossSize = size.width * 0.3;
    
    canvas.drawLine(
      Offset(centerX - crossSize, centerY),
      Offset(centerX + crossSize, centerY),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, centerY - crossSize),
      Offset(centerX, centerY + crossSize),
      paint,
    );
  }

  void _drawEngineeringPattern(Canvas canvas, Size size, Paint paint) {
    // Gear pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.2;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  void _drawPharmacyPattern(Canvas canvas, Size size, Paint paint) {
    // Pill pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final pillWidth = size.width * 0.4;
    final pillHeight = size.width * 0.15;
    
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: pillWidth,
        height: pillHeight,
      ),
      Radius.circular(pillHeight / 2),
    );
    canvas.drawRRect(rect, paint);
  }

  void _drawDentistryPattern(Canvas canvas, Size size, Paint paint) {
    // Tooth pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final toothSize = size.width * 0.2;
    
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: toothSize,
      height: toothSize * 1.2,
    ));
    canvas.drawPath(path, paint);
  }

  void _drawNursingPattern(Canvas canvas, Size size, Paint paint) {
    // Heart pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final heartSize = size.width * 0.25;
    
    final path = Path();
    path.moveTo(centerX, centerY + heartSize);
    path.cubicTo(
      centerX - heartSize, centerY,
      centerX - heartSize * 0.5, centerY - heartSize * 0.5,
      centerX, centerY,
    );
    path.cubicTo(
      centerX + heartSize * 0.5, centerY - heartSize * 0.5,
      centerX + heartSize, centerY,
      centerX, centerY + heartSize,
    );
    canvas.drawPath(path, paint);
  }

  void _drawManagementPattern(Canvas canvas, Size size, Paint paint) {
    // Chart pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final barWidth = size.width * 0.1;
    final barHeight = size.height * 0.3;
    
    for (int i = 0; i < 3; i++) {
      final x = centerX - barWidth + (i * barWidth);
      final height = barHeight * (0.5 + (i * 0.2));
      canvas.drawRect(
        Rect.fromLTWH(x, centerY - height / 2, barWidth * 0.6, height),
        paint,
      );
    }
  }

  void _drawGeneralPattern(Canvas canvas, Size size, Paint paint) {
    // Simple dots pattern
    final spacing = size.width * 0.15;
    
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

