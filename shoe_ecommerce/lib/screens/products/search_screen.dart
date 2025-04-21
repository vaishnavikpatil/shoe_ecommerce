import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/screens/products/product_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final List<String> recentSearches = [];

  void onSearch(String query) {
    setState(() {
      searchQuery = query.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      centerTitle: true,
      onLeadingTap: () {
        context.pop();
      },
      apptitle: "Search",
      body: Column(
        children: [
          CustomTextField(
            leadingIcon: Icons.search_outlined,
            controller: searchController,
            autofocus: true,
            onSubmitted: onSearch,
            hintText: 'Search',
          ),
          SizedBox(height: 10.sp),
          searchQuery==''?SizedBox():
          Expanded(
            child: ProductList(
 
              searchQuery: searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}
