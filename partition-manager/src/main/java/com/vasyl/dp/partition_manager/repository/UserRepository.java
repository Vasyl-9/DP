package com.vasyl.dp.partition_manager.repository;

import com.vasyl.dp.partition_manager.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    User findByName(String username);
}
