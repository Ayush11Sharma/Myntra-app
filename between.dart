// between.dart
import 'package:flutter/material.dart';
import 'BuyNow.dart';
import 'storage.dart'; // used to access Cart to add items and navigate to StoragePage

class BetweenPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String price;
  final String? address;

  const BetweenPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.price,
    this.address,
  }) : super(key: key);

  @override
  State<BetweenPage> createState() => _BetweenPageState();
}

class _BetweenPageState extends State<BetweenPage> {
  String _selectedSize = 'M';
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final Map<String, String> _leftCounts = {
    'XS': '1 left',
    'S': '3 left',
  };

  // compute delivery range: start = now + 2 days, end = now + 7 days
  late final DateTime _startDelivery;
  late final DateTime _endDelivery;

  // whether this item (title+image+size) is already added to bag
  bool _isAddedToBag = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDelivery = now.add(const Duration(days: 2));
    _endDelivery = now.add(const Duration(days: 7));

    // set initial _isAddedToBag if item already present in Cart
    _isAddedToBag = _checkItemInCart();
  }

  // check cart for same title+image+size
  bool _checkItemInCart() {
    try {
      return Cart.instance.items.any((it) =>
      it.title == widget.title &&
          it.imagePath == widget.imagePath &&
          it.size == _selectedSize);
    } catch (_) {
      return false;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  // helper to parse price string like "₹1,234" or "₹503" -> int 1234/503
  int _parsePrice(String p) {
    final digits = p.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  // Adds item to cart and marks _isAddedToBag = true
  void _addToBag() {
    final int priceValue = _parsePrice(widget.price);
    Cart.instance.addItem(
      CartItem(
        title: widget.title,
        imagePath: widget.imagePath,
        size: _selectedSize,
        price: priceValue,
        qty: 1,
      ),
    );

    // store address if provided
    if (widget.address != null && widget.address!.trim().isNotEmpty) {
      Cart.instance.address = widget.address!;
    }

    setState(() {
      _isAddedToBag = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to Bag'), duration: Duration(seconds: 2)),
    );
  }

  // Navigate to StoragePage
  void _goToBag() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StoragePage()),
    ).then((_) {
      // When returning from StoragePage, re-check if item still exists in cart
      setState(() {
        _isAddedToBag = _checkItemInCart();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedAddress = widget.address ?? 'Deliver to your address';
    final deliveryText =
        'Delivery between ${_formatDate(_startDelivery)} - ${_formatDate(_endDelivery)}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // top fixed row (logo, title, back)
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
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      widget.imagePath,
                      height: MediaQuery.of(context).size.height * 0.69,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Printed Oversized T-shirt',
                              style: TextStyle(color: Colors.grey.shade700,fontSize: 15)),
                        ]),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(widget.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('Only few left!', style: TextStyle(color: Colors.orange)),
                      ]),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Select Size row
                  const Text('Select Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: _sizes.map((s) {
                      final selected = _selectedSize == s;
                      return GestureDetector(
                        onTap: () {
                          // update selected size and update _isAddedToBag if necessary
                          setState(() {
                            _selectedSize = s;
                            _isAddedToBag = _checkItemInCart();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? Colors.pink.shade50 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: selected ? Colors.pink : Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Text(s, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(_leftCounts[s] ?? '', style: TextStyle(color: Colors.orange.shade700, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      // BUY NOW button (navigates to BuyNowPage)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyNowPage(
                                  title: widget.title,
                                  imagePath: widget.imagePath,
                                  price: widget.price,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.pink),
                          label: const Text('Buy Now', style: TextStyle(color: Colors.pink)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.pink),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ADD TO BAG / GO TO BAG button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_isAddedToBag) {
                              // already added: go to bag
                              _goToBag();
                            } else {
                              // not added yet: add to bag
                              _addToBag();
                            }
                          },
                          icon: Icon(_isAddedToBag ? Icons.shopping_bag : Icons.shopping_cart, color: Colors.white),
                          label: Text(_isAddedToBag ? 'Go to Bag' : 'Add to Bag', style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              displayedAddress,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // simply pop back so user can change address in previous screen
                              Navigator.pop(context);
                            },
                            child: const Text('Change', style: TextStyle(color: Colors.pink)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 3)],
                        ),
                        child: Row(children: [

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.local_shipping_outlined, size: 22, color: Colors.black87),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('STANDARD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 6),
                              Text(deliveryText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ]),
                          ),

                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('MRP ₹1999', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500)),
                            const SizedBox(height: 6),
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(widget.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 6),
                              Text('(65% OFF)', style: TextStyle(color: Colors.orange.shade700)),
                            ]),
                          ]),

                        ]),
                      ),

                      const SizedBox(height: 12),

                      // Pay on Delivery & Return rows
                      Row(children: [
                        const Icon(Icons.payments_outlined, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(child: Text('Pay on Delivery is available', style: const TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0),
                        child: Text('₹10 additional fee applicable', style: TextStyle(color: Colors.grey.shade600)),
                      ),

                      const SizedBox(height: 12),

                      Row(children: [
                        const Icon(Icons.autorenew, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(child: Text('Hassle free 7 days Return & Exchange', style: const TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                    ]),
                  ),

                  const SizedBox(height: 18),

                  // product details block (simple)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('Fit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 6),
                      Text('Oversized'),
                      SizedBox(height: 12),
                      Text('Fabrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 6),
                      Text('Cotton, Polyester'),
                      SizedBox(height: 12),
                      Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 6),
                      Text('Regular length\nKnitted cotton fabric\nRound neck'),
                      SizedBox(height: 12,),
                      Text('Size & Fit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 6,),
                      Text('Oversized',style: TextStyle(fontSize: 17),), SizedBox(height: 16,),
                      Text("The model(height 6') is wearing a size M",style: TextStyle(fontSize: 17),),
                      SizedBox(height: 12,),
                      Text('Material & Care',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 6,),
                      Text('60% Cotton 40% Polyester',style: TextStyle(fontSize: 17),),
                      SizedBox(height: 30,),
                      Text('Machine Wash',style: TextStyle(fontSize: 16),),
                    ]),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
