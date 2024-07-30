﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриИзмененииХранитьИсториюРассылкиОтчетов() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ХранитьИсториюРассылкиОтчетов") Тогда
		УстановитьИспользованиеРегламентногоЗадания(Метаданные.РегламентныеЗадания.ПолучениеСтатусовЭлектронныхПисем, Истина);
		УстановитьИспользованиеРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииРассылкиОтчетов, Истина);
	Иначе
		УстановитьИспользованиеРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииРассылкиОтчетов, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
//
// Параметры:
//   ПараметрыПолучателей - Структура
//
// Возвращаемое значение:
//   Структура:
//     * Получатели - Соответствие
//     * БылиКритичныеОшибки - Булево
//     * Текст - Строка
//     * Подробно - Строка
//
Функция СформироватьСписокПолучателейРассылки(Знач ПараметрыПолучателей) Экспорт
	ПараметрыЖурнала = Новый Структура("ИмяСобытия, Метаданные, Данные, МассивОшибок, БылиОшибки");
	ПараметрыЖурнала.ИмяСобытия   = НСтр("ru = 'Рассылка отчетов. Формирование списка получателей'", ОбщегоНазначения.КодОсновногоЯзыка());
	ПараметрыЖурнала.МассивОшибок = Новый Массив;
	ПараметрыЖурнала.БылиОшибки   = Ложь;
	ПараметрыЖурнала.Данные       = ПараметрыПолучателей.Ссылка;
	ПараметрыЖурнала.Метаданные   = Метаданные.Справочники.РассылкиОтчетов;
	
	РезультатВыполнения = Новый Структура("Получатели, БылиКритичныеОшибки, Текст, Подробно");
	РезультатВыполнения.Получатели = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыПолучателей, ПараметрыЖурнала);
	РезультатВыполнения.БылиКритичныеОшибки = РезультатВыполнения.Получатели.Количество() = 0;
	
	Если РезультатВыполнения.БылиКритичныеОшибки Тогда
		РезультатВыполнения.Текст = РассылкаОтчетов.СтрокаСообщенийПользователю(ПараметрыЖурнала.МассивОшибок, Ложь);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

// Запускает фоновое задание.
Функция ЗапуститьФоновоеЗадание(Знач ПараметрыМетода, Знач УникальныйИдентификатор) Экспорт
	ИмяМетода = "РассылкаОтчетов.ВыполнитьРассылкиВФоновомЗадании";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылки отчетов: Выполнение рассылок в фоне'");
	НастройкиЗапуска.УточнениеОшибки = НСтр("ru = 'Не удалось выполнить рассылки отчетов по причине:'");
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

// Запускает фоновое задание для рассылки SMS с паролями архивов, для открытия вложений рассылки отчетов.
Функция ЗапуститьФоновоеЗаданиеРассылкиSMSСПаролями(Знач ПараметрыМетода, Знач УникальныйИдентификатор) Экспорт
	ИмяМетода = "РассылкаОтчетов.ВыполнитьРассылкиSMSСПаролямиАрхивовРассылкиОтчетовВФоновомЗадании";
	                             
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылки отчетов: Выполнение SMS-рассылок с паролями в фоне'");
	НастройкиЗапуска.УточнениеОшибки =
		НСтр("ru = 'Не удалось выполнить SMS-рассылку с паролями для получения рассылки отчетов по причине:'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции  

// Запускает фоновое задание для очистки истории рассылки отчетов
Функция ЗапуститьФоновоеЗаданиеОчисткиИсторииРассылкиОтчетов(Знач ПараметрыМетода, Знач УникальныйИдентификатор) Экспорт
	ИмяМетода = "РассылкаОтчетов.ВыполнитьОчисткуИсторииРассылкиОтчетовВФоновомЗадании";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылки отчетов: Очистка истории рассылки отчетов'");
	НастройкиЗапуска.УточнениеОшибки =
		НСтр("ru = 'Не удалось выполнить очистку истории рассылки отчетов по причине:'");
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

Процедура УстановитьИспользованиеРегламентногоЗадания(МетаданныеЗадание, Использование)         
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", МетаданныеЗадание);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() = 0 Тогда
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Использование);
		ПараметрыЗадания.Вставить("Метаданные", МетаданныеЗадание);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ПараметрыЗадания = Новый Структура("Использование", Использование);
		Для Каждого Задание Из СписокЗаданий Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти
