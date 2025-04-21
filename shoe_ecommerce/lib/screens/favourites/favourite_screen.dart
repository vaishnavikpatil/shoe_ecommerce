import 'package:shoe_ecommerce/export.dart';

class FavouriteScreen extends StatelessWidget {
  final List<ShoeItem> shoes = [
    ShoeItem(name: "Nike Jordan", price: 58.7, image: "assets/images/shoe7.png", colors: [Colors.yellow, Colors.green], isFavorite: true),
    ShoeItem(name: "Nike Air Max", price: 37.8, image: "assets/images/shoe8.png", colors: [Colors.blue, Colors.grey], isFavorite: false),
    ShoeItem(name: "Nike Club Max", price: 47.7, image: "assets/images/shoe9.png", colors: [Colors.blue, Colors.yellow], isFavorite: false),
    ShoeItem(name: "Nike Air Max", price: 57.6, image: "assets/images/shoe10.png", colors: [Colors.cyan, Colors.blue], isFavorite: false),
  ];

   FavouriteScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.sp,
          mainAxisSpacing: 15.sp,
          childAspectRatio: 0.7,
        ),
        itemCount: shoes.length,
        itemBuilder: (context, index) {
          return ShoeCard(shoe: shoes[index]);
        },
      
    );
  }
}

class ShoeCard extends StatelessWidget {
  final ShoeItem shoe;
  
  const ShoeCard({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:  EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
              Icons.favorite,
                color:  Colors.red,
              ),
            ),
           
              Image.asset(shoe.image, ),
            
          
             Text(
              "BEST SELLER",
              style: TextStyle(color: AppTheme.secondaryColor, fontSize: 12.sp, fontWeight: FontWeight.w400,fontFamily: "AirbnbCereal"),
            ),
            Flexible(
              child: Text(
                shoe.name,
                style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,fontFamily: "AirbnbCereal"),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          SizedBox(height: 10.sp,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${shoe.price}",
                  style:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,fontFamily: "AirbnbCereal"),
                ),
                 Row(
              children: shoe.colors.map((color) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: CircleAvatar(radius:7.r, backgroundColor: color),
              )).toList(),
            ),
              ],
            ),
            const SizedBox(height: 4),
           
          ],
        ),
      ),
    );
  }
}

class ShoeItem {
  final String name;
  final double price;
  final String image;
  final List<Color> colors;
  final bool isFavorite;

  ShoeItem({
    required this.name,
    required this.price,
    required this.image,
    required this.colors,
    required this.isFavorite,
  });
}