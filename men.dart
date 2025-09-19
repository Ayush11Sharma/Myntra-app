// men.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'clothes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.lightBlue,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MenApp());
}

class MenApp extends StatelessWidget {
  const MenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenPage(),
    );
  }
}

class MenPage extends StatefulWidget {
  const MenPage({super.key});

  @override
  State<MenPage> createState() => _MenPageState();
}

class _MenPageState extends State<MenPage> {
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  late Timer _bannerTimer;

  late int _remainingSeconds;
  late Timer _saleTimer;
  final int _initialHours = 9;

  final ScrollController _scrollController = ScrollController();

  final List<String> bannerImagesMen = [
    'assets/men/banner1.png',
    'assets/men/banner2.png',
    'assets/men/banner3.png',
    'assets/men/banner4.png',
    'assets/men/banner5.png',
    'assets/men/banner6.png',
  ];

  final List<Map<String, String>> categoriesMen = [
    {'name': 'Casual', 'image': 'assets/men1/img.png'},
    {'name': 'Ethnic', 'image': 'assets/men1/img1.png'},
    {'name': 'Sports', 'image': 'assets/men1/img2.png'},
    {'name': 'Footwear', 'image': 'assets/men1/img3.png'},
    {'name': 'Essentials', 'image': 'assets/men1/img4.png'},
  ];

  final List<Map<String, String>> brandsMen = [
    {
      'name': 'MenBrand A',
      'subtitle': 'Under \$999',
      'image': '',
    },
    {
      'name': 'MenBrand B',
      'subtitle': 'Min. 30% OFF',
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'
    },
    {
      'name': 'MenBrand C',
      'subtitle': 'New',
      'image': 'https://images.unsplash.com/photo-1526178611021-4b42b2be2a0b?w=400'
    },
  ];

  final List<Map<String, String>> closingOffersMen = [
    {'logo': 'assets/men/lo1.png', 'image': 'assets/men/offer1.png', 'title': 'From \$499'},
    {'logo': 'assets/men/lo2.png', 'image': 'assets/men/offer2.png', 'title': 'Up to 60% OFF'},
    {'logo': 'assets/men/lo3.png', 'image': 'assets/men/offer3.png', 'title': 'Flat Deals'},
  ];

  final List<String> miniImagesMen = List.generate(16, (i) => 'assets/men7/img${i + 1}.png');
  final List<String> shopImagesMen = List.generate(16, (i) => 'assets/men/shop${i + 1}.png');
  final List<String> sliderImagesMen = List.generate(8, (i) => 'assets/men/slider${i + 1}.png');
  final List<String> Highlightimage = List.generate(7, (i) => 'assets/men2/mini${i + 1}.png');
  final List<String> featuredImages = List.generate(6, (i) => 'assets/men3/img${i + 1}.png');
  final List<String> SponsoredImages = List.generate(6, (i) => 'assets/men4/img${i + 1}.png');
  final List<String> discoverStores = List.generate(11, (i) => 'assets/men6/img${i + 1}.png');
  final List<String> superstarImagesMen = List.generate(30, (i) => 'assets/men/superstar${i + 1}.png');
  final List<String> focusTodayImagesMen = List.generate(10, (i) => 'assets/men5/img${i + 1}.png');
  final List<String> TOPRATEDImages = List.generate(3, (i) => 'assets/men10/img${i + 1}.png');
  final List<String> sliderImages =
  List.generate(8, (i) => 'assets/image6/img${i + 1}.png');
  // Video controllers
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  late VideoPlayerController _whiteVideoController;
  bool _whiteVideoInitialized = false;

  late VideoPlayerController _focusTodayController;
  bool _focusTodayInitialized = false;

  late VideoPlayerController _3xdiscountController;
  bool _3xdiscountInitialized = false;

  @override
  void initState() {
    super.initState();

    _resetSaleTimer();
    _startSaleTimer();

    _bannerTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_currentBannerIndex < bannerImagesMen.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(_currentBannerIndex,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });

