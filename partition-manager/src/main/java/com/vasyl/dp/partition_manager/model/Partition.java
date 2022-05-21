package com.vasyl.dp.partition_manager.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Entity
@Getter
@Setter
@ToString
@Table(name = "partitions")
public class Partition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private int number;

    @Column
    private boolean nextInLineToUse;

    public Partition(int number, boolean nextInLineToUse) {
        this.number = number;
        this.nextInLineToUse = nextInLineToUse;
    }

    public Partition() {}
}
