﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СохраненныеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"БазоваяФункциональность", "ОтключенныеПодсистемы", Новый Соответствие);
	
	// Заполняем дерево подсистем.
	Для Каждого Подсистема Из Метаданные.Подсистемы Цикл
		
		Если СтрНачинаетсяС(Подсистема.Имя, "_Демо") Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементыДерева = ОтключенныеПодсистемы.ПолучитьЭлементы();
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Подсистема = Подсистема.Имя;
		НоваяСтрока.Представление = Подсистема.Синоним;
		НоваяСтрока.Отключена = СохраненныеНастройки.Получить(Подсистема.Имя) = Истина;
		
		ПодчиненныеЭлементыДерева = НоваяСтрока.ПолучитьЭлементы();
		Для Каждого ПодчиненнаяПодсистема Из Подсистема.Подсистемы Цикл
			
			ИмяПодсистемы = Подсистема.Имя + "." + ПодчиненнаяПодсистема.Имя;
			
			НоваяСтрока = ПодчиненныеЭлементыДерева.Добавить();
			НоваяСтрока.Подсистема = ИмяПодсистемы;
			НоваяСтрока.Представление = ПодчиненнаяПодсистема.Синоним;
			НоваяСтрока.Отключена = СохраненныеНастройки.Получить(ИмяПодсистемы) = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ФормаЗаписать.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере();
	ПараметрыПриложения["СтандартныеПодсистемы.ПодсистемыКонфигурации"] = Неопределено; // сброс клиентского кеша
	
	СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	ЗначениеНастройки = Новый Соответствие;
	Для Каждого СтрокаДерева Из ОтключенныеПодсистемы.ПолучитьЭлементы() Цикл
		Если СтрокаДерева.Отключена Тогда
			ЗначениеНастройки.Вставить(СтрокаДерева.Подсистема, Истина);
		КонецЕсли;
		Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.ПолучитьЭлементы() Цикл
			Если ПодчиненнаяСтрока.Отключена Тогда
				ЗначениеНастройки.Вставить(ПодчиненнаяСтрока.Подсистема, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("БазоваяФункциональность", "ОтключенныеПодсистемы", ЗначениеНастройки);
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ОтключенныеПодсистемыОтключенаПриИзменении(Элемент)
	
	ТекущаяСтрока = ОтключенныеПодсистемы.НайтиПоИдентификатору(Элементы.ОтключенныеПодсистемы.ТекущаяСтрока);
	Для Каждого СтрокаДерева Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
		СтрокаДерева.Отключена = ТекущаяСтрока.Отключена;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти