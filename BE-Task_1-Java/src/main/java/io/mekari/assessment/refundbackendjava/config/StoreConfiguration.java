package io.mekari.assessment.refundbackendjava.config;

import io.mekari.assessment.refundbackendjava.repository.memory.Seed;
import io.mekari.assessment.refundbackendjava.repository.memory.Store;
import java.time.Instant;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class StoreConfiguration {
    @Bean
    Store store() {
        Store store = new Store();
        Seed.apply(store, Instant.now());
        return store;
    }
}