package io.mekari.assessment.refundbackendjava.repository.memory;

import io.mekari.assessment.refundbackendjava.domain.model.Refund;
import io.mekari.assessment.refundbackendjava.repository.RefundRepository;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Repository;

@Repository
public class InMemoryRefundRepository implements RefundRepository {
    private final Store store;

    public InMemoryRefundRepository(Store store) {
        this.store = store;
    }

    @Override
    public void create(Refund refund) {
        Refund existing = store.getRefunds().putIfAbsent(refund.getRefundId(), refund);
        if (existing != null) {
            throw new IllegalArgumentException(String.format("refund with id %s already exists", refund.getRefundId()));
        }
    }

    @Override
    public Optional<Refund> findById(String refundId) {
        return Optional.ofNullable(store.getRefunds().get(refundId));
    }

    @Override
    public List<Refund> listAll() {
        return store.getRefunds().values().stream()
            .sorted(Comparator.comparing(Refund::getRefundId))
            .collect(Collectors.toList());
    }
}
