import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({Key? key}) : super(key: key);
  static const routeName = '/edit-products';

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {

  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _initvalues = {
    'title' : '',
    'description' : '',
     'price' : '',
    'imageUrl': ''
  };

  var _isInit = true;
  var isLoding = false;

  var _editProduct = Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments ;
      if(productId != null) {
        _editProduct = Provider.of<Products>(context, listen: false).findById(productId as String);
        _initvalues = {
          'title' : _editProduct.title,
          'price' : _editProduct.price.toString(),
          'description' : _editProduct.description,
          // 'imageUrl' : _editProduct.imageUrl
          'imageUrl' : ''
        };
        _imageController.text = _editProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImage);
    _imageController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if(!_imageFocusNode.hasFocus) {setState(() {});}
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if(!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoding = true;
    });
    if(_editProduct.id != '') {
      Provider.of<Products>(context, listen: false).update( _editProduct.id ,_editProduct);
      setState(() {
        isLoding = false;
      });
      Navigator.of(context).pop();
    }else{
      Provider.of<Products>(context, listen: false)
          .addProduct(_editProduct)
          .catchError((error) {
            return showDialog(
              context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('error occurred'),
                  content: const Text('something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () { Navigator.of(ctx).pop();},
                        child: const Text('OK'),
                    )
                  ],
                ),
            );
      })
           .then((_) {
        setState(() {
          isLoding = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Edit Products', style: Theme.of(context).textTheme.headline1,),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: isLoding ? const Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initvalues['title'],
                  validator: (value) {
                    if(value!.isEmpty) {
                      return 'Enter title of the product';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Title',),
                    hintText: 'example: A shirt...',
                  ),
                  onSaved: (value) {
                    _editProduct = Product(
                      title: value!,
                      id: _editProduct.id,
                      isFavorite : _editProduct.isFavorite,
                      description: _editProduct.description,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: _initvalues['price'],
                  validator: (value) {
                    if(value!.isEmpty) {
                      return 'Enter price of the product';
                    }
                    if(double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if(double.parse(value) <= 0) {
                      return 'enter a number greater than 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Price'),
                  ),
                  onSaved: (value) {
                    _editProduct = Product(
                      title: _editProduct.title,
                      id: _editProduct.id,
                      isFavorite : _editProduct.isFavorite,
                      description: _editProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: _initvalues['description'],
                  validator: (value) {
                    if(value!.isEmpty) {
                      return 'Enter description of the product';
                    }
                    if(value.length < 10) {
                      return 'Should be greater than 10 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.newline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Description',),
                  ),
                  onSaved: (value) {
                    _editProduct = Product(
                      title: _editProduct.title,
                      id: _editProduct.id,
                      isFavorite : _editProduct.isFavorite,
                      description: value!,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget> [
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageController.text.isEmpty ? const Text('Enter a URl') : FittedBox(child: Image.network(_imageController.text, fit: BoxFit.cover,))
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Enter image URL of the product';
                          }
                          if(!value.startsWith('http') && !value.startsWith('https')) {
                            return 'Enter valid url';
                          }
                          if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jepg')) {
                            return 'Please enter valid URL';
                          }
                          return null;
                        },
                        controller: _imageController,
                        focusNode: _imageFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text('Image URL'),
                        ),
                        onEditingComplete: () {setState(() {});},
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            title: _editProduct.title,
                            id: _editProduct.id,
                            isFavorite : _editProduct.isFavorite,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value!,
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
