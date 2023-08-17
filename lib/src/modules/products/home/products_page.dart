import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/ui/helpers/deboucer.dart';
import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/base_header.dart';
import 'products_controller.dart';
import 'widgets/product_item.dart';

class ProdusctsPage extends StatefulWidget {
  const ProdusctsPage({super.key});

  @override
  State<ProdusctsPage> createState() => _ProdusctsPageState();
}

class _ProdusctsPageState extends State<ProdusctsPage> with Loader, Messages {
  final controller = Modular.get<ProductsController>();
  late final ReactionDisposer statusDispose;
  final debouncer = Deboucer(milliseconds: 10000);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusDispose = reaction((_) => controller.status, (status) {
        switch (status) {
          case ProductStateStatus.initial:
            break;
          case ProductStateStatus.loading:
            showLoader();
            break;
          case ProductStateStatus.loaded:
            hideLoader();
            break;
          case ProductStateStatus.error:
            hideLoader();
            showError('Erro ao buscar produtos');
            break;
        }
      });
    });
    controller.loadProducts();

    super.initState();
  }

  @override
  void dispose() {
    statusDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          BaseHeader(
            title: 'ADEMINISTRAR PRODUTOS',
            buttonLabel: 'ADICIONAR PRODUTOS',
            buttonPressed: () {},
            searchChange: (value) {
              debouncer.call(() {
                controller.filterByName(value);
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                return GridView.builder(
                  itemCount: controller.products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 280,
                    mainAxisSpacing: 20,
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ProductItem(product: controller.products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
