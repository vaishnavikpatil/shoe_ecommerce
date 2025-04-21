import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/model/product_model.dart';
import 'package:shoe_ecommerce/service/product_service.dart';
import 'package:shoe_ecommerce/widgets/custom_filtersheet.dart';

class ProductList extends StatefulWidget {
  final String? brandName;
  final String? searchQuery;
  const ProductList({this.brandName,this.searchQuery, super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  bool isLoading = true;

  String? selectedSort;
  String? selectedGender;
  String? selectedSize;
  String? selectedCategory;
  RangeValues? selectedPriceRange;

  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

@override
void didUpdateWidget(covariant ProductList oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.brandName != widget.brandName) {
    _fetchProducts();
  }
}
Future<void> _fetchProducts() async {
  setState(() => isLoading = true);
  try {
    Map<String, dynamic> filterParams = {};

    if (widget.brandName?.isNotEmpty == true) {
      filterParams['brandname'] = widget.brandName!;
    }
    if (widget.searchQuery?.isNotEmpty == true) {
      filterParams['search'] = widget.searchQuery!;
    }
    if (selectedGender != null && selectedGender!.isNotEmpty) {
      filterParams['gender'] = selectedGender!;
    }
    if (selectedSize != null && selectedSize!.isNotEmpty) {
      filterParams['size'] = selectedSize!;
    }
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      filterParams['category'] = selectedCategory!;
    }
    if (selectedPriceRange != null) {
      filterParams['min_price'] = selectedPriceRange!.start.toInt();
      filterParams['max_price'] = selectedPriceRange!.end.toInt();
    }

    List<Product> fetched = await _productService.filterProducts(filterParams);

    if (selectedSort != null) {
      fetched = _applySort(fetched, selectedSort!);
    }

    setState(() {
      products = fetched;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

  List<Product> _applySort(List<Product> list, String sortKey) {
    switch (sortKey) {
      case 'low_to_high':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'high_to_low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return list;
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sort by", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text("Price: Low to High"),
                    leading: Radio<String>(
                      value: "low_to_high",
                      groupValue: selectedSort,
                      onChanged: (value) => setModalState(() => selectedSort = value),
                    ),
                  ),
                  ListTile(
                    title: const Text("Price: High to Low"),
                    leading: Radio<String>(
                      value: "high_to_low",
                      groupValue: selectedSort,
                      onChanged: (value) => setModalState(() => selectedSort = value),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                      text: "Apply",
                      onPressed: () {
                        context.pop();
                        _fetchProducts();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CustomFilterSheet(
          initialGender: selectedGender,
          initialSize: selectedSize,
          initialCategory: selectedCategory,
          initialPriceRange: selectedPriceRange ?? const RangeValues(16, 350),
          onApply: ({
            required String gender,
            required String size,
            required RangeValues priceRange,
            required String category,
          }) {
            selectedGender = gender;
            selectedSize = size;
            selectedCategory = category;
            selectedPriceRange = priceRange;
            _fetchProducts();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (products.isNotEmpty) ...[
          SizedBox(height: 5.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: _openSortSheet,
                icon: const Icon(Icons.sort),
                label: const Text("Sort"),
              ),
              TextButton.icon(
                onPressed: () => _openFilterSheet(context),
                icon: const Icon(Icons.filter_list),
                label: const Text("Filter"),
              ),
            ],
          ),
        ],
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(child: Text("No products found"))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.sp,
                        mainAxisSpacing: 20.sp,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ShoeCard(
                          product:product
                        );
                      },
                    ),
        ),
      ],
    );
  }
}



class ShoeCard extends StatelessWidget {
final Product product;

  const ShoeCard({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RouteNames.productDetails,  extra: product,);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(product.images[0], width: double.infinity, fit: BoxFit.cover),
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
                      Text(product.name, maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.sp,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 10.sp),
                      Text("\$${product.price.toStringAsFixed(2)}",
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
