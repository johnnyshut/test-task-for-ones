﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем КлиентскиеПараметры Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	СохранятьСертификатВместеСПодписью = ПерсональныеНастройки.СохранятьСертификатВместеСПодписью;
	СохранятьСертификатВместеСПодписьюИсходноеЗначение = СохранятьСертификатВместеСПодписью;
	
	СохранятьВсеПодписи = Параметры.СохранятьВсеПодписи;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокДанных) Тогда
		Элементы.ПредставлениеДанных.Заголовок = Параметры.ЗаголовокДанных;
	Иначе
		Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
	ПредставлениеДанных = Параметры.ПредставлениеДанных;
	Элементы.ПредставлениеДанных.Гиперссылка = Параметры.ПредставлениеДанныхОткрывается;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		Элементы.ПредставлениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ПоказатьКомментарий Тогда
		Элементы.ТаблицаПодписейКомментарий.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПодписи(Параметры.Объект);
	
	ЭлектроннаяПодписьЛокализация.ПриСозданииНаСервере(ЭтотОбъект);
	
	БольшеНеСпрашивать = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СохранятьВсеПодписи Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, КлиентскиеПараметры.ТекущийСписокПредставлений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьПодпись(Команда)
	
	Если БольшеНеСпрашивать Или (СохранятьСертификатВместеСПодписью <> СохранятьСертификатВместеСПодписьюИсходноеЗначение)Тогда
		СохранитьНастройки(БольшеНеСпрашивать, СохранятьСертификатВместеСПодписью);
		ОбновитьПовторноИспользуемыеЗначения();
		Оповестить("Запись_ЛичныеНастройкиЭлектроннойПодписиИШифрования", Новый Структура, "ДействияПриСохраненииСЭП, СохранятьСертификатВместеСПодписью");
	КонецЕсли;
	
	Закрыть(ТаблицаПодписей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлектроннаяПодписьСлужебный.ОформитьСписокПодписей(ЭтотОбъект, "ТаблицаПодписей");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодписи(Объект)
	
	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		КоллекцияПодписей = ПолучитьИзВременногоХранилища(Объект);
	Иначе
		КоллекцияПодписей = ЭлектроннаяПодпись.УстановленныеПодписи(Объект, Неопределено, Истина);
	КонецЕсли;
	
	Для каждого ВсеСвойстваПодписи Из КоллекцияПодписей Цикл
		НоваяСтрока = ТаблицаПодписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВсеСвойстваПодписи);
		
		НоваяСтрока.АдресПодписи = ПоместитьВоВременноеХранилище(
			ВсеСвойстваПодписи.Подпись, УникальныйИдентификатор);
		
		Если ЗначениеЗаполнено(ВсеСвойстваПодписи.РезультатПроверкиПодписиПоМЧД) Тогда
			Для Каждого РезультатПроверкиПодписиПоМЧД Из ВсеСвойстваПодписи.РезультатПроверкиПодписиПоМЧД Цикл
				НоваяСтрока.МашиночитаемаяДоверенность.Добавить(
					РезультатПроверкиПодписиПоМЧД.МашиночитаемаяДоверенность);
				НоваяСтрока.МашиночитаемаяДоверенностьПредставление = НоваяСтрока.МашиночитаемаяДоверенностьПредставление
					+ ?(ЗначениеЗаполнено(НоваяСтрока.МашиночитаемаяДоверенностьПредставление), Символы.ПС, "")
					+ РезультатПроверкиПодписиПоМЧД.МашиночитаемаяДоверенность;
			КонецЦикла;
		КонецЕсли;
		
		ДанныеПоСертификату = ЭлектроннаяПодписьСлужебный.ДанныеПоСертификату(ВсеСвойстваПодписи, УникальныйИдентификатор);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеПоСертификату);
		
		НоваяСтрока.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройки(БольшеНеСпрашивать, СохранятьСертификатВместеСПодписью)
	
	ЧастьНастроек = Новый Структура;
	Если БольшеНеСпрашивать Тогда
		ЧастьНастроек.Вставить("ДействияПриСохраненииСЭП", "СохранятьВсеПодписи");
	КонецЕсли;
	ЧастьНастроек.Вставить("СохранятьСертификатВместеСПодписью", СохранятьСертификатВместеСПодписью);
	ЭлектроннаяПодписьСлужебный.СохранитьПерсональныеНастройки(ЧастьНастроек);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
