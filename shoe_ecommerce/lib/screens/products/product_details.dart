import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/utils/constants/textStyle.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: widget.product.name,
      centerTitle: true,
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: () {
        context.pop();
      },
      trailingIcon: Icons.shopping_cart_outlined,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImageCarousel(
                    image: widget.product.images.isNotEmpty
                        ? widget.product.images[0]
                        : ''),
                const SizedBox(height: 16),
                _ProductInfo(product: widget.product),
                const SizedBox(height: 16),
                _SizeSelector(),
                SizedBox(height: 20.sp),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Price\n",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                      TextSpan(
                        text: "\$${widget.product.price}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomButton(
                  text: "Add To Cart",
                  onPressed: () async {
                    if (selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a size")),
                      );
                      return;
                    }

                    try {
                      final response = await OrderService().addToCart(
                        widget.product.productId,
                   
                        selectedSize!,1
                      );
                      if (response['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product added to cart")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response['message'] ?? 'Error')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add to cart')),
                      );
                    }
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Product Image Carousel Widget
  Widget _ProductImageCarousel({required String image}) {
    return Center(
      child: Image.asset(
        image.isNotEmpty ? image : "assets/images/placeholder.png",
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  // Product Info Widget
  Widget _ProductInfo({required Product product}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("BEST SELLER",
            style: TextStyle(color: Colors.blue, fontSize: 12)),
        SizedBox(height: 5.sp),
        Text(product.name,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.sp),
        Text("\$${product.price.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.sp),
        Text(
          product.description,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey),
        ),
        SizedBox(height: 5.sp),
        Text(
          "Gallery",
          style: AppTextStyle.textFieldTitle,
        ),
        SizedBox(height: 5.sp),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: product.images.map((image) {
                return Container(
                  width: 50.sp,
                  height: 50.sp,
                  margin: EdgeInsets.only(right: 10.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.whiteColor),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            )),
        SizedBox(height: 5.sp),
        Text(
          "Size",
          style: AppTextStyle.textFieldTitle,
        )
      ],
    );
  }

  // Size Selector Widget
  Widget _SizeSelector() {
    return Row(
      children: widget.product.sizes.map((size) {
        bool isSelected = size == selectedSize; // Check if the size is selected

        return GestureDetector(
          onTap: () {
            setState(() {
              print(size);
              selectedSize = isSelected ? null : size; // Toggle selection
            });
          },
          child: Container(
            padding: EdgeInsets.all(12.sp),
            margin: EdgeInsets.only(right: 10.sp),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.whiteColor, // Highlight selected size with yellow
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.3)
                      : Colors.transparent,
                  blurRadius: 10,
                  spreadRadius: 4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              size.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.grey, // Text color change when selected
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
