@chcp 65001

@rem установим вспомогательные приложения
call opm install vanessa-runner
call opm install vanessa-automation

@rem скачиваем фреймворк allure, для тестирования
call wget https://github.com/allure-framework/allure2/releases/download/2.30.0/allure-2.30.0.zip -O ./tools/allure-2.30.0.zip
call 7z x ./tools/allure-2.30.0.zip -o"./tools/"
