﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет SMS через настроенного поставщика услуги, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей  - Массив из Строка - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//  ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей;
//  ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//
// Возвращаемое значение:
//  Структура:
//    * ОтправленныеСообщения - Массив из Структура:
//      ** НомерПолучателя - Строка - номер получателя SMS.
//      ** ИдентификаторСообщения - Строка - идентификатор SMS, присвоенный провайдером для отслеживания доставки.
//    * ОписаниеОшибки - Строка - пользовательское представление ошибки, если пустая строка, то ошибки нет.
//
Функция ОтправитьSMS(НомераПолучателей, Знач Текст, ИмяОтправителя = Неопределено, ПеревестиВТранслит = Ложь) Экспорт
	
	ПроверитьПрава();
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	Если Не ЗначениеЗаполнено(СтрСоединить(НомераПолучателей, "")) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Не указан номер получателя SMS.'");
		Возврат Результат;
	КонецЕсли;
	
	Если ПеревестиВТранслит Тогда
		Текст = СтроковыеФункции.СтрокаЛатиницей(Текст);
	КонецЕсли;
	
	Если Не НастройкаОтправкиSMSВыполнена() Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверно заданы настройки провайдера для отправки SMS.'");
		Возврат Результат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИмяОтправителя = Неопределено Тогда
		ИмяОтправителя = НастройкиОтправкиSMS.ИмяОтправителя;
	КонецЕсли;
	
	МодульОтправкаSMSЧерезПровайдера = МодульОтправкаSMSЧерезПровайдера(НастройкиОтправкиSMS.Провайдер);
	Если МодульОтправкаSMSЧерезПровайдера <> Неопределено Тогда
		Логин = "";
		Пароль = "";
		Если НастройкиОтправкиSMS.СпособАвторизации <> "ПоКлючу" Тогда
			Логин = НастройкиОтправкиSMS.Логин;
			Пароль = НастройкиОтправкиSMS.Пароль;
		КонецЕсли;
		Результат = МодульОтправкаSMSЧерезПровайдера.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль);
	Иначе
		ПараметрыОтправки = Новый Структура;
		ПараметрыОтправки.Вставить("НомераПолучателей", НомераПолучателей);
		ПараметрыОтправки.Вставить("Текст", Текст);
		ПараметрыОтправки.Вставить("ИмяОтправителя", ИмяОтправителя);
		ПараметрыОтправки.Вставить("Логин", НастройкиОтправкиSMS.Логин);
		ПараметрыОтправки.Вставить("Пароль", НастройкиОтправкиSMS.Пароль);
		ПараметрыОтправки.Вставить("Провайдер", НастройкиОтправкиSMS.Провайдер);
		
		ОтправкаSMSПереопределяемый.ОтправитьSMS(ПараметрыОтправки, Результат);
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ОтправкаSMSПереопределяемый.ОтправитьSMS", "Результат", Результат,
			Тип("Структура"), Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Тип("Массив"), Тип("Строка")));
			
		Если Не ЗначениеЗаполнено(Результат.ОписаниеОшибки) И Не ЗначениеЗаполнено(Результат.ОтправленныеСообщения) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'Ошибка при выходе из процедуры %1:
				|Не заполнены выходные параметры %2 и %3 (провайдер: %4).
				|Ожидается заполнение по меньшей мере одного из этих параметров.'", ОбщегоНазначения.КодОсновногоЯзыка()),
				"ОтправкаSMSПереопределяемый.ОтправитьSMS",
				"ОписаниеОшибки",
				"ОтправленныеСообщения",
				НастройкиОтправкиSMS.Провайдер);
		КонецЕсли;
		
		Если Результат.ОтправленныеСообщения.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.Проверить(
				ТипЗнч(Результат.ОтправленныеСообщения[0]) = Тип("Структура"),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неверный тип значения в коллекции %1:
						|ожидается тип ""Структура"", передан тип ""%2""'"),
						"Результат.ОтправленныеСообщения",
						ТипЗнч(Результат.ОтправленныеСообщения[0])),
				"ОтправкаSMSПереопределяемый.ОтправитьSMS");
			Для Индекс = 0 По Результат.ОтправленныеСообщения.Количество() - 1 Цикл
				ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
					"ОтправкаSMSПереопределяемый.ОтправитьSMS",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Результат.ОтправленныеСообщения[%1]", Формат(Индекс, "ЧН=; ЧГ=0")),
					Результат.ОтправленныеСообщения[Индекс],
					Тип("Структура"),
					Новый Структура("НомерПолучателя,ИдентификаторСообщения", Тип("Строка"), Тип("Строка")));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Запрашивает статус доставки сообщения у поставщика услуг.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный SMS при отправке;
//
// Возвращаемое значение:
//  Строка - статус доставки сообщения, который вернул поставщик услуг:
//           "НеОтправлялось" - сообщение еще не было обработано поставщиком услуг (в очереди);
//           "Отправляется"   - сообщение стоит в очереди на отправку у провайдера;
//           "Отправлено"     - сообщение отправлено, ожидается подтверждение о доставке;
//           "НеОтправлено"   - сообщение не отправлено (недостаточно средств на счете, перегружена сеть оператора);
//           "Доставлено"     - сообщение доставлено адресату;
//           "НеДоставлено"   - сообщение не удалось доставить (абонент недоступен, время ожидания подтверждения
//                              доставки от абонента истекло);
//           "Ошибка"         - не удалось получить статус у поставщика услуг (статус неизвестен).
//
Функция СтатусДоставки(Знач ИдентификаторСообщения) Экспорт
	
	ПроверитьПрава();
	
	Если ПустаяСтрока(ИдентификаторСообщения) Тогда
		Возврат "НеОтправлялось";
	КонецЕсли;
	
	Результат = ОтправкаSMSПовтИсп.СтатусДоставки(ИдентификаторСообщения);
	
	Возврат Результат;
	
КонецФункции

// Проверяет правильность сохраненных настроек отправки SMS.
//
// Возвращаемое значение:
//  Булево - Истина, если отправка SMS уже настроена.
//
Функция НастройкаОтправкиSMSВыполнена() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		НастройкиПровайдера = НастройкиПровайдера(НастройкиОтправкиSMS.Провайдер);
		
		ПоляАвторизации = ПоляАвторизацииПровайдераПоУмолчанию().ПоЛогинуИПаролю;
		Если НастройкиОтправкиSMS.Свойство("СпособАвторизации") И ЗначениеЗаполнено(НастройкиОтправкиSMS.СпособАвторизации)
			И НастройкиПровайдера.ПоляАвторизации.Свойство(НастройкиОтправкиSMS.СпособАвторизации) Тогда
			
			ПоляАвторизации = НастройкиПровайдера.ПоляАвторизации[НастройкиОтправкиSMS.СпособАвторизации];
		КонецЕсли;
		
		Отказ = Ложь;
		Для Каждого Поле Из ПоляАвторизации Цикл
			Если Не ЗначениеЗаполнено(НастройкиОтправкиSMS[Поле.Значение]) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ОтправкаSMSПереопределяемый.ПриПроверкеНастроекОтправкиSMS(НастройкиОтправкиSMS, Отказ);
		Возврат Не Отказ;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет возможность отправки SMS для текущего пользователя.
// 
// Возвращаемое значение:
//  Булево - Истина, если отправка SMS настроена и у текущего пользователя достаточно прав для отправки SMS.
//
Функция ДоступнаОтправкаSMS() Экспорт
	
	Возврат ОтправкаSMSПовтИсп.ДоступнаОтправкаSMS();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	Параметры.Вставить("ДоступнаОтправкаSMS", ДоступнаОтправкаSMS());
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Для Каждого МодульПровайдера Из МодулиПровайдеров() Цикл
		МодульОтправкаSMSЧерезПровайдера = МодульПровайдера.Значение;
		ЗапросыРазрешений.Добавить(
			МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(МодульОтправкаSMSЧерезПровайдера.Разрешения()));
	КонецЦикла;
	
	ЗапросыРазрешений.Добавить(
		МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ДополнительныеРазрешения()));
	
КонецПроцедуры

// Параметры:
//   ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		Возврат;
	КонецЕсли;
	
	МодульОтправкаSMSЧерезПровайдера = МодульОтправкаSMSЧерезПровайдера(НастройкиОтправкиSMS.Провайдер);
	
	Если МодульОтправкаSMSЧерезПровайдера <> Неопределено Тогда
		НастройкиПровайдера = НастройкиПровайдераПоУмолчанию();
		МодульОтправкаSMSЧерезПровайдера.ПриОпределенииНастроек(НастройкиПровайдера);
		Если НастройкиПровайдера.ПриЗаполненииСпискаТекущихДел Тогда
			МодульОтправкаSMSЧерезПровайдера.ПриЗаполненииСпискаТекущихДел(ТекущиеДела);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// См. ЦентрМониторингаПереопределяемый.ПриСбореПоказателейСтатистикиКонфигурации.
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПровайдера = Строка(Константы.ПровайдерSMS.Получить());
	
	МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
	МодульЦентрМониторинга.ЗаписатьСтатистикуОбъектаКонфигурации("ОтправкаSMS.ПровайдерSMS." + ИмяПровайдера, 1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДополнительныеРазрешения()
	Разрешения = Новый Массив;
	ОтправкаSMSПереопределяемый.ПриПолученииРазрешений(Разрешения);
	
	Возврат Разрешения;
КонецФункции

Процедура ПроверитьПрава() Экспорт
	ВыполнитьПроверкуПравДоступа("Просмотр", Метаданные.ОбщиеФормы.ОтправкаSMS);
КонецПроцедуры

Функция МодульОтправкаSMSЧерезПровайдера(Провайдер) Экспорт
	Возврат МодулиПровайдеров()[Провайдер];
КонецФункции

Функция МодулиПровайдеров()
	Результат = Новый Соответствие;
	
	Для Каждого ОбъектМетаданных Из Метаданные.Перечисления.ПровайдерыSMS.ЗначенияПеречисления Цикл
		ИмяМодуля = "ОтправкаSMSЧерез" + ОбъектМетаданных.Имя;
		Если Метаданные.ОбщиеМодули.Найти(ИмяМодуля) <> Неопределено Тогда
			Результат.Вставить(Перечисления.ПровайдерыSMS[ОбъектМетаданных.Имя], ОбщегоНазначения.ОбщийМодуль(ИмяМодуля));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПодготовитьHTTPЗапрос(АдресРесурса, ПараметрыЗапроса, ПоместитьПараметрыВТелоЗапроса = Истина) Экспорт
	
	Заголовки = Новый Соответствие;
	
	Если ПоместитьПараметрыВТелоЗапроса Тогда
		Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НастройкиОтправкиSMS.СпособАвторизации = "ПоКлючу" Тогда
		Заголовки.Вставить("Authorization", "Bearer" + " " + НастройкиОтправкиSMS.Пароль);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Строка") Тогда
		СтрокаПараметров = ПараметрыЗапроса;
	Иначе
		СписокПараметров = Новый Массив;
		Для Каждого Параметр Из ПараметрыЗапроса Цикл
			Значения = Параметр.Значение;
			Если ТипЗнч(Параметр.Значение) <> Тип("Массив") Тогда
				Значения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметр.Значение);
			КонецЕсли;
			
			Для Каждого Значение Из Значения Цикл
				СписокПараметров.Добавить(Параметр.Ключ + "=" + КодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL));
			КонецЦикла;
		КонецЦикла;
		СтрокаПараметров = СтрСоединить(СписокПараметров, "&");
	КонецЕсли;
	
	Если Не ПоместитьПараметрыВТелоЗапроса Тогда
		АдресРесурса = АдресРесурса + "?" + СтрокаПараметров;
	КонецЕсли;

	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Если ПоместитьПараметрыВТелоЗапроса Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров);
	КонецЕсли;
	
	Возврат HTTPЗапрос;

