import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// 1. Modelo de Produto
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

// 2. Estado da Aplicação (Gerenciamento de Estado)
class AppState extends ChangeNotifier {
  List<Product> _products = [
    Product(
      id: '1',
      name: 'Smartphone X',
      price: 1999.99,
      imageUrl: 'assets/imagens/smatphonex.jpg',
      description: 'Último modelo com câmera de 108MP',
    ),
    Product(
      id: '2',
      name: 'Notebook Pro',
      price: 4599.99,
      imageUrl: 'assets/imagens/notbookpro.jpg',
      description: '16GB RAM, SSD 512GB, Processador i7',
    ),
    Product(
      id: '3',
      name: 'Fone Bluetooth',
      price: 299.99,
      imageUrl: 'assets/imagens/fone.jpg',
      description: 'Cancelamento de ruído ativo',
    ),
    Product(
      id: '4',
      name: 'Smart TV 55"',
      price: 2899.99,
      imageUrl: 'assets/imagens/smart55.jpg',
      description: '4K HDR, Android TV',
    ),
    Product(
      id: '5',
      name: 'Console de Games',
      price: 2499.99,
      imageUrl: 'assets/imagens/nintendo.jpg',
      description: '1TB SSD, Controle sem fio incluso',
    ),
    Product(
      id: '6',
      name: 'Câmera DSLR',
      price: 3599.99,
      imageUrl: 'assets/imagens/cameradsr.jpg',
      description: '24.2MP, Gravação 4K',
    ),
  ];

  List<Product> _favorites = [];
  List<Product> _cartItems = [];

  // Getters para acessar os dados
  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  List<Product> get cartItems => _cartItems;

  // Métodos para manipular favoritos
  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners(); // Notifica os widgets ouvintes para reconstruírem
  }

  // Métodos para manipular carrinho
  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

// 3. Widget Principal da Aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(), // Provê o estado para toda a app
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          useMaterial3: true,
          // Configuração do esquema de cores no estilo Mercado Livre
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFFFF159), // Amarelo principal
            primary: Color(0xFFFFF159),
            secondary: Color(0xFF3483FA), // Azul para botões
          ),
          // Configuração específica da AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFFFF159),
            elevation: 0, // Remove sombra
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

// 4. Página Principal com Navegação
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice da aba selecionada
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Seleciona a página com base no índice
    Widget page;
    switch (_selectedIndex) {
      case 0: page = ProductListPage(searchQuery: _searchController.text); break;
      case 1: page = FavoritesPage(); break;
      case 2: page = SettingsPage(); break;
      default: throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        // Barra de busca no estilo Mercado Livre
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar produtos...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              Container(width: 1, height: 24, color: Colors.grey[300]),
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.grey), 
                onPressed: () {},
              ),
            ],
          ),
        ),
        actions: [
          // Ícone do carrinho com contador
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart, color: Colors.black87),
                Positioned(
                  right: 0,
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      return appState.cartItems.isNotEmpty
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Color(0xFF3483FA),
                              child: Text(
                                appState.cartItems.length.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                ),
              ],
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage())),
          ),
        ],
      ),
      body: page,
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Conta'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF3483FA), // Azul
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// 5. Página de Lista de Produtos
class ProductListPage extends StatelessWidget {
  final String searchQuery;

  const ProductListPage({required this.searchQuery, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    
    // Filtra produtos baseado na busca
    var products = appState.products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Exibe os produtos em grid
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}

// 6. Card de Produto Individual
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    bool isFavorite = appState.favorites.contains(product);

    return Card(
      elevation: 1,
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagem do produto com ícone de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () => appState.toggleFavorite(product),
                ),
              ),
            ],
          ),
          // Detalhes do produto
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontSize: 14), maxLines: 2),
                SizedBox(height: 4),
                Text('R\$${product.price.toStringAsFixed(2)}', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('em 12x de R\$${(product.price / 12).toStringAsFixed(2)} sem juros',
                    style: TextStyle(color: Colors.green, fontSize: 12)),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3483FA),
                    minimumSize: Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () {
                    appState.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} adicionado ao carrinho'),
                        backgroundColor: Color(0xFFFFF159),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text('Comprar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 7. Página de Favoritos
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Você ainda não tem favoritos', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Toque no coração dos produtos para adicionar', 
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        var product = appState.favorites[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Image.asset(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text('R\$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => appState.toggleFavorite(product),
            ),
          ),
        );
      },
    );
  }
}

// 8. Página do Carrinho
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        backgroundColor: Color(0xFFFFF159),
      ),
      body: Column(
        children: [
          Expanded(
            child: appState.cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Seu carrinho está vazio', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Adicione produtos para ver aqui', 
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: appState.cartItems.length,
                    itemBuilder: (context, index) {
                      var product = appState.cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: Image.asset(
                            product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle: Text('R\$${product.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => appState.removeFromCart(product),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Rodapé do carrinho (total e botão de compra)
          if (appState.cartItems.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: TextStyle(fontSize: 16)),
                      Text('R\$${appState.cartItems.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Frete grátis', style: TextStyle(color: Colors.green)),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3483FA),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {
                        appState.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Compra finalizada com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Finalizar compra', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// 9. Página de Configurações
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF3483FA),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Minha conta'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Endereços'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Formas de pagamento'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notificações'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Ajuda'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Sobre o aplicativo'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}