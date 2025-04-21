import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/screens/products/product_list.dart';

import 'package:shoe_ecommerce/service/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> popularShoes = [];
  List<Product> newArrivals = [];

  int? selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      final popular = await ProductService().getPopularProducts();
      final newOnes = await ProductService().getNewArrivals();

      setState(() {
        popularShoes = popular;
        newArrivals = newOnes;
      });
    } catch (e) {
      print('Error loading home data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.push(RouteNames.search);
            },
            child: const CustomTextField(
              hintText: "Looking for Shoes",
              leadingIcon: Icons.search_outlined,
              enabled: false,
            ),
          ),
          SizedBox(height: 20.sp),
          SizedBox(
            height: 40.sp,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppLists.brandList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.sp),
                    child: selectedIndex == index
                        ? Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(25.sp),
                            ),
                            child: Row(
                              children: [
                                AppLists.brandList[index]['image'] == ""
                                    ? const SizedBox.shrink()
                                    : Container(
                                        width: 30.sp,
                                        height: 30.sp,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            AppLists.brandList[index]
                                                ['image']!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                SizedBox(width: 8.sp),
                                Text(
                                  AppLists.brandList[index]['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.sp),
                              ],
                            ),
                          )
                        : Container(
                            width: 40.sp,
                            height: 40.sp,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: AppLists.brandList[index]['image'] == ""
                                ? Text(
                                    AppLists.brandList[index]['name']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      AppLists.brandList[index]['image']!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                  ),
                );
              },
            ),
          ),
          selectedIndex != 0
              ? Expanded(
                  child: ProductList(
                    brandName: AppLists.brandList[selectedIndex!]['name'],
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SectionFromModel(
                          title: "Popular Shoes",
                          products: popularShoes,
                        ),
                        NewArrivalFromModel(products: newArrivals),
                      ],
                    ),
                  ),
                )
        ],
   
    );
  }
}

class SectionFromModel extends StatelessWidget {
  final String title;
  final List<Product> products;

  const SectionFromModel(
      {super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "AirbnbCereal")),
            Text("See all",
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "AirbnbCereal",
                    color: AppTheme.secondaryColor)),
          ],
        ),
        SizedBox(height: 20.sp),
        SizedBox(
          height: 250.sp,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  context.push(RouteNames.productDetails,extra: products[index]);
                },
                child: ShoeCard(
                  name: products[index].name ,
                  price: products[index].price,
                  image: products[index].images.first,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewArrivalFromModel extends StatelessWidget {
  final List<Product> products;

  const NewArrivalFromModel({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("New Arrivals",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "AirbnbCereal")),
            Text("See all",
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "AirbnbCereal",
                    color: AppTheme.secondaryColor)),
          ],
        ),
        SizedBox(height: 20.sp),
        SizedBox(
          height: 140.sp,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: (){
                  context.push(RouteNames.productDetails,extra: product);
                },
                child: Padding(
                  padding:  EdgeInsets.only(right:20.sp),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.sp),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BEST CHOICE',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: "AirbnbCereal",
                                      fontWeight: FontWeight.w400,
                                      color: AppTheme.secondaryColor)),
                              Text(product.name ,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: "AirbnbCereal",
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10.sp),
                              Text("\$${product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: "AirbnbCereal",
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: SizedBox(
                              width: 200.sp,
                              child: Image.asset(
                                product.images.first,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShoeCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;

  const ShoeCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.sp),
      child: Stack(
        children: [
          Container(
            width: 170.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(image, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BEST SELLER',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.w400,
                              color: AppTheme.secondaryColor)),
                      Text(name,maxLines: 1,
            overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 10.sp),
                      Text("\$${price.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      bottomRight: Radius.circular(20.sp))),
              child: const Icon(
                Icons.favorite_outline,
                color: AppTheme.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
