app.controller('loan',
    ['$scope', '$location', 'Credit', '$cookies',
    ($scope, $location, Credit, $cookies) => {
        $scope.selectedId = null;
        $scope.update = {};

        $scope.findAll = () => {
            Credit.findAll({})
                .$promise.then((credits) => {
                    $scope.credits = credits;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.create = (percent, term, debt) => {
            if (term && percent && debt){
                Credit.create({
                        percent: parseFloat(percent),
                        term: parseInt(term),
                        debt: parseFloat(debt)
                    })
                    .$promise.then((credits) => {
                        console.log(credits)
                        $scope.credits.push(credits);
                        $scope.percent = '';
                        $scope.term = '';
                        $scope.debt = '';
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert('Term, percent and debt are required');
            }

        }

        $scope.delete = (credit, $event) => {
            $scope.update = {};
            $event.stopPropagation()
            Credit.deleteById({creditId:credit.credit_id})
                .$promise.then((credits) => {
                    $scope.credits = _.filter($scope.credits, (el) => el.credit_id !== credit.credit_id);
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.updateCredit = (credit) => {
            if (!credit.id) {
                alert('Select credit from table');
                return;
            }

            Credit.updateById({
                    creditId:credit.id,
                    percent: parseFloat(credit.percent),
                    term: parseInt(credit.term),
                    debt: parseFloat(credit.debt),
                })
                .$promise.then((credits) => {
                    _.map($scope.credits, (el) => {
                        if (el.credit_id === credit.id){
                            el.percent = credit.percent;
                            el.term = credit.term;
                            el.debt = credit.debt;
                        }
                        return el;
                    });
                    $scope.update = {};
                    $scope.selectedId = null;
                })
                .catch((err) => {
                    alert('Please Enter Number');
                });

        }

        $scope.select = (credit, $event) => {
            $scope.update.id = credit.credit_id
            $scope.update.percent = credit.percent;
            $scope.update.term = credit.term;
            $scope.update.debt= credit.debt;
            $scope.selectedId = credit.credit_id;
        }

        $scope.findAll();
    }]
);
