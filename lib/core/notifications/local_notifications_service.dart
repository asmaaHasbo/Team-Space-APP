import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> init() async {
    //بيحدد أيقونة الاشعار — الصورة الصغيرة اللي بتظهر في الشريط فوق
    const androidSettings =  AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    const settings = InitializationSettings(android: androidSettings);
    //بيسلّم العلبة للمكتبة. من غيره المكتبة متعرفش أي حاجة من دول.
    await _plugin.initialize(settings: settings);

    const channel = AndroidNotificationChannel(
      'messages_channel', // اسم القناة اللي المستخدم مش هيشوفه
      'Messages', //الاسم اللي المستخدم بيقراه في لستة الإعدادات
      importance:
          Importance.high, //علشان يظهر على طول من غير ما المستخدم يفتح الشريط
    );

    //بيعمل القناة دي على الجهاز — من غيره الاشعارات مش هتظهر

    await _plugin
        // بيحدد نوع المكتبة بناءً على النظام التشغيلي
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> show({required String title, required String body}) async {
    await _plugin.show(
      //بيحدد رقم الاشعار — لو فيه اشعارين بنفس الرقم الاشعار القديم هيتبدل بالجديد
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        //بيحدد شكل الاشعار على حسب النظام التشغيلي
        android: AndroidNotificationDetails(
          'messages_channel',
          'Messages',
          //بيحدد مستوى الأهمية وال أولوية للإشعار
          importance: Importance.high,
          //علشان يظهر على طول من غير ما المستخدم يفتح الشريط
          priority: Priority.high,
        ),
      ),
    );
  }
}
