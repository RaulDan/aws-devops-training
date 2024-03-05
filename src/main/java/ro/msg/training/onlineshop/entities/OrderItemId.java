package ro.msg.training.onlineshop.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.io.Serializable;

@Data
@Embeddable
public class OrderItemId implements Serializable {

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "order_id")
    private Order order;
}
