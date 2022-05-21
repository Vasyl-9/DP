package com.vasyl.dp.partition_manager.service;

import static java.util.Objects.isNull;
import com.vasyl.dp.partition_manager.exceptions.TopicNotFoundException;
import com.vasyl.dp.partition_manager.model.Partition;
import com.vasyl.dp.partition_manager.repository.PartitionRepository;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import javax.annotation.PostConstruct;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.PartitionInfo;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class PartitionService {

    @Value("${app.kafka.topic-name}")
    private String topicName;

    @Value("${app.kafka.bootstrap-servers}")
    private String bootstrapServers;

    Logger log = LoggerFactory.getLogger(PartitionService.class);

    private final PartitionRepository partitionRepository;

    public PartitionService(PartitionRepository partitionRepository) {
        this.partitionRepository = partitionRepository;
    }

    @PostConstruct
    private void initializingNextPartition(){
        actualizingExistingPartitions();
        Partition partition = partitionRepository.findByNextInLineToUse(true);
        if (isNull(partition)) {
            partition = partitionRepository.findByNumber(0);
            partition.setNextInLineToUse(true);
            partitionRepository.save(partition);
        }
    }


    public void actualizingExistingPartitions() {
        List<Partition> existsPartitions = partitionRepository.findAll();
        List<Integer> availablePartitionNumbers = getPartitionsList();
        List<Partition> needToAddPartitionsList = new LinkedList<>();
        if (existsPartitions.isEmpty()) {
            for (int partitionNumber : availablePartitionNumbers) {
                needToAddPartitionsList.add(new Partition(partitionNumber, false));
            }
            partitionRepository.saveAll(needToAddPartitionsList);
        } else {
            for (Partition existsPartition : existsPartitions) {
                if (availablePartitionNumbers.contains(existsPartition.getNumber())) {
                    availablePartitionNumbers.remove(Integer.valueOf(existsPartition.getNumber()));
                } else {
                    partitionRepository.delete(existsPartition);
                }
            }
            if (!availablePartitionNumbers.isEmpty()) {
                for(Integer availablePartitionNumber : availablePartitionNumbers){
                    partitionRepository.save(new Partition(availablePartitionNumber, false));
                }
            }
        }
    }

    public Partition getPartitionByNextInLineToUse(){
        return partitionRepository.findByNextInLineToUse(true);
    }

    public void moveOnToNextPartition(){
        Partition partition = getPartitionByNextInLineToUse();

        int partitionNumber = partition.getNumber();
        partition.setNextInLineToUse(false);
        partitionRepository.save(partition);
        int nextPartitionNumber = partitionNumber + 1;
        Partition nextPartition = partitionRepository.findByNumber(nextPartitionNumber);
        if (isNull(nextPartition)){
            log.info("Partition number: {}  does exists. Start from number 0", nextPartitionNumber);
            nextPartition = partitionRepository.findByNumber(0);
        }
        nextPartition.setNextInLineToUse(true);
        partitionRepository.save(nextPartition);
    }

    public List<Integer> getPartitionsList() {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrapServers);
        props.put("key.deserializer", StringDeserializer.class.getName());
        props.put("value.deserializer", StringDeserializer.class.getName());
        props.put("group.id", "partition-manager");
        props.put("client.id", "partition-manager");
        props.put("allow.auto.create.topics", false);
        List<PartitionInfo> partitions;
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props)) {
            partitions = consumer.partitionsFor(topicName);
        }
        if (partitions.isEmpty()){
            log.error("Topic: '{}' doesn't exists. Can't read partitions from it.", topicName);
            throw new TopicNotFoundException("Topic: '" + topicName + "' doesn't exists. Can't get partitions from it.");
        }
        ArrayList<Integer> partitionList = new ArrayList<>();

        for (PartitionInfo partition : partitions) {
            partitionList.add(partition.partition());
        }

        Collections.sort(partitionList);
        return partitionList;
    }
}
