import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Product.dart';
import '../Providers/Products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Edit-Product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _existingProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  bool isInit = true;
  var initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updatePage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _existingProduct = Provider.of<Products>(context, listen: false)
            .findProductById(productId);
        initValues = {
          'title': _existingProduct.title,
          'price': _existingProduct.price.toString(),
          'description': _existingProduct.description,
          // 'imageUrl': _existingProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _existingProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isvalid = _formKey.currentState.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState.save();
    if (_existingProduct.id == null) {
      Provider.of<Products>(context).addProduct(_existingProduct);
    } else {
      Provider.of<Products>(context)
          .updateProduct(_existingProduct.id, _existingProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updatePage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  _updatePage() {
    if (
        // (_imageUrlController.text.isEmpty) ||
        (!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith(
                'https')) /* ||
        (!_imageUrlController.text.endsWith('.jpeg') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.png'))*/
        ) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product Data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: initValues['title'],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Title'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a Title';
                  }
                  return null; //This is taken as there is no issue with the input
                },
                onSaved: (value) {
                  _existingProduct = Product(
                    id: _existingProduct.id,
                    title: value,
                    description: _existingProduct.description,
                    price: _existingProduct.price,
                    imageUrl: _existingProduct.imageUrl,
                    isFavourite: _existingProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Price'),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a Price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please Enter a number Greater than zero';
                  }
                  return null; //This is taken as there is no issue with the input
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _existingProduct = Product(
                    id: _existingProduct.id,
                    title: _existingProduct.title,
                    description: _existingProduct.description,
                    price: value.isEmpty ? 0 : double.parse(value),
                    imageUrl: _existingProduct.imageUrl,
                    isFavourite: _existingProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a description';
                  }
                  if (value.length <= 10) {
                    return 'Description should be at least 10 characters long';
                  }
                  return null; //This is taken as there is no issue with the input
                },
                onSaved: (value) {
                  _existingProduct = Product(
                    id: _existingProduct.id,
                    title: _existingProduct.title,
                    description: value,
                    price: _existingProduct.price,
                    imageUrl: _existingProduct.imageUrl,
                    isFavourite: _existingProduct.isFavourite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    // height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    // padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text('Enter Url'),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: initValues['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a imageUrl';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid Image URL';
                        }
                        // if (!value.endsWith('.jpeg') &&
                        //     !value.endsWith('.jpg') &&
                        //     !value.endsWith('.png')) {
                        //   return 'Please enter a valid Image URL';
                        // }
                        return null; //This is taken as there is no issue with the input
                      },
                      onSaved: (value) {
                        _existingProduct = Product(
                          id: _existingProduct.id,
                          title: _existingProduct.title,
                          description: _existingProduct.description,
                          price: _existingProduct.price,
                          imageUrl: value,
                          isFavourite: _existingProduct.isFavourite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
