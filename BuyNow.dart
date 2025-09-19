// lib/BuyNow.dart
import 'dart:math';
import 'package:flutter/material.dart';

class BuyNowPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String price;

  const BuyNowPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.price,
  }) : super(key: key);

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  late final int basePrice;
  late int mrp;
  late int extra; // the random added amount
  final int platformFee = 25;

  bool couponApplied = false;
  int couponDiscount = 0;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    basePrice = _parsePrice(widget.price);
    extra = _randomExtra(); // 500..1500 multiple of 100
    mrp = basePrice + extra;
  }

  // parse "₹1,234" -> 1234
  int _parsePrice(String p) {
    final digits = p.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  int _randomExtra() {

    return (_random.nextInt(11) + 5) * 100;
  }

  String _formatCurrency(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    int len = s.length;
    int first = len % 3;
    if (first == 0) first = 3;
    buffer.write(s.substring(0, first));
    for (int i = first; i < len; i += 3) {
      buffer.write(',');
      buffer.write(s.substring(i, i + 3));
    }
    return buffer.toString();
  }

  String _formatDate(DateTime d) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${d.day} ${months[d.month - 1]}";
  }

  void _applyCoupon() {
    if (couponApplied) return;
    setState(() {

      final subtotal = basePrice + platformFee;
      couponDiscount = (subtotal * 0.15).floor(); // 15%
      couponApplied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coupon applied — 15% discount')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discountOnMrp = extra;
    final subtotalBeforeCoupon = basePrice + platformFee;
    final total = subtotalBeforeCoupon - couponDiscount;
    final totalSaving = discountOnMrp + couponDiscount;

    final today = DateTime.now();
    final deliveryStart = today.add(const Duration(days: 7));
    final deliveryEnd = today.add(const Duration(days: 9));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Review Order",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // You're saving
            Container(
              width: double.infinity,
              color: const Color(0xFFE9F7EF), // light green bg like screenshot
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A)), // green check
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "You're saving ₹${_formatCurrency(totalSaving)}",
                      style: const TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(widget.imagePath, width: 64, height: 64, fit: BoxFit.cover),
                  ),
                  title: Text("Delivery by ${_formatDate(deliveryStart)} - ${_formatDate(deliveryEnd)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Size: OneSize"),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: const [
                        Icon(Icons.card_giftcard, color: Colors.pink),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Save ₹105 with TRAVEL2SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("15% off on minimum purchase of Rs. 499", style: TextStyle(color: Colors.grey.shade700)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Text("All Coupons >", style: TextStyle(color: Colors.pink.shade400)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _applyCoupon,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.pink.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: Text(couponApplied ? "Applied" : "Apply", style: TextStyle(color: Colors.pink.shade400)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Price Details", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Total MRP row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text("Total MRP"),
                          const SizedBox(width: 6),
                          // small info icon (optional)
                          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
                        ]),
                        Text("₹${_formatCurrency(mrp)}"),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Discount on MRP row (with Know More link)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text("Discount on MRP"),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // show dialog or info
                            },
                            child: Text("Know More", style: TextStyle(color: Colors.pink.shade400)),
                          ),
                        ]),
                        Text(
                          "-₹${_formatCurrency(discountOnMrp)}",
                          style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Coupon Discount"),
                        couponApplied
                            ? Text("-₹${_formatCurrency(couponDiscount)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                            : GestureDetector(
                          onTap: _applyCoupon,
                          child: Text("Apply Coupon", style: TextStyle(color: Colors.pink.shade400)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text("Platform & Event Fee"),
                          const SizedBox(width: 8),
                          GestureDetector(
                              onTap: () {},
                              child: Text("Know More", style: TextStyle(color: Colors.pink.shade400))),
                        ]),
                        Text("₹${_formatCurrency(platformFee)}"),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("₹${_formatCurrency(total)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F7EF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade50),
                ),
                child: Text(
                  "You're Saving ₹${_formatCurrency(totalSaving)}",
                  style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // proceed to payment flow (not implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Proceed to pay ₹${_formatCurrency(total)}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text("Confirm & Pay ₹${_formatCurrency(total)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
