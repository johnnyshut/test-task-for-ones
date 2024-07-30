﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензированияКлиент.
//
// Клиентские процедуры и функции настройки клиента лицензирования.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Подключает обработчик запроса настроек клиента лицензирования.
//
Процедура ПодключитьЗапросНастроекКлиентаЛицензирования() Экспорт
	
	// Подключение обработчика запроса настроек клиента лицензирования
	Если Не ОбщегоНазначенияКлиент.РазделениеВключено() Тогда
		Попытка
			ИмяГлобальногоМетода = "ПриЗапросеНастроекКлиентаЛицензирования";
			ПодключитьОбработчикЗапросаНастроекКлиентаЛицензирования(ИмяГлобальногоМетода);
		Исключение
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				НСтр("ru = 'Интернет-поддержка пользователей'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
				"Ошибка",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось подключить обработчик запроса настроек клиента лицензирования.
						|%1'"),
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
