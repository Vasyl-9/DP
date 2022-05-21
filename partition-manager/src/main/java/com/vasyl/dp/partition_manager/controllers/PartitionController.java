package com.vasyl.dp.partition_manager.controllers;

import static java.util.Objects.isNull;
import com.vasyl.dp.partition_manager.model.Partition;
import com.vasyl.dp.partition_manager.model.User;
import com.vasyl.dp.partition_manager.service.PartitionService;
import com.vasyl.dp.partition_manager.service.UserService;
import javax.xml.bind.ValidationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/partition")
public class PartitionController {

    Logger log = LoggerFactory.getLogger(PartitionController.class);

    private final UserService userService;
    private final PartitionService partitionService;

    @Autowired
    public PartitionController(UserService userService, PartitionService partitionService) {
        this.userService = userService;
        this.partitionService = partitionService;
    }

    @PostMapping("/set/{username}")
    public ResponseEntity<Integer> setPartitionForUser(@PathVariable String username) throws ValidationException {
        log.info("Handling partition for user: {}", username);
        User user = userService.findByName(username);
        Partition partition;
        if (isNull(user)) {
            log.info("Saving new user: {}", username);
            partitionService.actualizingExistingPartitions();
            partition = partitionService.getPartitionByNextInLineToUse();
            partitionService.moveOnToNextPartition();
            user = userService.saveUser(new User(username, partition));
        } else {
            partition = user.getPartition();
        }
        log.info("User: {} get partition number: {}", user.getName(), partition.getNumber());
        return new ResponseEntity<>(partition.getNumber(), HttpStatus.OK);
    }
}
