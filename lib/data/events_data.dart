import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventsData {
  static List<Event> getEvents() {
    final now = DateTime.now();
    
    return [
      // Upcoming Events
      Event(
        id: '1',
        title: 'مؤتمر التكنولوجيا والابتكار 2024',
        description: 'مؤتمر سنوي يجمع الباحثين والمختصين في مجال التكنولوجيا والابتكار لمناقشة أحدث التطورات والاتجاهات المستقبلية في هذا المجال.',
        startDate: now.add(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 16)),
        location: 'قاعة المؤتمرات الرئيسية - جامعة الحلة',
        organizer: 'كلية الهندسة',
        speakers: ['د. أحمد محمد', 'د. فاطمة علي', 'د. خالد حسن'],
        type: EventType.conference,
        status: EventStatus.upcoming,
        categoryColor: const Color(0xFF1976D2),
        imageUrl: '',
        maxAttendees: 200,
        currentAttendees: 150,
        tags: ['تكنولوجيا', 'ابتكار', 'بحث', 'هندسة'],
        contactInfo: 'eng@hilla.edu.iq',
        allowRegistration: true,
        registrationDeadline: now.add(const Duration(days: 10)),
      ),
      Event(
        id: '2',
        title: 'ورشة الذكاء الاصطناعي في الطب',
        description: 'ورشة عمل متخصصة حول تطبيقات الذكاء الاصطناعي في المجال الطبي وتشخيص الأمراض باستخدام التقنيات الحديثة.',
        startDate: now.add(const Duration(days: 8)),
        endDate: now.add(const Duration(days: 8)),
        location: 'مختبر الحاسوب - كلية الطب',
        organizer: 'كلية الطب',
        speakers: ['د. سارة أحمد', 'د. محمد علي'],
        type: EventType.workshop,
        status: EventStatus.upcoming,
        categoryColor: const Color(0xFF2E7D32),
        imageUrl: '',
        maxAttendees: 50,
        currentAttendees: 35,
        tags: ['ذكاء اصطناعي', 'طب', 'تشخيص', 'تقنية'],
        contactInfo: 'med@hilla.edu.iq',
        allowRegistration: true,
        registrationDeadline: now.add(const Duration(days: 5)),
      ),
      Event(
        id: '3',
        title: 'المهرجان الثقافي السنوي',
        description: 'مهرجان ثقافي يضم عروض فنية ومسرحية ومعارض للطلاب من مختلف الكليات، يهدف إلى إبراز المواهب الطلابية.',
        startDate: now.add(const Duration(days: 22)),
        endDate: now.add(const Duration(days: 24)),
        location: 'المسرح الجامعي - جامعة الحلة',
        organizer: 'النشاط الطلابي',
        speakers: ['أ. نور الدين', 'أ. زينب محمد'],
        type: EventType.cultural,
        status: EventStatus.upcoming,
        categoryColor: const Color(0xFFD32F2F),
        imageUrl: '',
        maxAttendees: 500,
        currentAttendees: 320,
        tags: ['ثقافة', 'فنون', 'مسرح', 'طلاب'],
        contactInfo: 'culture@hilla.edu.iq',
      ),
      Event(
        id: '4',
        title: 'ندوة حول الطاقة المتجددة',
        description: 'ندوة علمية تناقش مستقبل الطاقة المتجددة في العراق والفرص المتاحة لتطوير هذا القطاع.',
        startDate: now.add(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 30)),
        location: 'قاعة المحاضرات - كلية العلوم',
        organizer: 'كلية العلوم',
        speakers: ['د. علي محمود', 'د. رنا حسن'],
        type: EventType.seminar,
        status: EventStatus.upcoming,
        categoryColor: const Color(0xFF7B1FA2),
        imageUrl: '',
        maxAttendees: 100,
        currentAttendees: 75,
        tags: ['طاقة متجددة', 'بيئة', 'علوم', 'مستقبل'],
        contactInfo: 'science@hilla.edu.iq',
      ),
      
      // Ongoing Events
      Event(
        id: '5',
        title: 'الدوري الرياضي الجامعي',
        description: 'بطولة رياضية تشمل كرة القدم، كرة السلة، والسباحة بمشاركة فرق من جميع الكليات.',
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 12)),
        location: 'الملاعب الرياضية - جامعة الحلة',
        organizer: 'النشاط الرياضي',
        speakers: ['أ. محمد حسن', 'أ. أحمد علي'],
        type: EventType.sports,
        status: EventStatus.ongoing,
        categoryColor: const Color(0xFF4CAF50),
        imageUrl: '',
        maxAttendees: 300,
        currentAttendees: 250,
        tags: ['رياضة', 'بطولة', 'طلاب', 'تنافس'],
        contactInfo: 'sports@hilla.edu.iq',
      ),
      
      // Completed Events
      Event(
        id: '6',
        title: 'حفل تخرج الدفعة الـ 45',
        description: 'حفل تخرج طلاب الدفعة الـ 45 من مختلف الكليات بحضور عائلات الطلاب وأعضاء هيئة التدريس.',
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.subtract(const Duration(days: 10)),
        location: 'القاعة الكبرى - جامعة الحلة',
        organizer: 'رئاسة الجامعة',
        speakers: ['د. رئيس الجامعة', 'د. نائب الرئيس'],
        type: EventType.graduation,
        status: EventStatus.completed,
        categoryColor: const Color(0xFF795548),
        imageUrl: '',
        maxAttendees: 1000,
        currentAttendees: 850,
        tags: ['تخرج', 'احتفال', 'إنجاز', 'طلاب'],
        contactInfo: 'graduation@hilla.edu.iq',
      ),
      Event(
        id: '7',
        title: 'معرض المشاريع الطلابية',
        description: 'معرض يعرض أفضل المشاريع الطلابية من مختلف الكليات في مجالات الهندسة والعلوم والتكنولوجيا.',
        startDate: now.subtract(const Duration(days: 20)),
        endDate: now.subtract(const Duration(days: 18)),
        location: 'قاعة المعارض - جامعة الحلة',
        organizer: 'كلية الهندسة',
        speakers: ['د. أحمد محمد', 'د. فاطمة علي'],
        type: EventType.academic,
        status: EventStatus.completed,
        categoryColor: const Color(0xFF2196F3),
        imageUrl: '',
        maxAttendees: 200,
        currentAttendees: 180,
        tags: ['مشاريع', 'طلاب', 'هندسة', 'ابتكار'],
        contactInfo: 'projects@hilla.edu.iq',
      ),
      Event(
        id: '8',
        title: 'ورشة الكتابة الأكاديمية',
        description: 'ورشة تدريبية لطلاب الدراسات العليا حول كيفية كتابة البحوث العلمية والأوراق الأكاديمية.',
        startDate: now.subtract(const Duration(days: 35)),
        endDate: now.subtract(const Duration(days: 34)),
        location: 'قاعة التدريب - مكتبة الجامعة',
        organizer: 'كلية الآداب',
        speakers: ['د. سارة أحمد', 'د. محمد حسن'],
        type: EventType.workshop,
        status: EventStatus.completed,
        categoryColor: const Color(0xFFFF9800),
        imageUrl: '',
        maxAttendees: 80,
        currentAttendees: 65,
        tags: ['كتابة', 'بحث', 'أكاديمي', 'تدريب'],
        contactInfo: 'workshop@hilla.edu.iq',
      ),
    ];
  }

  static List<Event> getUpcomingEvents() {
    return getEvents().where((event) => event.isUpcoming).toList();
  }

  static List<Event> getOngoingEvents() {
    return getEvents().where((event) => event.isOngoing).toList();
  }

  static List<Event> getCompletedEvents() {
    return getEvents().where((event) => event.isCompleted).toList();
  }

  static List<Event> getEventsByType(EventType type) {
    return getEvents().where((event) => event.type == type).toList();
  }
}

