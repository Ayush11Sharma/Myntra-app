import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'men.dart';
import 'storage.dart';
import 'slaphscreen.dart';

void main() {
  runApp(const MyntraApp());
}

class MyntraApp extends StatelessWidget {
  const MyntraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myntra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyntraHomePage extends StatefulWidget {
  const MyntraHomePage({super.key});

  @override
  State<MyntraHomePage> createState() => _MyntraHomePageState();
}
//............................................................................
class DestinationPage extends StatelessWidget {
  final int index;
  final String imagePath;

  const DestinationPage({Key? key, required this.index, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item ${index + 1}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tapped item ${index + 1}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Image.asset(imagePath, width: 240, height: 240, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
class _MyntraHomePageState extends State<MyntraHomePage> {
  int _currentBannerIndex = 0;
  int _selectedCategoryIndex = 0;

  final PageController _bannerController = PageController();
  late Timer _bannerTimer;

  late int _remainingSeconds;
  late Timer _saleTimer;
  final int _initialHours = 9;

  final ScrollController _scrollController = ScrollController();
  int _lastSelectedIndex = 0;
  bool _showLastRow = true;
  Timer? _scrollStopTimer;

  final List<String> _lastRowImages =
  List.generate(5, (i) => 'assets/image8/img${i + 1}.png');

  final List<Color> _lastRowColors = [
    const Color(0xFFE91E63), // pink
    const Color(0xFF673AB7), // purple
    const Color(0xFF3F51B5), // indigo
    const Color(0xFF009688), // teal
    const Color(0xFFFF9800), // orange
  ];

// height of sticky bar (used for scroll padding)
  final double _lastRowHeight = 88.0;


  final List<String> bannerImages = [
    'assets/image/jockey.png',
    'assets/image/levis.png',
    'assets/image/h&m.png',
    'assets/image/adidas.png',
    'assets/image/kurta.png',
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Fashion', 'image': 'assets/image/fashion.jpeg'},
    {'name': 'Beauty', 'image': 'assets/image/makeup.jpeg'},
    {'name': 'Homeliving', 'image': 'assets/image/home.jpeg'},
    {'name': 'Footwear', 'image': 'assets/image/footwear.jpeg'},
    {'name': 'Accessories', 'image': 'assets/image/accessories.jpg'},
  ];

  final List<Map<String, String>> brands = [
    {
      'name': 'GLAMStream',
      'subtitle': 'Under \$999',
      'image':
      'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=400',
    },
    {
      'name': 'CAMPUS',
      'subtitle': 'Min. 40% OFF',
      'image':
      'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=400',
    },
    {
      'name': 'QSIGN',
      'subtitle': 'New Collection',
      'image':
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    },
    {
      'name': 'Conity Footwear',
      'subtitle': 'Flat 7.5% Cashback',
      'image':
      'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
    },
    {
      'name': 'INDDUS',
      'subtitle': 'Sponsored',
      'image':
      'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
    },
    {
      'name': 'Brand 6',
      'subtitle': 'Special Offers',
      'image':
      'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=400',
    },
    {
      'name': 'Brand 7',
      'subtitle': 'Trending Now',
      'image':
      'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
    },
    {
      'name': 'Brand 8',
      'subtitle': 'Just In',
      'image':
      'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
    },
    {
      'name': 'Brand 9',
      'subtitle': 'Summer Collection',
      'image':
      'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=400',
    },
    {
      'name': 'Brand 10',
      'subtitle': 'Limited Stock',
      'image':
      'https://images.unsplash.com/photo-1588117305388-c2631a279f82?w=400',
    },
    {
      'name': 'Brand 11',
      'subtitle': 'Premium Range',
      'image':
      'https://images.unsplash.com/photo-1593030103066-0093718efeb9?w=400',
    },
  ];

  final List<Map<String, String>> closingOffers = [
    {
      'logo': 'assets/image1/aristocratlogo.png',
      'image': 'assets/image1/aristocrat.png',
      'title': 'Starting \u20B9 799'
    },
    {
      'logo': 'assets/image1/h&mlogo.png',
      'image': 'assets/image1/h&m.png',
      'title': 'Up To 50% OFF'
    },
    {
      'logo': 'assets/image1/img.png',
      'image': 'assets/image1/img_1.png',
      'title': 'MIN. 75% OFF'
    },
    {
      'logo': 'assets/image1/levieslogo.png',
      'image': 'assets/image1/levies.png',
      'title': 'MIN. 60% OFF'
    },
    {
      'logo': 'assets/image1/pumalogo.png',
      'image': 'assets/image1/puma.png',
      'title': 'MIN. 83% OFF'
    },
    {
      'logo': 'assets/image1/redtapelogo.png',
      'image': 'assets/image1/redtape.png',
      'title': 'MIN. 60% OFF'
    },
  ];

  final List<Map<String, String>> featuredBrands = [
    {'image': 'assets/image2/saries.png', 'title': 'Starting 799'},
    {'image': 'assets/image2/boat.png', 'title': 'Up To 70% Off'},
    {'image': 'assets/image2/node.png', 'title': 'Nord Buds 3r'},
    {'image': 'assets/image2/levies.png', 'title': 'Iconic Collections'},
    {'image': 'assets/image2/oneplus.png', 'title': 'ONEPLUS'},
    {'image': 'assets/image2/nike.png', 'title': 'Special Deal'},
    {'image': 'assets/image2/roadster.png', 'title': 'Limited Edition'},
    {'image': 'assets/image2/jockey.png', 'title': 'New Arrivals'},
    {'image': 'assets/image2/lakme.png', 'title': 'Best Sellers'},
    {'image': 'assets/image2/img.png', 'title': 'trending'},
  ];

  final List<Map<String, String>> sponsoredBrands = [
    {'image': 'assets/men4/img1.png', 'title': 'Brand 1'},
    {'image': 'assets/men4/img2.png', 'title': 'Brand 2'},
    {'image': 'assets/men4/img3.png', 'title': 'Brand 3'},
    {'image': 'assets/men4/img4.png', 'title': 'Brand 4'},
    {'image': 'assets/men4/img5.png', 'title': 'Brand 5'},
    {'image': 'assets/men4/img6.png', 'title': 'Brand 6'},
    {'image': 'assets/image3/mini8.png', 'title': 'Brand 7'},
    {'image': 'assets/image3/mini16.png', 'title': 'Brand 8'},
    {'image': 'assets/image3/mini20.png', 'title': 'Brand 9'},
    {'image': 'assets/image3/mini10.png', 'title': 'Brand 10'},
  ];

  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  late VideoPlayerController _whiteVideoController;
  bool _whiteVideoInitialized = false;

  late VideoPlayerController _focusTodayController;
  bool _focusTodayInitialized = false;

  final List<String> miniImages =
  List.generate(28, (i) => 'assets/image3/mini${i + 1}.png');

  final List<String> shopImages =
  List.generate(16, (i) => 'assets/image4/img${i + 1}.png');

  final List<String> sliderImages =
  List.generate(8, (i) => 'assets/image6/img${i + 1}.png');

  final List<String> superstarImages =
  List.generate(30, (i) => 'assets/image5/img${i + 1}.png');

  final List<String> focusTodayImages =
  List.generate(20, (i) => 'assets/image7/img${i + 1}.png');

  final List<String> discoverStores =
  List.generate(11, (i) => 'assets/men6/img${i + 1}.png');


  @override
  void initState() {
    super.initState();

    // Initialize flash sale timer
    _resetSaleTimer();
    _startSaleTimer();

    // Start automatic banner rotation
    _bannerTimer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentBannerIndex < bannerImages.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
    void _scroll_controller_listener() {
      _scrollController.addListener(() {

        if (_showLastRow) {
          setState(() => _showLastRow = false);
        }

        // debounce: when user stops scrolling show the bar
        _scrollStopTimer?.cancel();
        _scrollStopTimer = Timer(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          setState(() => _showLastRow = true);
        });
      });
    }

    _videoController =
    VideoPlayerController.asset('assets/video/VID_20250908_225356.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoInitialized = true;
        });
        _videoController.setLooping(true);
        _videoController.play();
      });

    _whiteVideoController = VideoPlayerController.asset('assets/video/video1.mp4')
      ..initialize().then((_) {
        setState(() {
          _whiteVideoInitialized = true;
        });
        _whiteVideoController.setLooping(true);
        _whiteVideoController.play();
      });
    _focusTodayController = VideoPlayerController.asset('assets/video/VID.mp4')
      ..initialize().then((_) {
        setState(() {
          _focusTodayInitialized = true;
        });
        _focusTodayController.setLooping(true);
        _focusTodayController.play();
      });

  }

