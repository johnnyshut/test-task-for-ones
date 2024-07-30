﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Параметры.ИдентификаторЗадания);
	Если Задание <> Неопределено
		И СтрНачинаетсяС(Задание.ИмяМетода, "ОчередьЗаданий") Тогда
		Заголовок = НСтр("ru = 'Резервное копирование'");
		Элементы.ДекорацияНадпись.Заголовок = 
			НСтр("ru = 'Подождите, выполняется резервное копирование, работа временно невозможна'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбработчикОжидания", 3);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаданиеЗавершено Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикОжидания()
	
	Если Не ЗаданиеВыполняется(Параметры.ИдентификаторЗадания) Тогда
		ОтключитьОбработчикОжидания("ОбработчикОжидания");
		ЗаданиеЗавершено = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполняется(ИдентификаторЗадания)
	УстановитьПривилегированныйРежим(Истина);
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание <> Неопределено И Задание.Состояние = СостояниеФоновогоЗадания.Активно;
КонецФункции

#КонецОбласти
