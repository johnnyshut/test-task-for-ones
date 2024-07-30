﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта_Основной = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта_Основной.Описание = НСтр("ru = 'Выводит результаты проверок учета.'");
	НастройкиВарианта_Основной.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Отчет о проблемах объекта'");
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РезультатыПроверкиУчета);
	ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.РезультатыПроверкиУчета).Включен = Ложь;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыПроверкиУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СтрНачинаетсяС(Параметры.ИмяФормы, Метаданные.Справочники.ПравилаПроверкиУчета.ПолноеИмя()) Тогда
		Возврат;
	КонецЕсли;
	
	Команда                   = КомандыОтчетов.Добавить();
	Команда.Представление     = НСтр("ru = 'Результаты проверки учета'");
	Команда.ИмяПараметраФормы = "";
	Команда.Важность          = "СмТакже";
	Команда.КлючВарианта      = "Основной";
	Команда.Менеджер          = "Отчет.РезультатыПроверкиУчета";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
