﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запрашивает файл с данными классификатора календарей. 
// Преобразует полученный файл в структуру с таблицами календарей и их данных.
// Если не удалось получить файл классификатора, вызывается исключение.
//
// Параметры:
//  ДанныеКлассификатора - Структура:
//   * ПроизводственныеКалендари - Структура:
//     * ИмяТаблицы - Строка          - имя таблицы.
//     * Данные     - ТаблицаЗначений - преобразованная из XML таблица календарей.
//   * ДанныеПроизводственныхКалендарей - Структура:
//     * ИмяТаблицы - Строка          - имя таблицы.
//     * Данные     - ТаблицаЗначений - преобразованная из XML таблица данных календарей.
//
Процедура ПриПолученииДанныхКлассификатора(ДанныеКлассификатора) Экспорт
	
	// Локализация
	ДанныеФайлов = Неопределено;
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КалендарныеГрафики.ИдентификаторКлассификатора());
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		ДанныеФайлов = МодульРаботаСКлассификаторами.ПолучитьФайлыКлассификаторов(Идентификаторы);
	КонецЕсли;
	
	Если ДанныеФайлов = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось получить данные календаря.
                               |Классификаторы не поддерживаются или подсистема ""Работа с классификаторами"" отсутствует.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ДанныеФайлов.КодОшибки) Тогда
		ИмяСобытия = НСтр("ru = 'Календарные графики.Получение файла классификатора'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(
			ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,,, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить данные календаря. 
                      |%1'"), 
				ДанныеФайлов.ИнформацияОбОшибке));
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить данные календаря.
                               |%1.'"), 
			ДанныеФайлов.СообщениеОбОшибке);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ОтборСтрок = Новый Структура("Идентификатор");
	ОтборСтрок.Идентификатор = КалендарныеГрафики.ИдентификаторКлассификатора();
	НайденныеСтроки = ДанныеФайлов.ДанныеКлассификаторов.НайтиСтроки(ОтборСтрок);
	Если НайденныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось получить данные календаря.
                               |Полученные классификаторы не содержат календарей.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	СведенияФайла = НайденныеСтроки[0];
	
	Если СведенияФайла.Версия < КалендарныеГрафики.ВерсияКалендарей() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать полученные данные календаря из-за конфликта версий.
                  |Версия календарей
                  |- полученного классификатора %1, 
                  |- встроенных в конфигурацию %2, 
                  |- загруженного ранее классификатора %3.
                  |Рекомендуется выполнить обновление классификаторов.'"),
			СведенияФайла.Версия,
			КалендарныеГрафики.ВерсияКалендарей(),
			КалендарныеГрафики.ВерсияЗагруженныхКалендарей());
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Попытка
		ДанныеКлассификатора = КалендарныеГрафики.ДанныеФайлаКлассификатора(СведенияФайла.АдресФайла);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать полученные данные календаря.
					   |%1.'"),
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	// Конец Локализация
	
КонецПроцедуры

#КонецОбласти