КонецФункции

Функция ПоляАвторизацииПровайдераПоУмолчанию()
	
	СпособыАвторизации = Новый Структура;
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Логин", НСтр("ru = 'Логин'"));
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Пароль'"), Истина);
	
	СпособыАвторизации.Вставить("ПоЛогинуИПаролю", ПоляАвторизации);
	
	Возврат СпособыАвторизации;
	
КонецФункции

Функция СпособыАвторизацииПоУмолчанию()
	
	Результат = Новый СписокЗначений;
	Результат.Добавить("ПоЛогинуИПаролю", НСтр("ru = 'По логину и паролю'"));
	
	Возврат Результат;
	
КонецФункции


// Настройки отправки SMS.
// 
// Возвращаемое значение:
//  Структура:
//   * Логин - Строка 
//   * Пароль - Строка 
//   * Провайдер  - Строка
//   * ИмяОтправителя - Строка 
//   * СпособАвторизации - Строка - например, "ПоЛогинуИПаролю".
// 
Функция НастройкиОтправкиSMS() Экспорт
	
	Результат = Новый Структура("Логин,Пароль,Провайдер,ИмяОтправителя,СпособАвторизации");
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
		НастройкиПровайдера = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль,Логин,ИмяОтправителя,СпособАвторизации");
		ЗаполнитьЗначенияСвойств(Результат, НастройкиПровайдера);
		Результат.Провайдер = Константы.ПровайдерSMS.Получить();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиПровайдераПоУмолчанию()
	
	Результат = Новый Структура;
	Результат.Вставить("АдресОписанияУслугиВИнтернете", "");
	Результат.Вставить("СпособыАвторизации", СпособыАвторизацииПоУмолчанию());
	Результат.Вставить("ПоляАвторизации", ПоляАвторизацииПровайдераПоУмолчанию());
	Результат.Вставить("ИнформацияПоСпособамАвторизации", Новый Структура);
	Результат.Вставить("ПриОпределенииСпособовАвторизации", Ложь);
	Результат.Вставить("ПриОпределенииПолейАвторизации", Ложь);
	Результат.Вставить("ПриЗаполненииСпискаТекущихДел", Ложь);
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиПровайдера(Провайдер) Экспорт
	
	НастройкиПровайдера = НастройкиПровайдераПоУмолчанию();
	МодульОтправкаSMSЧерезПровайдера = МодульОтправкаSMSЧерезПровайдера(Провайдер);
	
	Если МодульОтправкаSMSЧерезПровайдера <> Неопределено Тогда
		МодульОтправкаSMSЧерезПровайдера.ПриОпределенииНастроек(НастройкиПровайдера);
		Если НастройкиПровайдера.ПриОпределенииСпособовАвторизации Тогда
			МодульОтправкаSMSЧерезПровайдера.ПриОпределенииСпособовАвторизации(НастройкиПровайдера.СпособыАвторизации);
		КонецЕсли;
		Если НастройкиПровайдера.ПриОпределенииПолейАвторизации Тогда
			МодульОтправкаSMSЧерезПровайдера.ПриОпределенииПолейАвторизации(НастройкиПровайдера.ПоляАвторизации);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НастройкиПровайдера;
	
КонецФункции

#КонецОбласти
