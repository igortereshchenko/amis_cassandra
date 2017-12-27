app.controller('wishlist',
    ['$scope', '$location', '$cookies', 'BankOperation','Bank', 'Credit', "$window",
    ($scope, $location, $cookies, BankOperation, Bank, Credit, $window) => {

        $scope.selectedWishListItem;
        $scope.findAll = () => {
            BankOperation.findWishLists({})
                .$promise.then((banks) => {
                    $scope.bankWishedListed = banks;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.findAllBanks = () => {
            Bank.findAll({})
                .$promise.then((banks) => {
                    $scope.banks = banks;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.findAllCredits = () => {
            Credit.findAll({})
                .$promise.then((credits) => {
                    $scope.credits = credits;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.createWishList = (bank, credit, user) => {
            if (bank, credit, user) {
                BankOperation.create({
                        bankId: bank.bank_id,
                        creditId: credit.credit_id,
                        userId: user
                    })
                    .$promise.then((wishItem) => {
                        $scope.bankWishedListed.push(wishItem);
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert('Select bank, credit and user');
            }
        }

        $scope.select = (bank, $event) => {
            $scope.selectedWishListItem = bank.bank_operation_id;
        }

        $scope.selectedBank = (bank) => {
            $scope.users = bank.users;
        }

        $scope.delete = (bankOp, $event) => {
            $event.stopPropagation();
            BankOperation.deleteById({bankOpId:bankOp.bank_operation_id})
                .$promise.then((bankOps) => {
                    $scope.bankWishedListed = _.filter($scope.bankWishedListed,
                        (el) => el.bank_operation_id !== bankOp.bank_operation_id);
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.findAll();
        $scope.findAllBanks();
        $scope.findAllCredits();

    }]
);
