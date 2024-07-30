﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.МножественныйВыбор = Не ЗначениеЗаполнено(Параметры.Отбор);
	
	Если ЗначениеЗаполнено(Параметры.Отбор) Тогда
		Отбор = СтрРазделить(Параметры.Отбор, "_", Истина)[0];
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Выбор региональных настроек для языка %1'"),
			МультиязычностьСервер.ПредставлениеЯзыка(Отбор));
	КонецЕсли;
	
	ЗаполнитьСписокДоступныхЯзыков(Сворачивать);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(ВыбранныеЯзыки());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ВыбранныеЯзыки());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокДоступныхЯзыков(Свернуть = Истина)
	
	Список.Очистить();
	
	Отбор = СтрРазделить(Параметры.Отбор, "_", Истина)[0];
	
	Для Каждого Язык Из ПолучитьДопустимыеКодыЛокализации() Цикл
		Если ЗначениеЗаполнено(Отбор) И Не СтрНачинаетсяС(Язык, Отбор) Тогда
			Продолжить;
		КонецЕсли;
		
		Представление = ПредставлениеКодаЛокализации(Язык);
		ЧастиСтроки = СтрРазделить(Представление, " ", Истина);
		ЧастиСтроки[0] = ТРег(ЧастиСтроки[0]);
		Представление = СтрСоединить(ЧастиСтроки, " ");
		
		Если СтрНайти(Язык, "_") И Свернуть Тогда
			ОписаниеЯзыка = Список.НайтиСтроки(Новый Структура("Код", СтрРазделить(Язык, "_", Истина)[0]))[0];
			Представление = Сред(Представление, СтрДлина(ОписаниеЯзыка.Наименование) + 1);
			
			Страны = СтрРазделить(ОписаниеЯзыка.Страны, ",", Ложь);
			
			ПозицияНачала = СтрНайти(Представление, "(");
			Если ПозицияНачала > 0 Тогда
				ПозицияКонца = СтрНайти(Представление, ")", НаправлениеПоиска.СКонца);
				Если ПозицияКонца > 0 Тогда
					СписокСтранСтрокой = Сред(Представление, ПозицияНачала + 1, ПозицияКонца - ПозицияНачала - 1);
					СтраныЯзыка = СтрРазделить(СписокСтранСтрокой, ",", Ложь);
					Для Каждого Страна Из СтраныЯзыка Цикл
						Страна = СокрЛП(Страна);
						Если Страны.Найти(Страна) = Неопределено Тогда
							Страны.Добавить(Страна);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
			ОписаниеЯзыка.Страны = СтрСоединить(Страны, ",");
			ОписаниеЯзыка.СтрокаПоиска = СтрокаПоиска(ОписаниеЯзыка.Наименование) + " " + ОписаниеЯзыка.Код + " " + СтрокаПоиска(ОписаниеЯзыка.Страны);
		Иначе
			ОписаниеЯзыка = Список.Добавить();
			ОписаниеЯзыка.Код = Язык;
			ОписаниеЯзыка.Наименование = Представление;
			ОписаниеЯзыка.СтрокаПоиска = СтрокаПоиска(ОписаниеЯзыка.Наименование) + " " + ОписаниеЯзыка.Код;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ОписаниеЯзыка Из Список Цикл
		ОписаниеЯзыка.Страны = СтрЗаменить(ОписаниеЯзыка.Страны, ",", ", ");
	КонецЦикла;
	
	Список.Сортировать("СтрокаПоиска");
	
КонецПроцедуры

&НаСервере
Функция СтрокаПоиска(Строка)
	Возврат СтрСоединить(СтрРазделить(Строка, "(), ", Ложь), " ");
КонецФункции

&НаКлиенте
Функция ВыбранныеЯзыки()
	
	Результат = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыбранныйЯзык = Список.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Результат.Добавить(Новый Структура("Код,Наименование", ВыбранныйЯзык.Код, ВыбранныйЯзык.Наименование));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
