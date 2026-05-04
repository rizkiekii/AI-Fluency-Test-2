package io.mekari.assessment.refundbackendjava.repository;

import io.mekari.assessment.refundbackendjava.domain.model.Purchase;
import java.util.List;
import java.util.Optional;

public interface PurchaseRepository {
    Optional<Purchase> findById(String purchaseId);

    List<Purchase> listAll();
}
