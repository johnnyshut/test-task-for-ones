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
	
	ДополнительныеДанные = Параметры.ДополнительныеДанные;
	
	Если ЗначениеЗаполнено(ДополнительныеДанные) Тогда
		ОшибкаПроверкиПодписи = ЗначениеЗаполнено(ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "ДанныеПодписи", Ложь));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИнформацияДляПоддержки) Тогда
		Элементы.ИнформацияДляПоддержки.Заголовок = Параметры.ИнформацияДляПоддержки;
	Иначе
		Элементы.ИнформацияДляПоддержки.Заголовок = ЭлектроннаяПодписьСлужебный.ЗаголовокИнформацииДляПоддержки();
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.УстановитьЗаголовокОшибки(ЭтотОбъект,
		Параметры.ЗаголовокПредупреждения);
	
	ТекстОшибкиКлиент = Параметры.ТекстОшибкиКлиент;
	ТекстОшибкиСервер = Параметры.ТекстОшибкиСервер;
	ТекстОшибки = Параметры.ТекстОшибки;
	
	ДвеОшибки = Не ПустаяСтрока(ТекстОшибкиКлиент)
		И Не ПустаяСтрока(ТекстОшибкиСервер);
	
	УстановитьЭлементы(ТекстОшибкиКлиент, ДвеОшибки, "Клиент");
	УстановитьЭлементы(ТекстОшибкиСервер, ДвеОшибки, "Сервер");
	УстановитьЭлементы(ТекстОшибки, ДвеОшибки, "");
	
	Элементы.ДекорацияРазделитель.Видимость = ДвеОшибки;
	
	Если ДвеОшибки
	   И ПустаяСтрока(ЯкорьОшибкиКлиент)
	   И ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
		
		Элементы.ИнструкцияКлиент.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаПодвал.Видимость = Параметры.ПоказатьТребуетсяПомощь;
	Элементы.ДекорацияРазделитель2.Видимость = Параметры.ПоказатьТребуетсяПомощь;
	
	ВидимостьСсылкиНаИнструкцию =
		ЭлектроннаяПодписьСлужебный.ВидимостьСсылкиНаИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	
	Если Параметры.ПоказатьТребуетсяПомощь Тогда
		Элементы.Помощь.Видимость                     = Параметры.ПоказатьИнструкцию;
		Элементы.ФормаПерейтиКНастройкеПрограмм.Видимость = Параметры.ПоказатьПереходКНастройкеПрограмм;
		Элементы.ФормаУстановитьРасширение.Видимость      = Параметры.ПоказатьУстановкуРасширения;
		Элементы.ИнструкцияКлиент.Видимость = Элементы.ИнструкцияКлиент.Видимость И ВидимостьСсылкиНаИнструкцию 
			И ЗначениеЗаполнено(ЯкорьОшибкиКлиент);
		Элементы.ИнструкцияСервер.Видимость = ВидимостьСсылкиНаИнструкцию И ЗначениеЗаполнено(ЯкорьОшибкиСервер);
		ОписаниеОшибки = Параметры.ОписаниеОшибки;
	Иначе
		Элементы.ИнструкцияКлиент.Видимость = Элементы.ИнструкцияКлиент.Видимость И ВидимостьСсылкиНаИнструкцию;
		Элементы.ИнструкцияСервер.Видимость = ВидимостьСсылкиНаИнструкцию;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не МобильноеПриложениеКлиент И Не МобильныйКлиент Тогда
	Если ПараметрыДополненияТекстаРешенияОшибкиКлассификатора <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ДополнитьРешениеКлассификатораОшибокПодробностями", 0.1, Истина);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЯкорьОшибки = ""; ТекстДляПоиска = "";
	Если Элемент.Имя = "ИнструкцияКлиент" Тогда
		Если Не ПустаяСтрока(ЯкорьОшибкиКлиент) Тогда
			ЯкорьОшибки = ЯкорьОшибкиКлиент;
		Иначе
			ТекстДляПоиска = ТекстОшибкиКлиент;
		КонецЕсли;
	ИначеЕсли Элемент.Имя = "ИнструкцияСервер" Тогда
		Если Не ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
			ЯкорьОшибки = ЯкорьОшибкиСервер;
		Иначе
			ТекстДляПоиска = ТекстОшибкиСервер;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстДляПоиска) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьПоискПоОшибкамПриРаботеСЭлектроннойПодписью(ТекстДляПоиска);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами(ЯкорьОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияДляПоддержкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "ТипичныеПроблемы" Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	Иначе
		
		ОписаниеФайлов = Новый Массив;
		ТекстОшибок = "";
		Если ЗначениеЗаполнено(ДополнительныеДанные) Тогда
			ЭлектроннаяПодписьСлужебныйВызовСервера.ДобавитьОписаниеДополнительныхДанных(
				ДополнительныеДанные, ОписаниеФайлов, ТекстОшибок);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			ТемаСообщения = ТемаСообщения(ОписаниеОшибки);
		ИначеЕсли ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТемаСообщения = ТемаСообщения(ТекстОшибки);
		ИначеЕсли ЗначениеЗаполнено(ТекстОшибкиКлиент) Тогда
			ТемаСообщения = ТемаСообщения(ТекстОшибкиКлиент);
		ИначеЕсли ЗначениеЗаполнено(ТекстОшибкиСервер) Тогда
			ТемаСообщения = ТемаСообщения(ТекстОшибкиСервер);
		Иначе
			ТемаСообщения = НСтр("ru = 'Техническая информация о возникшей проблеме'");
		КонецЕсли;
		
		Массив = Новый Массив;
		Если ЗначениеЗаполнено(ТекстОшибок) Тогда
			Массив.Добавить(ТекстОшибок);
		КонецЕсли;
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			Массив.Добавить(ОписаниеОшибки);
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			Массив.Добавить(ТекстОшибки);
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекстОшибкиКлиент) Тогда
			Массив.Добавить(НСтр("ru = 'На клиенте:'"));
			Массив.Добавить(ТекстОшибкиКлиент);
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекстОшибкиСервер) Тогда
			Массив.Добавить(НСтр("ru = 'На сервере:'"));
			Массив.Добавить(ТекстОшибкиСервер);
		КонецЕсли;
		
		ТекстОшибок = СтрСоединить(Массив, Символы.ПС);
		
		ЭлектроннаяПодписьСлужебныйКлиент.СформироватьТехническуюИнформацию(
			ТекстОшибок, Новый Структура("Тема, Сообщение", ТемаСообщения), , ОписаниеФайлов);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ТемаСообщения(Знач Ошибка)
	
	ПереносСтроки = СтрНайти(Ошибка, Символы.ПС);
	Если ПереносСтроки = 0 Тогда
		ТемаСообщения = Лев(Ошибка, 100);
	Иначе
		ТемаСообщения = Лев(Ошибка, ПереносСтроки - 1);
	КонецЕсли;
	
	Возврат ТемаСообщения;
	