  void _scroll_controller_listener() {
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  void _resetSaleTimer() {
    _remainingSeconds = _initialHours * 3600;
  }

  void _startSaleTimer() {
    _saleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          // restart when it reaches zero
          _resetSaleTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _saleTimer.cancel();
    _bannerController.dispose();
    _videoController.dispose();
    _whiteVideoController.dispose();
    _focusTodayController.dispose();
    _scrollController.dispose();
    _scrollStopTimer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _buildFlashSaleRow() {
    final int hours = _remainingSeconds ~/ 3600;
    final int minutes = (_remainingSeconds % 3600) ~/ 60;
    final int seconds = _remainingSeconds % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange.shade100),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      'BRAND BRIGADE',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // SALE below
                  const Text(
                    'SALE',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ends in',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBox(_twoDigits(hours), 'hrs'),
                      const SizedBox(width: 6),
                      _buildTimeBox(_twoDigits(minutes), 'min'),
                      const SizedBox(width: 6),
                      _buildTimeBox(_twoDigits(seconds), 'sec'),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      'HURRY UP!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Time is ticking!',
                    style: TextStyle(fontSize: 12, color: Colors.deepOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.orange.shade200),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {

            if (scrollNotification is ScrollStartNotification ||
                scrollNotification is ScrollUpdateNotification) {
              if (_showLastRow) setState(() => _showLastRow = false);
            }

            if (scrollNotification is ScrollEndNotification ||
                scrollNotification is UserScrollNotification) {
              _scrollStopTimer?.cancel();
              _scrollStopTimer = Timer(const Duration(milliseconds: 300), () {
                if (!mounted) return;
                setState(() => _showLastRow = true);
              });
            }

            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: _lastRowHeight + 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryAddress(),
                _buildSearchBar(),
                _buildCategoryTabs(),
                const Divider(height: 1),

                _buildSmallCategories(),
                _buildFlashSaleRow(),
                _buildBannerSlider(),
                const SizedBox(height: 24),

                _buildOfferBanner(),
                const SizedBox(height: 16),
                _buildBrandsTitle(),
                const SizedBox(height: 16),
                _buildBrandsList(),
                const SizedBox(height: 20),
                _buildClosingOffers(),
                _buildSectionHeader('FEATURED BRANDS'),
                const SizedBox(height: 12),
                _buildBrandContainers(featuredBrands),
                const SizedBox(height: 24),
                _buildFocusTodayRow(),
                _buildFocusToday(),
                const SizedBox(height: 12),
                _buildSectionHeader('SPONSORED BRANDS'),
                const SizedBox(height: 18),
                _buildBrandContainers(sponsoredBrands),
                const SizedBox(height: 12),
                _buildDiscoverStores(),
                const SizedBox(height: 16),
                _buildVideoBanner(),
                _buildMiniDoubleRow(),
                const SizedBox(height: 20),
                _buildShopByCategorySection(),
                const SizedBox(height: 12),
                _buildWhiteVideoRow(),
                _buildGreenSliderRow(),
                const SizedBox(height: 12),
                _buildSuperstar(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

        bottomNavigationBar: SafeArea(
          child: AnimatedSlide(
            offset: _showLastRow ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                SizedBox(
                  height: _lastRowHeight,
                  child: _buildLastContainerRow(),
                ),
              ],
            ),
          ),
        ),

    );
  }

  Widget _buildDeliveryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Enter your address.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search "Joggers"',
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Image(
                      image: AssetImage('assets/image/myntralogo.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.notifications_none, size: 28),
          const SizedBox(width: 12),
          const Icon(Icons.favorite_border, size: 28),
          const SizedBox(width: 12),
          const Icon(Icons.shopping_bag_outlined, size: 28),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryTab(
            'All',
            _selectedCategoryIndex == 0,
            onTap: () {
              setState(() => _selectedCategoryIndex = 0);
            },
          ),
          _buildCategoryTab(
            'Men',
            _selectedCategoryIndex == 1,
            onTap: () {
              setState(() => _selectedCategoryIndex = 1);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MenPage()),
              );
            },
          ),
          _buildCategoryTab(
            'Women',
            _selectedCategoryIndex == 2,
            onTap: () {
              setState(() => _selectedCategoryIndex = 2);
              // TODO: navigate to Women page
            },
          ),
          _buildCategoryTab(
            'Kids',
            _selectedCategoryIndex == 3,
            onTap: () {
              setState(() => _selectedCategoryIndex = 3);
              // TODO: navigate to Kids page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildSmallCategories() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: categories[index]['image']!.startsWith('assets/')
                          ? AssetImage(categories[index]['image']!) as ImageProvider
                          : CachedNetworkImageProvider(categories[index]['image']!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(categories[index]['name']!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CarouselSlider(
            items: bannerImages.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.startsWith('assets/')
                          ? Image.asset(imageUrl, fit: BoxFit.cover)
                          : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bannerImages.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  if (_bannerController.hasClients) {
                    _bannerController.animateToPage(entry.key, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  }
                },
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBannerIndex == entry.key
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('CAMPUS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
              child: const Text('asian', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 8),
          const Text('MIN. 40% OFF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          const SizedBox(height: 8),
          const Text('SPONSORED BY', style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          const Text('Flat 7.5% Cashback*', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('On Higher Cards', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ]),
      ),
    );
  }

  Widget _buildBrandsTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text('CONTINUE BROWSING THESE BRANDS', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildBrandsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], color: Colors.white),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  child: CachedNetworkImage(imageUrl: brands[index]['image']!, fit: BoxFit.cover, placeholder: (context, url) => Container(color: Colors.grey[200]), errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error))),
                ),
              ),
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(8.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(brands[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(brands[index]['subtitle']!, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]))),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildMiniOffer(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Padding(padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: SizedBox(height: 28,
                child: item['logo'] != null ? Image.asset(item['logo']!, fit: BoxFit.contain) : const SizedBox.shrink()
            )),
        Expanded(flex: 6, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: item['image'] != null ? Image.asset(item['image']!, fit: BoxFit.contain, width: double.infinity) : Container(color: Colors.grey[200])))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8), child: Text(item['title'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _buildClosingOffers() {
    final int hours = _remainingSeconds ~/ 3600;
    final int minutes = (_remainingSeconds % 3600) ~/ 60;
    final int seconds = _remainingSeconds % 60;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Container(
            height: 470,
            decoration: BoxDecoration(color: const Color(0xFFFFF3E6), borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
                Container(height: 72, width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F0),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Center(
                    child:
                    Text(' CLOSING  \nOFFERS', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26,
                            fontWeight: FontWeight.w900,
                        foreground: Paint()..shader = const LinearGradient(colors: [Color(0xFFFFEB3B), Color(0xFFFFA726)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter).
                        createShader(
                            const Rect.fromLTWH(0, 0, 200, 70)),
                            shadows: const [Shadow(color: Color(0x99B7410E),
                            offset: Offset(2, 3), blurRadius: 4),
                    Shadow(
                        color: Colors.white70,
                        offset: Offset(-1, -1), blurRadius: 0)],
                        letterSpacing: 1.2
                    )
            )
                )
    ),
        Container(
        height: 35,
        color: Colors.white,
    child: Center(
    child: Row(mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Deal Ends In',
    style: TextStyle(fontSize: 13, color: Colors.grey)),
    const SizedBox(width: 20), _buildTimeBox(_twoDigits(hours), 'hrs'),
    const SizedBox(width: 5), _buildTimeBox(_twoDigits(minutes), 'min'),
    const SizedBox(width: 5), _buildTimeBox(_twoDigits(seconds), 'sec')]))),
        Expanded(
    child: Container(width: double.infinity, padding:
    const EdgeInsets.all(12), decoration: BoxDecoration(gradient:
    const LinearGradient(colors: [Color(0xFFFFF3E0), Color(0xFFFFA726), Color(0xFFFFF3E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight, stops: [0.0, 0.5, 1.0]),
    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
    child: GridView.count(
    crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.68,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: closingOffers.map((item) => _buildMiniOffer(item)).toList()))),
        ]),
    ),
    );
  }
  Widget _buildFocusTodayRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical:0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(
              height: 145,
              child: _focusTodayInitialized
                  ? AspectRatio(
                aspectRatio: _focusTodayController.value.aspectRatio,
                child: VideoPlayer(_focusTodayController),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFocusToday() {
    const Color royalFuchsia = Color(0xFFA30262);

    return Container(
      width: double.infinity,
      color: royalFuchsia,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  // Top container
                  Container(
                    width: 145,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        focusTodayImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Bottom container
                  Container(
                    width: 145,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        focusTodayImages[index + 10],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.white,
        child: Text(
            title, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
                shadows: [
                  Shadow(color: Colors.orange.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2))
                ]
            )
        ));
  }

  Widget _buildBrandContainers(List<Map<String, String>> brandsList) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brandsList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(flex: 3,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)
                      ),
                      child: Image.asset(brandsList[index]['image']!, fit: BoxFit.contain))),

            ]
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscoverStores() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const
      BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFFF1F5),
                Color(0xFFFFE4EC)
              ]
          )
      ),
      child: Row(children: [
        Expanded(flex: 2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Discover\nOur Stores",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)
                  ),
                  SizedBox(height: 6),
                  Text("Curated by us,\ninspired by you",
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400)
                  )
                ]
            )
        ),
        const SizedBox(width: 9),
        Expanded(
            flex: 5,
            child: SizedBox(
                height: 120,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: discoverStores.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = discoverStores[index];
                      return Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          Expanded(
                              child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(
                                      bottom: Radius.circular(19),
                                      top: Radius.circular(19)),
                                  child: Image.asset(
                                      item,
                                      fit: BoxFit.cover,
                                      width: double.infinity
                                  )
                              )
                          ),
                        ]),
                      );
                    })
            )
        )
      ]
      ),
    );
  }

  Widget _buildVideoBanner() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white,
                  Colors.white.withOpacity(0.9),
                  const Color(0xFFF4D03F).withOpacity(0.50)],
                stops: const [0.0, 0.3, 1.0]
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: _videoInitialized
                      ? Center(
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildMiniDoubleRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFFF4D03F).withOpacity(0.50), const Color(0xFFF4D03F)], stops: const [0.0, 1.0]),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.hardEdge,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(14, (colIndex) {
              final int topIndex = colIndex;
              final int bottomIndex = colIndex + 14;
              final String topImage = topIndex < miniImages.length ? miniImages[topIndex] : 'assets/image/placeholder.png';
              final String bottomImage = bottomIndex < miniImages.length ? miniImages[bottomIndex] : 'assets/image/placeholder.png';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(width: 110, height: 90,
                          color: Colors.white, child: Image.asset(topImage, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.grey[200])))),
                  const SizedBox(height: 8),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(width: 110, height: 90, color: Colors.white,
                          child: Image.asset(
                              bottomImage, fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => Container(color: Colors.grey[200])))),
                ]),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildShopByCategorySection() {
    final List<String> topImages = shopImages.sublist(0, 8);
    final List<String> bottomImages = shopImages.sublist(8, 16);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFFF5C4B8), const Color(0xFFE2725B)], stops: const [0.0, 1.0]),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Center(child: const Text('Shop by category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF8C3B00)))),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: topImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final img = topImages[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], borderRadius: BorderRadius.circular(12)),
                  child: Image.asset(img, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.grey[200])),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Bottom independent scroller (8 items)
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: bottomImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final img = bottomImages[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], borderRadius: BorderRadius.circular(12)),
                  child: Image.asset(img, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.grey[200])),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildWhiteVideoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 150,
          child: _whiteVideoInitialized
              ? Center(
            child: AspectRatio(
              aspectRatio: _whiteVideoController.value.aspectRatio,
              child: VideoPlayer(_whiteVideoController),
            ),
          )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildGreenSliderRow() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFCCDA46),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 130,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount:  sliderImages.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final img = sliderImages[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.white,
                child: Image.asset(
                    img, fit: BoxFit.contain, errorBuilder: (c, o, s) => Container(color: Colors.grey[200])),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuperstar() {

    const Color goldStart = Color(0xFFF2C94C);
    const Color goldEnd = Color(0xFFDAA520);

    Widget buildTile(String imagePath) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 130,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0DFA8).withOpacity(0.6)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // fallback if image not found
              return Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image)),
              );
            },
          ),
        ),
      );
    }

    // guard to return an image or placeholder if index out of range
    String imageOrPlaceholder(int index) {
      if (index >= 0 && index < superstarImages.length) {
        return superstarImages[index];
      }
      return 'assets/image/placeholder.png';
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [goldStart, goldEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    'SUPERSTAR CATEGORIES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  width: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [goldStart, goldEnd]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: SizedBox(
              height: 34,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldEnd,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                ),
                onPressed: () {

                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Wishlist Now',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.indigo),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Row 1: indices 0..9
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final img = imageOrPlaceholder(index);
                return buildTile(img);
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final img = imageOrPlaceholder(10 + index);
                return buildTile(img);
              },
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final img = imageOrPlaceholder(20 + index);
                return buildTile(img);
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLastContainerRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_lastRowImages.length, (i) {
          final selected = (i == _lastSelectedIndex);
          final bg = selected ? _lastRowColors[i].withOpacity(0.14) : Colors.white;
          final border = selected ? Border.all(color: _lastRowColors[i], width: 2) : Border.all(color: Colors.transparent);

          return GestureDetector(
            onTap: () {
              // update visual selection
              setState(() {
                _lastSelectedIndex = i;
              });

              if (i == 0) {
                setState(() => _selectedCategoryIndex = 0);
                return;
              }
              if (i >= 1 && i <= 3) {
                setState(() => _selectedCategoryIndex = 2);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DestinationPage(index: i, imagePath: _lastRowImages[i])),
                );
                return;
              }
              if (i == 4) {

                setState(() => _selectedCategoryIndex = 1);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StoragePage()),
                );
                return;
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: border,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _lastRowImages[i],
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

              ],
            ),
          );
        }),
      ),
    );
  }
}
