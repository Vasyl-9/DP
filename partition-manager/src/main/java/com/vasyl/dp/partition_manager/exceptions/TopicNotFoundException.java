package com.vasyl.dp.partition_manager.exceptions;

public class TopicNotFoundException extends RuntimeException {
    public TopicNotFoundException(String errorMessage) {
        super(errorMessage, null);
    }
}
