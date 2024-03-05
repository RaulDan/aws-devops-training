package ro.msg.training.onlineshop.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import ro.msg.training.onlineshop.entities.Product;

public interface ProductRepository extends JpaRepository<Product, String> {
}
