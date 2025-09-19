// storage.dart
import 'package:flutter/material.dart';

/// CartItem - represents an item in cart
class CartItem {
  final String title;
  final String imagePath;
  final String size;
  int qty;
  final int price; // numeric price per unit

  CartItem({
    required this.title,
    required this.imagePath,
    required this.size,
    required this.price,
    this.qty = 1,
  });

  int get total => price * qty;
}

/// Simple Cart singleton (ChangeNotifier) so UI can listen for updates.
class Cart extends ChangeNotifier {
  Cart._private();
  static final Cart instance = Cart._private();

  final List<CartItem> _items = [];
  String address = '';

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    // if same item (same title + size + image) exists, increase qty
    final idx = _items.indexWhere((e) =>
    e.title == item.title && e.size == item.size && e.imagePath == item.imagePath);
    if (idx != -1) {
      _items[idx].qty += item.qty;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void increaseQty(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].qty++;
      notifyListeners();
    }
  }

  void decreaseQty(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].qty > 1) {
        _items[index].qty--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  int get itemCount => _items.fold(0, (s, e) => s + e.qty);

  int get totalPrice => _items.fold(0, (s, e) => s + e.total);
}

/// StoragePage - shows items in cart, header with address + count + total; Place Order button.
class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  @override
  void initState() {
    super.initState();
    // nothing else — we use Cart.instance as Listenable
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHOPPING BAG', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: AnimatedBuilder(
        animation: Cart.instance,
        builder: (context, _) {
          final items = Cart.instance.items;
          if (items.isEmpty) {
            // empty state: show placeholder image (assets/image10)
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/image9/img.png', width: 200, height: 200, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 200, height: 200, color: Colors.grey[200])),
                  const SizedBox(height: 12),
                  const Text('No items in your bag', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          final int totalPrice = Cart.instance.totalPrice;
          final int totalCount = Cart.instance.itemCount;

          return Column(
            children: [
              // header with address and progress indicator (like screenshot)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            Cart.instance.address.isNotEmpty ? Cart.instance.address : 'Deliver to: Your address',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // you can allow change by navigating to address entry screen in your app
                          },
                          child: const Text('Change', style: TextStyle(color: Colors.pink)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    // summary row: count & total
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$totalCount items selected for order', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('₹${_formatCurrency(totalPrice)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // list of items
                    ...List.generate(items.length, (index) {
                      final it = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // checkbox or selected icon (left)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.check_box, color: Colors.pink),
                            ),

                            // image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(it.imagePath, width: 92, height: 92, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 92, height: 92, color: Colors.grey[200]),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text('Sold by: SHOP', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                    const SizedBox(height: 8),

                                    // size + qty + small remove
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text('Size: ${it.size}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ),
                                        const SizedBox(width: 8),

                                        // qty controls
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => Cart.instance.decreaseQty(index),
                                                child: const Icon(Icons.remove, size: 16),
                                              ),
                                              const SizedBox(width: 6),
                                              Text('${it.qty}'),
                                              const SizedBox(width: 6),
                                              GestureDetector(
                                                onTap: () => Cart.instance.increaseQty(index),
                                                child: const Icon(Icons.add, size: 16),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const Spacer(),

                                        // remove button
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () => Cart.instance.removeAt(index),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // price row
                                    Row(
                                      children: [
                                        Text('₹${_formatCurrency(it.price)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Text('₹${_formatCurrency((it.price * 2))}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade400)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text('${((it.price) * 100 ~/ (it.price * 2))}% OFF', style: const TextStyle(color: Colors.orange, fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // bottom place order bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('₹${_formatCurrency(totalPrice)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              // Place order action
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Place Order'),
                                  content: Text('You are placing order of $totalCount items for ₹${_formatCurrency(totalPrice)}'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                    ElevatedButton(
                                      onPressed: () {
                                        // clear cart after order (simple behavior)
                                        Cart.instance.clear();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Confirm'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('PLACE ORDER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
