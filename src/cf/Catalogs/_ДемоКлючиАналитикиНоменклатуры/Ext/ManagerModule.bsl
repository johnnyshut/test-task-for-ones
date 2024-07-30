﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает ключевые реквизиты справочника.
// 
// Возвращаемое значение:
//   - Соответствие 
//
Функция КлючевыеРеквизиты() Экспорт

	КлючевыеРеквизиты = Новый Соответствие;
	КлючевыеРеквизиты.Вставить("Номенклатура");
	КлючевыеРеквизиты.Вставить("МестоХранения");
	Возврат КлючевыеРеквизиты;

КонецФункции

// Вызывается при замене дублей в реквизитах элементов.
//
// Параметры:
//  ПарыЗамен - Соответствие - содержит пары значений оригинал и дубль.
//  НеобработанныеЗначенияОригиналов - Массив из Структура:
//    * ЗаменяемоеЗначение - ЛюбаяСсылка - оригинальное значение заменяемого объекта.
//    * ИспользуемыеСвязи - см. ОбщегоНазначения.СвязиПодчиненныхОбъектовПоТипам
//    * ЗначениеКлючевыхРеквизитов - Структура - Ключ - имя реквизита, значение - значение реквизита.
//
Процедура ПриПоискеЗаменыСсылок(ПарыЗамен, НеобработанныеЗначенияОригиналов) Экспорт

	Для Каждого НеобработанныйДубль Из НеобработанныеЗначенияОригиналов Цикл
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НеобработанныйДубль.ЗаменяемоеЗначение);
		
		ПараметрыКлюча = Новый Структура;
		Для Каждого КлючевойРеквизит Из НеобработанныйДубль.ЗначениеКлючевыхРеквизитов Цикл
			ЗначениеОригинала = ПарыЗамен.Получить(КлючевойРеквизит.Значение);
			ПараметрыКлюча.Вставить(КлючевойРеквизит.Ключ, ?(ЗначениеОригинала = Неопределено, КлючевойРеквизит.Значение, ЗначениеОригинала));
		КонецЦикла;
	
		ПарыЗамен.Вставить(НеобработанныйДубль.ЗаменяемоеЗначение, Менеджер.СоздатьКлюч(ПараметрыКлюча));
	КонецЦикла;

КонецПроцедуры

// Создает новый ключ по ключевым полям или возвращает существующий.
//
// Параметры:
//  ПараметрыКлюча - Структура:
//   * МестоХранения - СправочникСсылка._ДемоПартнеры, СправочникСсылка._ДемоМестаХранения
//   * Номенклатура - СправочникСсылка._ДемоНоменклатура
//
// Возвращаемое значение:
//   СправочникСсылка._ДемоКлючиАналитикиНоменклатуры 
//
Функция СоздатьКлюч(ПараметрыКлюча) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	_ДемоКлючиАналитикиНоменклатуры.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник._ДемоКлючиАналитикиНоменклатуры КАК _ДемоКлючиАналитикиНоменклатуры
	|ГДЕ
	|	_ДемоКлючиАналитикиНоменклатуры.Номенклатура = &Номенклатура
	|	И _ДемоКлючиАналитикиНоменклатуры.МестоХранения = &МестоХранения";

	Запрос.УстановитьПараметр("МестоХранения", ПараметрыКлюча.МестоХранения);
	Запрос.УстановитьПараметр("Номенклатура", ПараметрыКлюча.Номенклатура);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Ключ = Справочники._ДемоКлючиАналитикиНоменклатуры.СоздатьЭлемент();
		Ключ.Наименование = Строка(ПараметрыКлюча.Номенклатура) + "," + Строка(ПараметрыКлюча.МестоХранения);
		Ключ.Номенклатура = ПараметрыКлюча.Номенклатура;
		Ключ.МестоХранения = ПараметрыКлюча.МестоХранения;
		Ключ.Записать();
	Иначе
		Ключ = РезультатЗапроса.Выбрать();
		Ключ.Следующий();
	КонецЕсли;

	Возврат Ключ.Ссылка;

КонецФункции

#КонецОбласти

#КонецЕсли