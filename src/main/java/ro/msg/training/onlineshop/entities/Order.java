package ro.msg.training.onlineshop.entities;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Entity
public class Order {

    @Id
    private String id;

    private LocalDateTime dateTime;

    private String customer;

    @OneToMany(mappedBy = "id.order", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<OrderItem> items;

    public static Order ofItems(List<OrderItem> items) {
        var order = new Order();
        order.setId(UUID.randomUUID().toString());
        order.setDateTime(LocalDateTime.now());
        order.setItems(items);
        items.forEach(item -> item.getId().setOrder(order));
        return order;
    }
}
