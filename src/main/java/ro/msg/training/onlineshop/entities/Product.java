package ro.msg.training.onlineshop.entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@Entity
public class Product {

    @Id
    private String id;

    private String name;
}
