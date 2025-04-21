import 'package:shoe_ecommerce/export.dart';

class CustomFilterSheet extends StatefulWidget {
  final void Function({
    required String gender,
    required String size,
    required RangeValues priceRange,
    required String category,
  }) onApply;

  final String? initialGender;
  final String? initialSize;
  final String? initialCategory;
  final RangeValues initialPriceRange;

  const CustomFilterSheet({
    super.key,
    required this.onApply,
    this.initialGender,
    this.initialSize,
    this.initialCategory,
    required this.initialPriceRange,
  });

  @override
  State<CustomFilterSheet> createState() => _CustomFilterSheetState();
}

class _CustomFilterSheetState extends State<CustomFilterSheet> {
  late String selectedGender;
  late String selectedSize;
  late String selectedCategory;
  late RangeValues priceRange;

  final genders = ['Men', 'Women', 'Unisex'];
  final sizes = ["7", "8", "9", "10"];
  final categories = ['Casual', 'Sports', 'Formal'];

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender ?? '';
    selectedSize = widget.initialSize ?? '';
    selectedCategory = widget.initialCategory ?? '';
    priceRange = widget.initialPriceRange;
  }

  Widget buildChoiceChips(List<String> options, String selected, Function(String) onChanged) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => setState(() => onChanged(option)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = '';
                      selectedSize = '';
                      selectedCategory = '';
                      priceRange = const RangeValues(16, 350);
                    });
                  },
                  child: const Text("RESET", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildChoiceChips(genders, selectedGender, (val) => selectedGender = val),
            const SizedBox(height: 20),
            const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildChoiceChips(sizes, selectedSize, (val) => selectedSize = val),
            const SizedBox(height: 20),
            const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildChoiceChips(categories, selectedCategory, (val) => selectedCategory = val),
            const SizedBox(height: 20),
            Text(
              "Price Range: \$${priceRange.start.toInt()} - \$${priceRange.end.toInt()}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            RangeSlider(
              values: priceRange,
              min: 16,
              max: 350,
              labels: RangeLabels(
                "\$${priceRange.start.toInt()}",
                "\$${priceRange.end.toInt()}",
              ),
              onChanged: (values) => setState(() => priceRange = values),
              activeColor: AppTheme.primaryColor,
              overlayColor: WidgetStateColor.transparent,
              inactiveColor: AppTheme.backgroundColor,
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width,
              child: CustomButton(
                onPressed: () {
                  widget.onApply(
                    gender: selectedGender,
                    size: selectedSize,
                    priceRange: priceRange,
                    category: selectedCategory,
                  );
                  context.pop();
                },
                text: "Apply",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
