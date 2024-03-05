package ro.msg.training.onlineshop.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import ro.msg.training.onlineshop.entities.Order;

public interface OrderRepository extends JpaRepository<Order, String> {
}
