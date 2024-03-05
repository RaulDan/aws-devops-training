package ro.msg.training.onlineshop.controllers;

import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ro.msg.training.onlineshop.entities.Order;
import ro.msg.training.onlineshop.entities.OrderItem;
import ro.msg.training.onlineshop.entities.Product;
import ro.msg.training.onlineshop.repositories.OrderRepository;
import ro.msg.training.onlineshop.repositories.ProductRepository;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1")
public class ShopController {
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;

    @GetMapping("/products")
    public List<Product> listProducts() {
        return productRepository.findAll();
    }

    @PostMapping("/orders")
    public Order createOrder(@RequestBody Map<String, Integer> productQuantities, Principal principal) {
        var products = productRepository.findAllById(productQuantities.keySet())
                .stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        if (productQuantities.keySet().stream().anyMatch(id -> !products.containsKey(id))) {
            throw new RuntimeException("Order contains unknown products!");
        }
        var order = Order.ofItems(productQuantities.entrySet().stream()
                .map(e -> OrderItem.ofProductAndQuantity(products.get(e.getKey()), e.getValue()))
                .collect(Collectors.toList()));
        order.setCustomer(principal.getName());
        return orderRepository.save(order);
    }

    @GetMapping("/orders/{id}")
    public Order readOrderById(@PathVariable String id, Principal principal) {
        var order = this.orderRepository.findById(id).orElseThrow(() -> new RuntimeException("Order not found"));
        if (order.getCustomer().equalsIgnoreCase(principal.getName())) {
            return order;
        } else {
            throw new RuntimeException("The order belongs to a different customer");
        }
    }

    @GetMapping("/me")
    public MeResponse readMe(Principal principal) {
        return new MeResponse(principal.getName());
    }

    @Data
    @RequiredArgsConstructor
    static class MeResponse {
        private final String username;
    }
}
