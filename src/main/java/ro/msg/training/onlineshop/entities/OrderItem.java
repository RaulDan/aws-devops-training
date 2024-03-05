package ro.msg.training.onlineshop.entities;

import lombok.Data;

import javax.persistence.*;

@Data
@Entity
public class OrderItem {
    @Id
    private OrderItemId id;

    private int quantity;

    public static OrderItem ofProductAndQuantity(Product product, int quantity) {
        var id = new OrderItemId();
        id.setProduct(product);
        var item = new OrderItem();
        item.setQuantity(quantity);
        item.setId(id);
        return item;
    }
}
