@chcp 65001

call allure generate out/syntax-check/allure out/smoke/allure out/bdd/allure -c -o build/allure-report 
allure open build/allure-report
