package com.vasyl.dp.partition_manager.repository;

import com.vasyl.dp.partition_manager.model.Partition;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PartitionRepository extends JpaRepository<Partition, Long> {

    Partition findByNumber(int number);
    Partition findByNextInLineToUse(boolean nextInLineToUse);

}
