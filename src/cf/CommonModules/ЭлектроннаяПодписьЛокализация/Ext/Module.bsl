﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// При создании на сервере.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	// Локализация
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "ОбщаяФорма.ДобавлениеЭлектроннойПодписиИзФайла" Тогда
		Форма.Элементы.ПодписиМашиночитаемаяДоверенность.Видимость = Истина;
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "ОбщаяФорма.СохранениеВместеСЭлектроннойПодписью" Тогда
		Форма.Элементы.ТаблицаПодписейМашиночитаемаяДоверенность.Видимость = Истина;
		Возврат;
	КонецЕсли;
		
	// Конец Локализация
	
КонецПроцедуры


Процедура ПриЗагрузкеМашиночитаемыхДоверенностей(Форма) Экспорт
	
	// Локализация
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;
	
	Подписи = Форма.Подписи;
	Доверенности = Форма.Доверенности;
	
	МодульМашиночитаемыеДоверенностиСлужебный = ОбщегоНазначения.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебный");

	Для Каждого Подпись Из Подписи Цикл
		
		Если ТипЗнч(Подпись.МашиночитаемаяДоверенность) = Тип("Строка") И ЗначениеЗаполнено(
			Подпись.МашиночитаемаяДоверенность) Тогда
			
			Найдено = Доверенности.НайтиСтроки(Новый Структура("НомерДоверенности", Подпись.НомерДоверенности));
			
			ФайлыДоверенности = ПолучитьИзВременногоХранилища(Найдено[0].ФайлыДоверенности);
			Результат = МодульМашиночитаемыеДоверенностиСлужебный.ЗагрузитьДоверенностиВИнформационнуюБазу(
				ФайлыДоверенности);
			
			МашиночитаемаяДоверенность = Результат.Доверенности[0];
			
			СвойстваПодписи = ПолучитьИзВременногоХранилища(Подпись.АдресСвойствПодписи);
			СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиСлужебный.НовыйРезультатПроверкиПодписиПоМЧД(
				МашиночитаемаяДоверенность);
			ПоместитьВоВременноеХранилище(СвойстваПодписи, Подпись.АдресСвойствПодписи);
			
			Подпись.МашиночитаемаяДоверенность = МашиночитаемаяДоверенность;
			Найдено = Подписи.НайтиСтроки(Новый Структура("НомерДоверенности", Подпись.НомерДоверенности));
			Для Каждого Строка Из Найдено Цикл
				Строка.МашиночитаемаяДоверенность = МашиночитаемаяДоверенность;
				СвойстваПодписи = ПолучитьИзВременногоХранилища(Строка.АдресСвойствПодписи);
				СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиСлужебный.НовыйРезультатПроверкиПодписиПоМЧД(
					МашиночитаемаяДоверенность);
				ПоместитьВоВременноеХранилище(СвойстваПодписи, Строка.АдресСвойствПодписи);
				
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриЗаполненииМашиночитаемыхДоверенностей(Форма, ПодписанныйОбъект = Неопределено) Экспорт
	
	// Локализация
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;
	
	Подписи = Форма.Подписи;
	Доверенности = Форма.Доверенности;
	
	МодульМашиночитаемыеДоверенностиФНС = ОбщегоНазначения.ОбщийМодуль("МашиночитаемыеДоверенностиФНС");
	МодульМашиночитаемыеДоверенностиФНССлужебный = ОбщегоНазначения.ОбщийМодуль("МашиночитаемыеДоверенностиФНССлужебный");
	
	Для Каждого ТекущаяСтрока Из Подписи Цикл
		ТекущаяСтрока.МашиночитаемаяДоверенность = Неопределено;
		
		СвойстваПодписи = ПолучитьИзВременногоХранилища(ТекущаяСтрока.АдресСвойствПодписи);
		Сертификат = СвойстваПодписи.Сертификат;
		
		ОтборПоСертификату = МодульМашиночитаемыеДоверенностиФНС.ОтборДляДоверенностейПоСертификату(Сертификат, "Представитель");
		ПоляОтбора = Новый Массив;
		Для Каждого Элемент Из ОтборПоСертификату Цикл
			Если Элемент.Ключ = "ПредставительИНН" Или Элемент.Ключ = "ПредставительИННФЛ" Тогда
				Если Не ЗначениеЗаполнено(ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
					Для Каждого Доверенность Из Доверенности Цикл
						Если СтрНайти(Доверенность.ПоляОтбора, Элемент.Значение) Тогда
							ТекущаяСтрока.МашиночитаемаяДоверенность = Доверенность.МашиночитаемаяДоверенность;
							ТекущаяСтрока.НомерДоверенности = Доверенность.НомерДоверенности;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				ПоляОтбора.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
		ТекущаяСтрока.ПоляОтбора = СтрСоединить(ПоляОтбора, ";");
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
			Результат = МодульМашиночитаемыеДоверенностиФНС.ДоверенностиСОтбором(
				ОтборПоСертификату, "МашиночитаемаяДоверенность", СвойстваПодписи.ДатаПодписи);
			Если Результат.Количество() > 0 Тогда

				Для Каждого Доверенность Из Результат Цикл
					Найдено =  Доверенности.НайтиСтроки(Новый Структура("МашиночитаемаяДоверенность",
						Доверенность.МашиночитаемаяДоверенность));
					Если Найдено.Количество() > 0 Тогда
						ТекущаяСтрока.МашиночитаемаяДоверенность = Найдено[0].МашиночитаемаяДоверенность;
						Прервать;
					КонецЕсли;
				КонецЦикла;

				Если Не ЗначениеЗаполнено(ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
					ТекущаяСтрока.МашиночитаемаяДоверенность = Результат[0].МашиночитаемаяДоверенность;
				КонецЕсли;

			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
			Если ПодписанныйОбъект = Неопределено Тогда
				СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиФНССлужебный.НовыйРезультатПроверкиПодписиПоМЧД(
					ТекущаяСтрока.МашиночитаемаяДоверенность);
			ИначеЕсли МодульМашиночитаемыеДоверенностиФНССлужебный.ЭтоМашиночитаемаяДоверенность(
				ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
				СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиПодписиПоМЧД(
					ТекущаяСтрока.МашиночитаемаяДоверенность, ПодписанныйОбъект, СвойстваПодписи.Сертификат,
					СвойстваПодписи.ДатаПодписи);
			Иначе
				СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = Неопределено;	
			КонецЕсли;
		Иначе
			СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = Неопределено;
		КонецЕсли;
		
		ПоместитьВоВременноеХранилище(СвойстваПодписи, ТекущаяСтрока.АдресСвойствПодписи);
		
	КонецЦикла;
	
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриЗаполненииМашиночитаемойДоверенностиВСтроке(Форма, ИдентификаторСтроки, ПодписанныйОбъект) Экспорт

	// Локализация
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;
	
	Подписи = Форма.Подписи;
	МодульМашиночитаемыеДоверенностиФНССлужебный = ОбщегоНазначения.ОбщийМодуль("МашиночитаемыеДоверенностиФНССлужебный");
	ТекущаяСтрока = Подписи.НайтиПоИдентификатору(ИдентификаторСтроки);
	СвойстваПодписи = ПолучитьИзВременногоХранилища(ТекущаяСтрока.АдресСвойствПодписи);
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
		Если ПодписанныйОбъект = Неопределено Тогда
			СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиФНССлужебный.НовыйРезультатПроверкиПодписиПоМЧД(
					ТекущаяСтрока.МашиночитаемаяДоверенность);
		ИначеЕсли МодульМашиночитаемыеДоверенностиФНССлужебный.ЭтоМашиночитаемаяДоверенность(
			ТекущаяСтрока.МашиночитаемаяДоверенность) Тогда
			СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиПодписиПоМЧД(
					ТекущаяСтрока.МашиночитаемаяДоверенность, ПодписанныйОбъект, СвойстваПодписи.Сертификат,
				СвойстваПодписи.ДатаПодписи);
		Иначе
			СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = Неопределено;
		КонецЕсли;
	Иначе
		СвойстваПодписи.РезультатПроверкиПодписиПоМЧД = Неопределено;
	КонецЕсли;
	ПоместитьВоВременноеХранилище(СвойстваПодписи, ТекущаяСтрока.АдресСвойствПодписи);
	
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриДобавленииСтрокНаСервере(Форма, ПомещенныеФайлы, ДругиеФайлы, ОшибкиПриЗагрузкеДоверенностей, УникальныйИдентификатор) Экспорт
	
	// Локализация

	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;

	Доверенности = Форма.Доверенности;

	МодульМашиночитаемыеДоверенностиСлужебный = ОбщегоНазначения.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебный");

	СвойстваДоверенностей = МодульМашиночитаемыеДоверенностиСлужебный.СвойстваДоверенностейИзФайлов(
				ПомещенныеФайлы, УникальныйИдентификатор);
	Для Каждого СвойстваДоверенности Из СвойстваДоверенностей.Доверенности Цикл

		НоваяСтрока = Доверенности.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваДоверенности);

	КонецЦикла;

	ОшибкиПриЗагрузкеДоверенностей = СтрСоединить(СвойстваДоверенностей.ТекстыОшибок, Символы.ПС);
	ДругиеФайлы = СвойстваДоверенностей.ДругиеФайлы;
	
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриПроверкеПодписейПоМЧД(Подписи, ПодписанныйОбъект, РезультатыПроверок) Экспорт

	// Локализация
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		Возврат;
	КонецЕсли;

	РезультатыПроверок = Новый Массив;
	МодульМашиночитаемыеДоверенностиФНССлужебный = ОбщегоНазначения.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебный");
	Для Каждого Подпись Из Подписи Цикл

		РезультатПроверкиДоверенностей = ПолучитьИзВременногоХранилища(Подпись.РезультатПроверкиПодписиПоМЧД);
		НовыйРезультатПроверкиДоверенностей = Новый Массив;
		Для Каждого Результат Из РезультатПроверкиДоверенностей Цикл
			Если Не ЗначениеЗаполнено(Подпись.Сертификат) Тогда
				НовыйРезультатПроверкиДоверенностей.Добавить(
					МодульМашиночитаемыеДоверенностиФНССлужебный.НовыйРезультатПроверкиПодписиПоМЧД(Результат.МашиночитаемаяДоверенность));
			Иначе
				РезультатПроверкиПодписиПоМЧД = МодульМашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиПодписиПоМЧД(
						Результат.МашиночитаемаяДоверенность, ПодписанныйОбъект, Подпись.Сертификат, Подпись.ДатаПодписи);
				НовыйРезультатПроверкиДоверенностей.Добавить(РезультатПроверкиПодписиПоМЧД);
			КонецЕсли;
		КонецЦикла;

		РезультатПроверки = Новый Структура("Индекс, РезультатПроверкиПодписиПоМЧД", Подпись.Индекс,
			НовыйРезультатПроверкиДоверенностей);
		МодульМашиночитаемыеДоверенностиФНССлужебный.ДобавитьИнформациюМЧД(РезультатПроверки,
			Подпись.РезультатПроверкиПодписиПоМЧД);
		РезультатыПроверок.Добавить(РезультатПроверки);

	КонецЦикла;
	
	// Конец Локализация

КонецПроцедуры

#КонецОбласти
