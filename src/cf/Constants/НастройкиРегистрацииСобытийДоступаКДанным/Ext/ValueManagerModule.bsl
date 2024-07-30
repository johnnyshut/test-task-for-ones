﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыеНастройки; // Заполняется ПередЗаписью для использования ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после записи изменений в журнал.
	ПодготовитьЗаписьИзмененийВЖурналРегистрации(СтарыеНастройки);
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после записи изменений в журнал.
	ЗаписатьИзмененияВЖурналРегистрации(СтарыеНастройки);
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ХранимыеНастройки - см. КонтрольРаботыПользователейСлужебный.ХранимыеНастройкиРегистрации
//
// Возвращаемое значение:
//  Структура:
//   * ВерсияСтруктурыДанных - Число
//   * Использовать - Булево
//   * Настройки - Массив из ОписаниеИспользованияСобытияДоступЖурналаРегистрации
//
Функция РегистрируемыеНастройки(ХранимыеНастройки)
	
	Результат = Новый Структура;
	Результат.Вставить("ВерсияСтруктурыДанных", 1);
	Результат.Вставить("Использовать", ХранимыеНастройки.Использовать);
	Результат.Вставить("Настройки", ХранимыеНастройки.Состав);
	
	Возврат Результат;
	
КонецФункции

Процедура ПодготовитьЗаписьИзмененийВЖурналРегистрации(СтарыеНастройки)
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	ХранимыеНастройки = КонтрольРаботыПользователейСлужебный.ХранимыеНастройкиРегистрации();
	СтарыеНастройки = РегистрируемыеНастройки(ХранимыеНастройки);
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
КонецПроцедуры

// Параметры:
//  СтарыеНастройки - см. РегистрируемыеНастройки
//
Процедура ЗаписатьИзмененияВЖурналРегистрации(СтарыеНастройки)
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	ХранимыеНастройки = КонтрольРаботыПользователейСлужебный.ХранимыеНастройкиРегистрации(Значение);
	НовыеНастройки = РегистрируемыеНастройки(ХранимыеНастройки);
	
	ЕстьИзменения = Ложь;
	Для Каждого КлючИЗначение Из НовыеНастройки Цикл
		Если ЗначениеВСтрокуВнутр(СтарыеНастройки[КлючИЗначение.Ключ])
		  <> ЗначениеВСтрокуВнутр(КлючИЗначение.Значение) Тогда
			ЕстьИзменения = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = НовыеНастройки.Настройки;
	НовыеНастройки.Настройки = Новый Массив;
	
	Для Каждого Настройка Из Настройки Цикл
		ОписаниеНастройки = Новый Структура("Объект, ПоляДоступа, ПоляРегистрации");
		ЗаполнитьЗначенияСвойств(ОписаниеНастройки, Настройка);
		НовыеНастройки.Настройки.Добавить(ОписаниеНастройки);
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		КонтрольРаботыПользователейСлужебный.ИмяСобытияАудитДоступаКДаннымИзменениеНастроекРегистрацииСобытий(),
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Константы.НастройкиРегистрацииСобытийДоступаКДанным,
		ОбщегоНазначения.ЗначениеВСтрокуXML(НовыеНастройки),
		,
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли