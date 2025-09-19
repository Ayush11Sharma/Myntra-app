
import 'dart:async';
import 'package:flutter/material.dart';
import 'between.dart';
import 'dart:math';

void main() {
  runApp(const ClothesApp());
}

class ClothesApp extends StatelessWidget {
  const ClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Clothes App",
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const ClothesPage(),
    );
  }
}

class ClothesPage extends StatefulWidget {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  State<ClothesPage> createState() => _ClothesPageState();
}

class _ClothesPageState extends State<ClothesPage> {
  final PageController _sliderController = PageController();
  Timer? _sliderTimer;
  int _currentSlide = 0;

  // auto slider images (replace with your own)
  final List<String> _sliderImages = List.generate(4, (i) => 'assets/slider/img${i + 1}.png');

  final List<Map<String, String>> categoriesMen = [
    {'name': 'Casual', 'image': 'assets/men1/img.png'},
    {'name': 'Ethnic', 'image': 'assets/men1/img1.png'},
    {'name': 'Sports', 'image': 'assets/men1/img2.png'},
    {'name': 'Footwear', 'image': 'assets/men1/img3.png'},
    {'name': 'Essentials', 'image': 'assets/men1/img4.png'},
  ];


  String _pincodeOrAddress = 'Enter delivery address';

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_sliderImages.isEmpty) return;
      _currentSlide = (_currentSlide + 1) % _sliderImages.length;
      _sliderController.animateToPage(
        _currentSlide,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _sliderController.dispose();

    super.dispose();
  }

  String productImagePathFromIndex(int index) {

    return 'assets/men9/img${(index % 50) + 1}.png';
  }

  final List<String> sampleTitles = [
    'THE HOLLANDER',
    'The Souled Store',
    'Mufti',
    'SPYKAR',
    'Puma',
    'Jack & Jones',
    'Elibolz',
    'Crazymonk',
    'RARE RABBIT',
    'H&M',
    'Snitch',
    'Allen Solly',
    'Banana Club',
    'Bewakoof',
    'NOBERO',
    'Polo Club',
    'HIGHLANDER',
    'Louis Philippe',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/image/myntralogo.jpg',
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'MYNTRA',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      GestureDetector(
                        onTap: () async {

                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressSearchPage(),
                              fullscreenDialog: true,
                            ),
                          );
                          if (result != null && result.trim().isNotEmpty) {
                            setState(() => _pincodeOrAddress = result.trim());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final result = await Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddressSearchPage(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  if (result != null && result.trim().isNotEmpty) {
                                    setState(() => _pincodeOrAddress = result.trim());
                                  }
                                },
                                child: const Icon(Icons.location_on_outlined),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _pincodeOrAddress,
                                  style: TextStyle(
                                    color: _pincodeOrAddress == 'Enter delivery address' ? Colors.grey.shade600 : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoriesMen.length,
                          itemBuilder: (context, index) {
                            final item = categoriesMen[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: AssetImage(item['image']!),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Auto-scrolling big slider with dots
                      AspectRatio(
                        aspectRatio: 24 / 24,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _sliderController,
                              itemCount: _sliderImages.length,
                              onPageChanged: (i) => setState(() => _currentSlide = i),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    _sliderImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_sliderImages.length, (i) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: _currentSlide == i ? 10 : 8,
                                    height: _currentSlide == i ? 10 : 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentSlide == i ? Colors.white : Colors.white70,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.52,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          final image = productImagePathFromIndex(index + 1);
                          // rotate sample titles so each card shows different text
                          final title = sampleTitles[index % sampleTitles.length];
                          final subtitle = 'Printed Oversized T-Shirt';
                          final random = Random();
                          final randomMultipleOf5 = (random.nextInt(15) + 1) * 5;
                          final price = '₹${1400 + (index * randomMultipleOf5)}';

                          return GestureDetector(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BetweenPage(
                                    title: title,
                                    imagePath: image,
                                    price: price,
                                    address: _pincodeOrAddress,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              index: index + 1,
                              imagePath: image,
                              title: title,
                              subtitle: subtitle,
                              price: price,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ProductCard extends StatelessWidget {
  final int index;
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;

  const ProductCard({
    Key? key,
    required this.index,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // card decoration
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({Key? key}) : super(key: key);

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a pincode or address')),
      );
      return;
    }
    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Location'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top info like screenshot
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.pink),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Location permission is off\nGranting location permission will ensure accurate address and hassle free delivery',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Select Delivery Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Delivery Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),

            const SizedBox(height: 14),

            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.pink.shade400),
                  const SizedBox(width: 8),
                  Text(
                    'Search location',
                    style: TextStyle(color: Colors.pink.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