    _scrollController.addListener(() => setState(() {}));

    _videoController = VideoPlayerController.asset('assets/video/VID_20250908_225356.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _videoInitialized = true);
        _videoController.setLooping(true);
        _videoController.play();
      });

    _whiteVideoController = VideoPlayerController.asset('assets/video/video1.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _whiteVideoInitialized = true);
        _whiteVideoController.setLooping(true);
        _whiteVideoController.play();
      });

    _focusTodayController = VideoPlayerController.asset('assets/video/VID.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _focusTodayInitialized = true);
        _focusTodayController.setLooping(true);
        _focusTodayController.play();
      });

    _3xdiscountController = VideoPlayerController.asset('assets/video/WhatsApp_video.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _3xdiscountInitialized = true);
        _3xdiscountController.setLooping(true);
        _3xdiscountController.play();
      });
  }

  void _resetSaleTimer() {
    _remainingSeconds = _initialHours * 3600;
  }

  void _startSaleTimer() {
    _saleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
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
    _3xdiscountController.dispose();
    _scroll_controller_safe_dispose();
    super.dispose();
  }

  void _scroll_controller_safe_dispose() {
    try {
      _scroll_controller_safe_dispose; // no-op to avoid analyzer warnings if replaced
      _scrollController.dispose();
    } catch (_) {}
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

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
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        const SizedBox(height: 4),
        Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.lightBlue,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlue,
                    Colors.lightBlueAccent,
                    Colors.white,
                  ],
                  stops: [0.0, 0.2, 1.0],
                ),
              ),
              child: Column(
                children: [
                  _buildDeliveryAddress(),
                  _buildSearchBar(),
                  _buildCategoryTabs(),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  _buildSmallCategories(),
                ],
              ),
            ),
            _buildMenBannerRow(),
            _buildBannerSlider(),
            const SizedBox(height: 24),
            _buildOfferBanner(),
            const SizedBox(height: 16),
            _buildBrandsTitle(),
            const SizedBox(height: 16),
            _buildBrandsList(),
            const SizedBox(height: 20),
            _buildHighlights(),
            const SizedBox(height: 20),
            _buildSectionHeader('FEATURED BRANDS'),
            _buildFeaturedBrands(),
            const SizedBox(height: 24),
            _buildFocusTodayRow(),
            _buildFocusToday(),
            const SizedBox(height: 12),
            _buildSectionHeader('SPONSORED BRANDS'),
            const SizedBox(height: 18),
            _buildSponsoredBrand(),
            const SizedBox(height: 12),
            _buildDiscoverStores(),
            const SizedBox(height: 16),
            _build3xdiscountRow(),
            _buildVideoBanner(),
            _buildMiniDoubleRow(),
            const SizedBox(height: 20),
            _buildShopByCategorySection(),
            const SizedBox(height: 12),
            _buildWhiteVideoRow(),
            _buildGreenSliderRow(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text('Deliver to your address', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey, width: 1),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search Men\'s wear',
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Image(image: AssetImage('assets/image/myntralogo.jpg'), fit: BoxFit.contain),
                ),
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
      ]),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildCategoryTab('All', false),
        _buildCategoryTab('Men', true),
        _buildCategoryTab('Women', false),
        _buildCategoryTab('Kids', false),
      ]),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey)),
        if (isSelected)
          Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 20, color: Colors.black),
      ],
    );
  }

  Widget _buildSmallCategories() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categoriesMen.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = categoriesMen[index];
          return Column(children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[200],
                image: DecorationImage(image: AssetImage(item['image']!), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(item['name']!, style: const TextStyle(fontSize: 12)),
          ]);
        },
      ),
    );
  }

  Widget _buildMenBannerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(image: AssetImage('assets/men1/img5.png'), fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        CarouselSlider(
          items: bannerImagesMen.map((imageUrl) {
            return Builder(builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                ]),
                child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imageUrl, fit: BoxFit.cover)),
              );
            });
          }).toList(),
          options: CarouselOptions(
            height: 270,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
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
            children: bannerImagesMen.asMap().entries.map((entry) {
              return GestureDetector(
                  onTap: () {
                    if (_bannerController.hasClients) {
                      _bannerController.animateToPage(entry.key, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    }
                  },
                  child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentBannerIndex ==
                              entry.key ? const Color.fromRGBO(0, 0, 0, 0.9) : const Color.fromRGBO(0, 0, 0, 0.4)
                      )
                  )
              );
            }
        ).toList()
        ),
      ]
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
            const Text('MEN SPECIAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                child: const Text('SALE', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 8),
          const Text('MIN. 40% OFF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          const SizedBox(height: 8),
          const Text('SPONSORED BY', style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          const Text('Flat Cashback Offer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildBrandsTitle() {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('CONTINUE BROWSING (MEN)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)));
  }

  Widget _buildBrandsList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: brandsMen.length,
        itemBuilder: (context, index) {
          final b = brandsMen[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  color: Colors.white),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(
                    flex: 3,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        child: CachedNetworkImage(
                          imageUrl: b['image']!,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(color: Colors.grey[200]),
                          errorWidget: (c, u, e) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                        ))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(b['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(b['subtitle']!, style: const TextStyle(fontSize: 10, color: Colors.grey))
                        ])))
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHighlights() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F8E7),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Text(
            "HIGHLIGHTS OF THE DAY",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                color: const Color(0xFFDAA520)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Highlightimage.length,
            itemBuilder: (context, index) {
              final img = Highlightimage[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                    image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.white,
        child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: const Color(0xFFDAA520))));
  }

  Widget _buildFeaturedBrands() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: featuredImages.length,
        itemBuilder: (context, index) {
          final imagePath = featuredImages[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                  color: Colors.white, boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFocusToday() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: [Color(0xFFD6213C), Color(0xFFE94B61)]),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: List.generate(10, (index) {
            final topImg = (index < focusTodayImagesMen.length) ? focusTodayImagesMen[index] : 'assets/image/placeholder.png';
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                    },
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(16),
                          child: Image.asset(topImg, fit: BoxFit.cover)),
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

  Widget _buildBrandContainers({required List<Map<String, String>> featuredList}) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: featuredList.length,
        itemBuilder: (context, index) {
          final item = featuredList[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ClothesPage()));
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))
              ]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(
                    flex: 3,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        child: Image.asset(item['image']!, fit: BoxFit.contain))),
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(item['title'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2))),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSponsoredBrand() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: SponsoredImages.length,
        itemBuilder: (context, index) {
          final imagePath = SponsoredImages[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscoverStores() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF1F5), Color(0xFFFFE4EC)])),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Discover\nOur Stores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text("Curated by us,\ninspired by you", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
            ])),
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
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                        },
                        child: Container(
                          width: 90,
                          height: 110,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            Expanded(
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19), top: Radius.circular(19)),
                                    child: Image.asset(item, fit: BoxFit.contain, width: double.infinity))),
                          ]),
                        ),
                      );
                    })))
      ]),
    );
  }

  Widget _build3xdiscountRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
              height: 220,
              child: _3xdiscountInitialized
                  ? AspectRatio(aspectRatio: _3xdiscountController.value.aspectRatio, child: VideoPlayer(_3xdiscountController))
                  : const Center(child: CircularProgressIndicator()))),
    );
  }

  Widget _buildVideoBanner() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, Colors.white.withOpacity(0.9), const Color(0xFFF4D03F).withOpacity(0.50)]),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 12.0, 0.0),
            child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: _videoInitialized ? AspectRatio(aspectRatio: _videoController.value.aspectRatio, child: VideoPlayer(_videoController)) : const Center(child: CircularProgressIndicator()))),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniDoubleRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 16.0, 8.0),
      child: Container(
        height: 380,
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9B1B75), Color(0xFFE754B3)]),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.hardEdge,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(8, (colIndex) {
            final int topIndex = colIndex;
            final int bottomIndex = colIndex + 8;
            final String topImage = topIndex < miniImagesMen.length ? miniImagesMen[topIndex] : 'assets/image/placeholder.png';
            final String bottomImage = bottomIndex < miniImagesMen.length ? miniImagesMen[bottomIndex] : 'assets/image/placeholder.png';
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(width: 130, height: 170, color: Colors.white, child: Image.asset(topImage, fit: BoxFit.cover)))),
                  const SizedBox(height: 8),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(width: 130, height: 170, color: Colors.white, child: Image.asset(bottomImage, fit: BoxFit.cover)))),
                ]));
          })),
        ),
      ),
    );
  }

  Widget _buildShopByCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: const Center(child: Text('TOP RATED BRANDS',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                    color: const Color(0xFFDAA520))))),
        const SizedBox(height: 10),
        SizedBox(
            height: 240,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: TOPRATEDImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final img = TOPRATEDImages[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                    },
                    child: ClipRRect(borderRadius: BorderRadius.circular(12),
                        child: Container(
                            width: 140, height: 190,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(12)
                            ), child: Image.asset(img, fit: BoxFit.cover))),
                  );
                })),
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
          child: SizedBox(height: 150, child: _whiteVideoInitialized ? AspectRatio(aspectRatio: _whiteVideoController.value.aspectRatio, child: VideoPlayer(_whiteVideoController)) : const Center(child: CircularProgressIndicator()))),
    );
  }

  Widget _buildGreenSliderRow() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFCCDA46),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
          height: 250,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: sliderImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final img = sliderImages[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
                  },
                  child: ClipRRect(borderRadius: BorderRadius.circular(12),
                      child: Container(width: 140, height: 240, color: Colors.white,
                          child: Image.asset(img, fit: BoxFit.cover))),
                );
              })),
    );
  }

  Widget _buildFocusTodayRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(height: 145, child: _focusThisInitializeOrLoader())),
    );
  }

  Widget _focusThisInitializeOrLoader() {
    if (_focusTodayInitialized) {
      return AspectRatio(aspectRatio: _focusTodayController.value.aspectRatio, child: VideoPlayer(_focusTodayController));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildSuperstar() {
    const Color goldStart = Color(0xFFF2C94C);
    const Color goldEnd = Color(0xFFDAA520);

    Widget buildTile(String imagePath) {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage()));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 130,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0DFA8).withOpacity(0.6)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)))),
          ),
        ),
      );
    }

    String imageOrPlaceholder(int index) {
      if (index >= 0 && index < superstarImagesMen.length) {
        return superstarImagesMen[index];
      }
      return 'assets/image/placeholder.png';
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(children: [
        Center(
            child: Column(children: [
              ShaderMask(shaderCallback: (bounds) => LinearGradient(colors: [goldStart, goldEnd]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)), blendMode: BlendMode.srcIn, child: const Text('SUPERSTAR CATEGORIES', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2))),
              const SizedBox(height: 6),
              Container(height: 2, width: 140, decoration: BoxDecoration(gradient: LinearGradient(colors: [goldStart, goldEnd]))),
            ])),
        const SizedBox(height: 10),
        Center(
            child: SizedBox(
                height: 34,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: goldEnd, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), elevation: 2),
                    onPressed: () {},
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [Text('Wishlist Now', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 16, color: Colors.indigo)])))),
        const SizedBox(height: 14),
        // Row 1
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
                })),
        const SizedBox(height: 12),
        // Row 2
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
                })),
        const SizedBox(height: 12),
        // Row 3
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
                })),
      ]),
    );
  }
}
