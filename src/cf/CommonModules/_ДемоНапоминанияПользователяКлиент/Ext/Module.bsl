﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает новое напоминание, срабатывающее за 5 минут до срока исполнения.
// 
// Параметры:
//  Предмет - ЗадачаСсылка.ЗадачаИсполнителя
//  Параметры - Произвольный - не используется.
//  
Процедура НапомнитьЗа5Минут(Предмет, Параметры) Экспорт
	
	НапоминанияПользователяКлиент.НапомнитьДоВремениПредмета(Строка(Предмет), 5*60, Предмет, "СрокИсполнения");
	ПоказатьОповещениеПользователя(НСтр("ru = 'Создано напоминание:'"), , Строка(Предмет), БиблиотекаКартинок.ДиалогИнформация);

КонецПроцедуры

// Создает новое напоминание через 10 минут от текущего момента.
// 
// Параметры:
//  Предмет - СправочникСсылка._ДемоКонтрагенты
//  Параметры - Произвольный - не используется.
//  
Процедура НапомнитьЧерез10Минут(Предмет, Параметры) Экспорт
	
	ТекстНапоминания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" требует внимания'"),
		Предмет);
	НапоминанияПользователяКлиент.НапомнитьВУказанноеВремя(ТекстНапоминания, 
		ОбщегоНазначенияКлиент.ДатаСеанса() + 10 * 60, Предмет);

	ПоказатьОповещениеПользователя(НСтр("ru = 'Создано напоминание:'"),, ТекстНапоминания,
		БиблиотекаКартинок.ДиалогИнформация);
		
КонецПроцедуры

// Создает новое напоминание о дне рождения с датой напоминания за 3 дня.
// 
// Параметры:
//  Предмет - СправочникСсылка._ДемоФизическиеЛица
//  Параметры - Произвольный - не используется.
//  
Процедура НапомнитьОДнеРожденияЗа3Дня(Предмет, Параметры) Экспорт

	ТекстНапоминания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
		"ru = 'День рождения сотрудника: %1'"), Строка(Предмет));
	НапоминанияПользователяКлиент.НапомнитьОЕжегодномСобытииПредмета(
		ТекстНапоминания, 60 * 60 * 24 * 3, Предмет, "ДатаРождения");

	ПоказатьОповещениеПользователя(НСтр("ru = 'Создано напоминание:'"),, ТекстНапоминания,
		БиблиотекаКартинок.ДиалогИнформация);
		
КонецПроцедуры

#КонецОбласти