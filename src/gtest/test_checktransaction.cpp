#include <gtest/gtest.h>

#include "main.h"
#include "primitives/transaction.h"
#include "consensus/validation.h"

class MockCValidationState : public CValidationState {
    MOCK_METHOD5(DoS, bool(int, bool, unsigned char, std::string, bool corruptionIn=false));
    MOCK_METHOD3(Invalid, bool(bool, unsigned char, std::string));
    MOCK_METHOD1(Error, bool(std::string));
};


using ::testing::Return;


TEST(CheckTransaction, reject_empty_vin_and_empty_vpour) {
    CTransaction tx; /* vin and vpour are empty. */
    MockCValidationState state;

    ON_CALL(state, DoS())
        .WillByDefault(Return(false));

    EXPECT_CALL(state, DoS(10, false, REJECT_INVALID, "bad-txns-vin-empty"))
        .Times(1);

    bool validtxn = CheckTransaction(tx, state);

    ASSERT_FALSE(validtxn);
}


TEST(checktransaction_tests, check_vpub_not_both_nonzero) {
    CMutableTransaction tx;
    tx.nVersion = 2;

    {
        // Ensure that values within the pour are well-formed.
        CMutableTransaction newTx(tx);
        CValidationState state;
        state.SetPerformPourVerification(false); // don't verify the snark

        newTx.vpour.push_back(CPourTx());

        CPourTx *pourtx = &newTx.vpour[0];
        pourtx->vpub_old = 1;
        pourtx->vpub_new = 1;

        EXPECT_FALSE(CheckTransaction(newTx, state));
        EXPECT_EQ(state.GetRejectReason(), "bad-txns-vpubs-both-nonzero");
    }
}
