﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает значение настройки РегистрироватьДоступКДанным
// панели НастройкиПользователейИПрав.
//
// Возвращаемое значение:
//  Булево
//
Функция РегистрироватьДоступКДанным() Экспорт
	
	Возврат КонтрольРаботыПользователейСлужебный.РегистрироватьДоступКДанным();
	
КонецФункции

// Устанавливает значение настройки РегистрироватьДоступКДанным
// панели НастройкиПользователейИПрав.
//
// Параметры:
//  РегистрироватьДоступКДанным - Булево
//
Процедура УстановитьРегистрациюДоступаКДанным(РегистрироватьДоступКДанным) Экспорт
	
	КонтрольРаботыПользователейСлужебный.УстановитьРегистрациюДоступаКДанным(РегистрироватьДоступКДанным);
	
КонецПроцедуры

// Возвращает настройки регистрации событий, доступные по ссылке Настройки
// панели НастройкиПользователейИПрав.
//
// Возвращаемое значение:
//  Структура:
//    * Состав - Массив из ОписаниеИспользованияСобытияДоступЖурналаРегистрации
//    * Комментарии - Соответствие из КлючИЗначение:
//        * Ключ     - Строка - полное имя таблицы + имя поля, например "Справочник.ФизическиеЛица.НомерДокумента".
//        * Значение - Строка - произвольный текст
//    * ОбщийКомментарий - Строка - произвольный текст
//   
Функция НастройкиРегистрацииСобытийДоступаКДанным() Экспорт
	
	Возврат КонтрольРаботыПользователейСлужебный.НастройкиРегистрацииСобытийДоступаКДанным();
	
КонецФункции

// Устанавливает настройки регистрации событий, доступные по ссылке Настройки
// панели НастройкиПользователейИПрав.
//
// Параметры:
//  Настройки - см. НастройкиРегистрацииСобытийДоступаКДанным
//
Процедура УстановитьНастройкиРегистрацииСобытийДоступаКДанным(Настройки) Экспорт
	
	КонтрольРаботыПользователейСлужебный.УстановитьНастройкиРегистрацииСобытийДоступаКДанным(Настройки);
	
КонецПроцедуры

#КонецОбласти
