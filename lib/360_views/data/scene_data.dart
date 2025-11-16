import 'package:flutter/material.dart';
import '../models/tour_scene.dart';

/// Provides all tour scenes data.
class SceneData {
  /// Builds and returns all available tour scenes.
  static Map<String, TourScene> buildScenes() {
    return {
      'gate': TourScene(
        id: 'gate',
        name: 'بوابة جامعة الحلة',
        assetPath: 'assets/1.jpg',
        hotspots: [
          const TourHotspot(
            yaw: 0,
            pitch: -5,
            targetSceneId: 'hall',
            iconColor: Colors.redAccent,
            tooltip: 'Enter Main Hall',
          ),
          TourHotspot(
            yaw: -20,
            pitch: -10,
            targetSceneId: 'gate',
            iconColor: Colors.white,
            width: 260,
            height: 190,
            widget: SizedBox(
              width: 240,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'جامعة الحلة - نبذة سريعة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• تأسست عام 2010 في مدينة الحلة.\n'
                        '• تضم أكثر من 20 كلية ومركزاً بحثياً.\n'
                        '• تركز على الابتكار والبحث العلمي وخدمة المجتمع.\n'
                        '• تطمح لتخريج قيادات تسهم في نهضة العراق.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      'hall': TourScene(
        id: 'hall',
        name: 'سنترال بناية حمورابي',
        assetPath: 'assets/2.jpg',
        hotspots: const [
          TourHotspot(
            yaw: 30,
            pitch: -10,
            targetSceneId: 'presdnt',
            iconColor: Color.fromARGB(255, 13, 111, 124),
            tooltip: 'Return to Gate',
          ),
        ],
      ),
      'presdnt': TourScene(
        id: 'library',
        name: 'ممر الرئاسة',
        assetPath: 'assets/3.jpg',
        hotspots: [
          const TourHotspot(
            yaw: -70,
            pitch: -5,
            targetSceneId: 'enterPresdnt',
            iconColor: Colors.blueAccent,
            tooltip: 'Back to Hall',
          ),
          TourHotspot(
            yaw: 50,
            pitch: -4,
            targetSceneId: 'library',
            iconColor: const Color(0xFF50E3C2),
            width: 280,
            height: 300,
            widget: SizedBox(
              width: 280,
              height: 370,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0F2027).withOpacity(0.85),
                      const Color(0xFF203A43).withOpacity(0.85),
                      const Color(0xFF2C5364).withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.22),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF56CCF2),
                                  Color(0xFF2F80ED),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'معرفة القصد الدراسي',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'أدخل بياناتك لمعرفة كم متبقي عليك',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 0.8,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الاسم الثلاثي',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'مثال: علي أحمد حسين',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.08),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 0.8,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.12),
                                      width: 0.6,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF56CCF2),
                                      width: 1.2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF56CCF2),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            shadowColor: Colors.cyanAccent.withOpacity(0.35),
                          ),
                          onPressed: () {
                            debugPrint('Hello');
                          },
                          child: const Text(
                            'الحصول على القصد الدراسي',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      'enterPresdnt': TourScene(
        id: 'cafeteria',
        name: 'نادي الجامعة',
        assetPath: 'assets/enterpr.jpg',
        hotspots: const [
          TourHotspot(
            yaw: -90,
            pitch: -5,
            targetSceneId: 'abadhem',
            iconColor: Colors.blueAccent,
            tooltip: 'Grab a book',
          ),
        ],
      ),
      'abadhem': TourScene(
        id: 'abadhem',
        name: 'الأبدهم',
        assetPath: 'assets/abadhem.jpg',
        hotspots: const [
          TourHotspot(
            yaw: 90,
            pitch: -5,
            targetSceneId: 'gate',
            iconColor: Colors.orange,
            tooltip: 'Return to Gate',
          ),
        ],
      ),
    };
  }
}

