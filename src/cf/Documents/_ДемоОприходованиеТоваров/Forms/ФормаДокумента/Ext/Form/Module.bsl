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
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ЭтоТовары = Не ОбщегоНазначения.ПустойБуферОбмена("Товары");
	Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
	Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Дата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.Номер.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ТоварыНомерСтроки.Видимость = Ложь;
		Элементы.Комментарий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		ОбработатьОповещениеСкопироватьВБуферОбмена(Параметр);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Параметр - Структура:
//   * Источник - Строка
//
&НаКлиенте
Процедура ОбработатьОповещениеСкопироватьВБуферОбмена(Параметр)
	ЭтоТовары = (Параметр.Источник = "Товары");
	Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
	Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	Оповестить("Запись__ДемоОприходованиеТоваров", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если Элементы.Товары.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	СкопироватьСтрокиНаСервере();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Копирование в буфер обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Скопировано товаров: %1'"), Элементы.Товары.ВыделенныеСтроки.Количество()));
	Оповестить("ДанныеСкопированыВБуферОбмена", Новый Структура("Источник", "Товары"), Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	Количество = ВставитьСтрокиНаСервере();
	Если Количество > 0 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вставка из буфера обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вставлено товаров: %1'"), Количество));
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Объект.Товары, Элементы.Товары.ВыделенныеСтроки, "Товары");
	
КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере()
	
	ДанныеИзБуфераОбмена = ОбщегоНазначения.СтрокиИзБуфераОбмена();
	Если ДанныеИзБуфераОбмена.Источник <> "Товары" Тогда
		Возврат 0;
	КонецЕсли;
		
	Таблица = ДанныеИзБуфераОбмена.Данные;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	Возврат Таблица.Количество();
	
КонецФункции

#КонецОбласти