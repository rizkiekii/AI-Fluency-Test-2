package io.mekari.assessment.refundbackendjava.repository.memory;

import io.mekari.assessment.refundbackendjava.domain.model.Purchase;
import io.mekari.assessment.refundbackendjava.repository.PurchaseRepository;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Repository;

@Repository
public class InMemoryPurchaseRepository implements PurchaseRepository {
    private final Store store;

    public InMemoryPurchaseRepository(Store store) {
        this.store = store;
    }

    @Override
    public Optional<Purchase> findById(String purchaseId) {
        return Optional.ofNullable(store.getPurchases().get(purchaseId));
    }

    @Override
    public List<Purchase> listAll() {
        return store.getPurchases().values().stream()
            .sorted(Comparator.comparing(Purchase::getPurchaseId))
            .collect(Collectors.toList());
    }
}
