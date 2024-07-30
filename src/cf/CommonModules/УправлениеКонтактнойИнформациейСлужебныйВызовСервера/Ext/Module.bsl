﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Разбирает представление контактной информации и возвращает строку JSON со значениями полей.
//
//  Параметры:
//      Текст        - Строка - представление контактной информации
//      ОжидаемыйТип - СправочникСсылка.ВидыКонтактнойИнформации
//                   - ПеречислениеСсылка.ТипыКонтактнойИнформации - для
//                     контроля типов.
//      Комментарий  - Строка - комментарий, введенный пользователем к строке контактной информации
//
//  Возвращаемое значение:
//      Строка - JSON
//
Функция КонтактнаяИнформацияПоПредставлению(Знач Текст, Знач ОжидаемыйВид, Знач Комментарий) Экспорт
	
	КонтактнаяИнформация = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияПоПредставлению(Текст, ОжидаемыйВид);
	КонтактнаяИнформация.comment = Комментарий;
	Возврат УправлениеКонтактнойИнформациейСлужебный.СтруктураВСтрокуJSON(КонтактнаяИнформация);
		
КонецФункции

// Возвращает строку состава из значения контактной информации.
//
//  Параметры:
//      XMLДанные - Строка - XML данных контактной информации.
//
//  Возвращаемое значение:
//      Строка - содержимое
//      Неопределено - если значение состава сложного типа.
//
Функция СтрокаСоставаКонтактнойИнформации(Знач XMLДанные) Экспорт;
	
	Если УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ДоступенМодульЛокализации() Тогда
		МодульУправлениеКонтактнойИнформациейЛокализация = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейЛокализация");
		Возврат МодульУправлениеКонтактнойИнформациейЛокализация.СтрокаСоставаКонтактнойИнформации(XMLДанные);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Параметры:
//  Данные - см. УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеКонтактнойИнформации
// 
// Возвращаемое значение:
//  Структура:
//    * ДанныеXML - Строка 
//    * ТипКонтактнойИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации
//                              - Неопределено
//
Функция ПривестиКонтактнуюИнформациюXML(Знач Данные) Экспорт
	
	Результат = УправлениеКонтактнойИнформацией.ПоляКонтактнойИнформацииДляПреобразования();
	
	Если УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ДоступенМодульЛокализации() Тогда
		МодульУправлениеКонтактнойИнформациейЛокализация = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейЛокализация");
		Возврат МодульУправлениеКонтактнойИнформациейЛокализация.ПривестиКонтактнуюИнформациюXML(Данные);
	КонецЕсли;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(Данные.ЗначенияПолей) Тогда
		ПоляКонтактнойИнформации = УправлениеКонтактнойИнформацией.БазовыеСведенияКонтактнойИнформации(Данные.ЗначенияПолей);
		ЗаполнитьЗначенияСвойств(Результат, ПоляКонтактнойИнформации);
	Иначе
		Результат.Представление           = Данные.Представление;
		Результат.ТипКонтактнойИнформации = Данные.ВидКонтактнойИнформации;
	КонецЕсли;
	
	Возврат Результат;

	
КонецФункции

// Возвращает найденную ссылку или создает новую страну мира и возвращает ссылку на нее.
// 
// Параметры:
//  КодСтраны - Строка 
// 
// Возвращаемое значение:
//   см. УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию
//
Функция СтранаМираПоДаннымКлассификатора(Знач КодСтраны) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КодСтраны);
	
КонецФункции

// Заполняет коллекцию ссылками на найденные или созданные страны мира.
//
Процедура КоллекцияСтранМираПоДаннымКлассификатора(Коллекция) Экспорт
	
	Для Каждого КлючЗначение Из Коллекция Цикл
		Коллекция[КлючЗначение.Ключ] =  УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КлючЗначение.Значение.Код);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет список вариантов адреса при автоподборе по введенному пользователем тексту.
//
Процедура АвтоподборАдреса(Знач Текст, ДанныеВыбора) Экспорт
	
	УправлениеКонтактнойИнформациейСлужебный.АвтоподборАдреса(Текст, ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти
