package com.vasyl.dp.partition_manager.service;

import static java.util.Objects.isNull;
import com.vasyl.dp.partition_manager.model.User;
import com.vasyl.dp.partition_manager.repository.UserRepository;
import javax.xml.bind.ValidationException;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User findByName(String username){
        User user = userRepository.findByName(username);
        if (isNull(user)){
            return null;
        }
        return user;
    }

    public User saveUser(User user) throws ValidationException {
        if (isNull(user)){
            throw new ValidationException("Object user is null");
        }
        if (isNull(user.getName())){
            throw new ValidationException("User name is null");
        }
        if (isNull(user.getPartition())){
            throw new ValidationException("User partition field is null");
        }
        User oldUser = userRepository.findByName(user.getName());
        if (isNull(oldUser)) {
            return userRepository.save(user);
        } else {
            return oldUser;
        }
    }

}
