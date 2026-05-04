package io.mekari.assessment.refundbackendjava.repository;

import io.mekari.assessment.refundbackendjava.domain.model.Refund;
import java.util.List;
import java.util.Optional;

public interface RefundRepository {
    void create(Refund refund);

    Optional<Refund> findById(String refundId);

    List<Refund> listAll();
}
