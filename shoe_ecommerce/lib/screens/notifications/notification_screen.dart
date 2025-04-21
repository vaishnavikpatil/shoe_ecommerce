import 'package:shoe_ecommerce/export.dart';



class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<NotificationItem> notifications = [
    NotificationItem(
        image: 'assets/images/shoe4.png',
        title: 'We Have New Products With Offers',
        oldPrice: '\$364.95',
        newPrice: '\$260.00',
        time: '6 min ago',
        isNew: true),
    NotificationItem(
        image: 'assets/images/shoe5.png',
        title: 'We Have New Products With Offers',
        oldPrice: '\$364.95',
        newPrice: '\$260.00',
        time: '26 min ago',
        isNew: true),
    NotificationItem(
        image: 'assets/images/shoe6.png',
        title: 'We Have New Products With Offers',
        oldPrice: '\$364.95',
        newPrice: '\$260.00',
        time: '4 day ago',
        isNew: false),
    NotificationItem(
        image: 'assets/images/shoe7.png',
        title: 'We Have New Products With Offers',
        oldPrice: '\$364.95',
        newPrice: '\$260.00',
        time: '4 day ago',
        isNew: false),
  ];

  @override
  Widget build(BuildContext context) {
    return  ListView(
        children: [
          SizedBox(height:20.sp),
          const Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "AirbnbCereal")),
          ...notifications.take(2).map((e) => NotificationTile(notification: e)),
           SizedBox(height: 20.sp),
          const Text('Yesterday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "AirbnbCereal")),
          ...notifications.skip(2).map((e) => NotificationTile(notification: e)),
        ],
    
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(15.sp)
            ),
            child: Padding(
              padding:  const EdgeInsets.all(5),
              child: Image.asset(notification.image, width: 70.sp, height: 70.sp, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp,fontFamily: "AirbnbCereal")),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(notification.oldPrice, style: const TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey,fontFamily: "AirbnbCereal")),
                    const SizedBox(width: 5),
                    Text(notification.newPrice, style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: "AirbnbCereal"))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 5.sp,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(notification.time, style:  TextStyle(fontSize: 14.sp, color: Colors.grey)),
              const SizedBox(height: 4),
             notification.isNew ? const Icon(Icons.circle, size: 8, color:  Colors.blue ):const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String image;
  final String title;
  final String oldPrice;
  final String newPrice;
  final String time;
  final bool isNew;

  NotificationItem({
    required this.image,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
    required this.time,
    required this.isNew,
  });
}
