import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testsc/screens/product_detail_screen.dart';
import '../view_model/product_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 3;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
    context.read<ProductViewModel>().getProductList();
  }

  Future<void> _loadCategories() async {
    await context.read<ProductViewModel>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, _) {
          return _buildBody(viewModel);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Discover'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearchPressed,
        ),
      ],
    );
  }

  Widget _buildBody(ProductViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClearanceBanner(),
          _buildCategoriesSection(viewModel),
          _buildProductsGrid(viewModel),
        ],
      ),
    );
  }

  Widget _buildClearanceBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Text(
              '%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Up to 50%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ProductViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _handleSeeAllCategories,
                child: const Text('See all'),
              ),
            ],
          ),
          _buildCategoryChips(viewModel),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(ProductViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          viewModel.categoryList.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(viewModel.categoryList[index]),
              selected: _selectedCategoryIndex == index,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = selected ? index : 0;
                });
              },
              selectedColor: Colors.greenAccent[100],
              labelStyle: TextStyle(
                color: _selectedCategoryIndex == index
                    ? Colors.green
                    : Colors.black,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: _selectedCategoryIndex == index
                      ? Colors.green
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(ProductViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: viewModel.productList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: viewModel.productList[index],
                  ),
                ),
              );
            },
            child: ProductCard(
              imageUrl: viewModel.productList[index].image!,
              name: viewModel.productList[index].model.toString(),
              price: viewModel.productList[index].price!.toDouble(),
              rating: viewModel.productList[index].discount != null
                  ? viewModel.productList[index].discount!
                  : 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _handleSearchPressed() {}

  void _handleSeeAllCategories() {}
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final int rating;
  final String imageUrl;
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(rating.toString(), style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
