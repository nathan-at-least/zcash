#include "main.h"
#include "primitives/transaction.h"
#include "consensus/validation.h"

#include <gtest/gtest.h>


TEST(CheckTransaction, reject_empty_vin_and_empty_vpour) {
    CTransaction tx; /* vin and vpour are empty. */
    CValidationState state;

    bool validtxn = CheckTransaction(tx, state);

    ASSERT_FALSE(validtxn);
}
