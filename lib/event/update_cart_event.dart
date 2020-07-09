
import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/model/product.dart';

class UpdateCartEvent extends BaseEvent {
  Product product;
  UpdateCartEvent(this.product);
}