КонецФункции

&НаКлиенте
Процедура ПричиныКлиентТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура РешенияКлиентТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура ПричиныСерверТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура РешенияСерверТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройкеПрограмм(Команда)
	
	Закрыть();
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Программы");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьРасширение(Истина);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДополнитьРешениеКлассификатораОшибокПодробностями()
	
	ОшибкаПоКлассификатору = Новый Структура;
	ОшибкаПоКлассификатору.Вставить("ТекстОшибки", Элементы.ТекстОшибкиКлиент.Заголовок);
	ОшибкаПоКлассификатору.Вставить("Причина", Элементы.ПричиныКлиентТекст.Заголовок);
	ОшибкаПоКлассификатору.Вставить("Решение", Элементы.РешенияКлиентТекст.Заголовок);
	
	ДанныеДляДополнения = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДанныеДляДополненияОшибкиИзКлассификатора(ДополнительныеДанные);
	ЭлектроннаяПодписьСлужебныйКлиент.ДополнитьРешениеКлассификатораОшибокПодробностями(
		Новый ОписаниеОповещения("ПослеДополненияРешенияКлассификатораОшибок", ЭтотОбъект),
		ОшибкаПоКлассификатору, ПараметрыДополненияТекстаРешенияОшибкиКлассификатора, ДанныеДляДополнения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеДополненияРешенияКлассификатораОшибок(ОшибкаПоКлассификатору, Контекст) Экспорт
	
	Если Элементы.РешенияКлиентТекст.Заголовок <> ОшибкаПоКлассификатору.Решение Тогда
		Элементы.РешенияКлиентТекст.Заголовок = ОшибкаПоКлассификатору.Решение;
	КонецЕсли;
	Если Элементы.ПричиныКлиентТекст.Заголовок <> ОшибкаПоКлассификатору.Причина Тогда
		Элементы.ПричиныКлиентТекст.Заголовок = ОшибкаПоКлассификатору.Причина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЭлементы(ТекстОшибки, ДвеОшибки, МестоОшибки)
	
	Если МестоОшибки = "Сервер" Тогда
		ЭлементОшибка = Элементы.ОшибкаСервер;
		ЭлементТекстОшибки = Элементы.ТекстОшибкиСервер;
		ЭлементИнструкция = Элементы.ИнструкцияСервер;
		ЭлементПричиныТекст = Элементы.ПричиныСерверТекст;
		ЭлементРешенияТекст = Элементы.РешенияСерверТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияСервер;
	ИначеЕсли МестоОшибки = "Клиент" Тогда
		ЭлементОшибка = Элементы.ОшибкаКлиент;
		ЭлементТекстОшибки = Элементы.ТекстОшибкиКлиент;
		ЭлементИнструкция = Элементы.ИнструкцияКлиент;
		ЭлементПричиныТекст = Элементы.ПричиныКлиентТекст;
		ЭлементРешенияТекст = Элементы.РешенияКлиентТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияКлиент;
	Иначе
		ЭлементОшибка = Элементы.Ошибка;
		ЭлементТекстОшибки = Элементы.ТекстОшибки;
		ЭлементИнструкция = Элементы.Инструкция;
		ЭлементПричиныТекст = Элементы.ПричиныТекст;
		ЭлементРешенияТекст = Элементы.РешенияТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешения;
	КонецЕсли;
	
	ЭлементОшибка.Видимость = Не ПустаяСтрока(ТекстОшибки);
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		
		ЕстьПричинаИРешение = Неопределено;
		Если ТипЗнч(ДополнительныеДанные) = Тип("Структура") Тогда
			Если МестоОшибки = "Сервер" Тогда
				СуффиксПроверок = "НаСервере";
			ИначеЕсли МестоОшибки = "Клиент" Тогда
				СуффиксПроверок = "НаКлиенте";
			Иначе
				СуффиксПроверок = "";
			КонецЕсли;
				
			ЕстьПричинаИРешение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, 
				"ДополнительныеДанныеПроверок" + СуффиксПроверок, Неопределено); // см. ЭлектроннаяПодписьСлужебныйКлиентСервер.ПредупреждениеПриПроверкеУдостоверяющегоЦентраСертификата
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЕстьПричинаИРешение) Тогда
			ОшибкаПоКлассификатору = ЭлектроннаяПодписьСлужебный.ПредставлениеОшибки();
			Причина = ЕстьПричинаИРешение.Причина; // Строка
			ОшибкаПоКлассификатору.Причина = ФорматированнаяСтрока(Причина);
			ОшибкаПоКлассификатору.Решение = ФорматированнаяСтрока(ЕстьПричинаИРешение.Решение);
		Иначе
			ОшибкаПоКлассификатору = ЭлектроннаяПодписьСлужебный.ОшибкаПоКлассификатору(ТекстОшибки, МестоОшибки = "Сервер", ОшибкаПроверкиПодписи);
		КонецЕсли;
		
		ЭтоИзвестнаяОшибка = ОшибкаПоКлассификатору <> Неопределено;
		
		ГруппаПричиныИРешения.Видимость = ЭтоИзвестнаяОшибка;
		Если ЭтоИзвестнаяОшибка Тогда
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.ДействияДляУстранения) Тогда
				Если ПараметрыДополненияТекстаРешенияОшибкиКлассификатора = Неопределено Тогда
					ПараметрыДополненияТекстаРешенияОшибкиКлассификатора = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПараметрыДополненияТекстаРешенияОшибкиКлассификатора();
				КонецЕсли;
				ДанныеДляДополнения = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДанныеДляДополненияОшибкиИзКлассификатора(ДополнительныеДанные);
				Дополнение = ЭлектроннаяПодписьСлужебный.ДополнитьРешениеКлассификатораОшибокПодробностями(
					ОшибкаПоКлассификатору, ДанныеДляДополнения, 
					ПараметрыДополненияТекстаРешенияОшибкиКлассификатора, МестоОшибки);
				ОшибкаПоКлассификатору = Дополнение.ОшибкаПоКлассификатору;
				ПараметрыДополненияТекстаРешенияОшибкиКлассификатора = Дополнение.ПараметрыДополненияТекстаРешенияОшибкиКлассификатораНаКлиенте;
			КонецЕсли;
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементИнструкция.Имя, "Заголовок", НСтр("ru = 'Подробнее'"));
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.Причина) Тогда
				Если ТипЗнч(ЭлементПричиныТекст) = Тип("ДекорацияФормы") Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементПричиныТекст.Имя, "Заголовок", ОшибкаПоКлассификатору.Причина);
				Иначе
					ЭтотОбъект[ЭлементПричиныТекст.ПутьКДанным] = ОшибкаПоКлассификатору.Причина;
				КонецЕсли;
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементПричиныТекст.Имя, "Видимость", Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.Решение) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементРешенияТекст.Имя, "Заголовок", ОшибкаПоКлассификатору.Решение);
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементРешенияТекст.Имя, "Видимость", Ложь);
			КонецЕсли;
			
			Если МестоОшибки = "Сервер" Тогда
				ЯкорьОшибкиСервер = ОшибкаПоКлассификатору.Ссылка;
			ИначеЕсли МестоОшибки = "Клиент" Тогда
				ЯкорьОшибкиКлиент = ОшибкаПоКлассификатору.Ссылка;
			Иначе
				ЯкорьОшибки = ОшибкаПоКлассификатору.Ссылка;
			КонецЕсли;
		
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементИнструкция.Имя, "Заголовок", НСтр("ru = 'Подробнее'"));
		
		ТребуемоеКоличествоСтрок = 0;
		ШиринаПоля = Цел(?(Ширина < 20, 20, Ширина) * 1.4);
		Для НомерСтроки = 1 По СтрЧислоСтрок(ТекстОшибки) Цикл
			ТребуемоеКоличествоСтрок = ТребуемоеКоличествоСтрок + 1
				+ Цел(СтрДлина(СтрПолучитьСтроку(ТекстОшибки, НомерСтроки)) / ШиринаПоля);
		КонецЦикла;
		Если ТребуемоеКоличествоСтрок > 5 И Не ДвеОшибки Тогда
			ЭлементТекстОшибки.Высота = 4;
		ИначеЕсли ТребуемоеКоличествоСтрок > 3 Тогда
			ЭлементТекстОшибки.Высота = 3;
		ИначеЕсли ТребуемоеКоличествоСтрок > 1 Тогда
			ЭлементТекстОшибки.Высота = 2;
		Иначе
			ЭлементТекстОшибки.Высота = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДополнительныеДанные()
	
	Если Не ЗначениеЗаполнено(ДополнительныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДополнительныеДанныеДляКлассификатораОшибок = ЭлектроннаяПодписьСлужебныйКлиент.ДополнительныеДанныеДляКлассификатораОшибок();
	Сертификат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "Сертификат", Неопределено);
	Если ЗначениеЗаполнено(Сертификат) Тогда
		Если ТипЗнч(Сертификат) = Тип("Массив") Тогда
			Если Сертификат.Количество() > 0 Тогда
				Если ТипЗнч(Сертификат[0]) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
					ДополнительныеДанныеДляКлассификатораОшибок.Сертификат = Сертификат[0];
					ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата(Сертификат[0], УникальныйИдентификатор);
				Иначе
					ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = Сертификат[0];
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
			ДополнительныеДанныеДляКлассификатораОшибок.Сертификат = Сертификат;
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата(Сертификат, УникальныйИдентификатор);
		ИначеЕсли ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ПоместитьВоВременноеХранилище(Сертификат, УникальныйИдентификатор);
		Иначе
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = Сертификат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеСертификата = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "ДанныеСертификата", Неопределено);
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата;
	КонецЕсли;
	
	ДанныеПодписи = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "ДанныеПодписи", Неопределено);
	Если ЗначениеЗаполнено(ДанныеПодписи) Тогда
		ДополнительныеДанныеДляКлассификатораОшибок.ДанныеПодписи = ДанныеПодписи;
	КонецЕсли;
	
	Возврат ДополнительныеДанныеДляКлассификатораОшибок;

КонецФункции

&НаСервере
Функция ФорматированнаяСтрока(Знач Строка)
	
	Если ТипЗнч(Строка) = Тип("Строка") Тогда
		Строка = СтроковыеФункции.ФорматированнаяСтрока(Строка);
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеСертификата(Сертификат, УникальныйИдентификатор)
	
	ДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "ДанныеСертификата").Получить();
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		Если ЗначениеЗаполнено(УникальныйИдентификатор) Тогда
			Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
		Иначе
			Возврат ДанныеСертификата;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
