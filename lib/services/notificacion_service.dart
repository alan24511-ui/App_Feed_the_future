import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificacionService {

  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future init() async {

    tz.initializeTimeZones();

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(settings);
  }

  static Future programarNotificaciones() async {

    // 🍳 DESAYUNO
    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      1,
      'Desayuno 🍳',
      'Recuerda registrar tu desayuno',
      _hora(8, 0),
      _detalles(),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents:
      DateTimeComponents.time,
    );

    // 🍛 COMIDA
    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      2,
      'Comida 🍛',
      'No olvides registrar tu comida',
      _hora(14, 0),
      _detalles(),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents:
      DateTimeComponents.time,
    );

    // 🌙 CENA
    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      3,
      'Cena 🌙',
      'Registra tu cena para mantener tu progreso',
      _hora(20, 0),
      _detalles(),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents:
      DateTimeComponents.time,
    );
  }

  static NotificationDetails _detalles() {

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'comidas_channel',
        'Recordatorios de comidas',

        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  static tz.TZDateTime _hora(
      int hour,
      int minute,
      ) {

    final now =
    tz.TZDateTime.now(tz.local);

    var fecha = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (fecha.isBefore(now)) {

      fecha = fecha.add(
        const Duration(days: 1),
      );
    }

    return fecha;
  }
}