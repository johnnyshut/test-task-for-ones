﻿
#Область СлужебныйПрограммныйИнтерфейс

// Для служебного использования.
// Параметры:
//	ТаблицаОбработчиков - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.ТаблицаОбработчиков	
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
				
	СписокМетаданных = ОбработкаТиповИсключаемыхИзВыгрузкиПовтИсп.МетаданныеИмеющиеСсылкиНаТипыИсключаемыеИзВыгрузкиИТребующиеОбработки();
		
	Для Каждого ЭлементСписка Из СписокМетаданных Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементСписка.Ключ);
		НовыйОбработчик.Обработчик = ОбработкаТиповИсключаемыхИзВыгрузки;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
		
КонецПроцедуры

// Вызывается перед выгрузкой объекта.
// см. ПриРегистрацииОбработчиковВыгрузкиДанных
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	
	РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки = РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки(ОбъектМетаданных);
	
	Если РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком %2!'"),
			ОбъектМетаданных.ПолноеИмя(),
			"ОбработкаТиповИсключаемыхИзВыгрузки.ПередВыгрузкойОбъекта");
		
	КонецЕсли;
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойКонстанты(Объект, Отказ);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойСсылочногоОбъекта(Объект, Отказ, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойНабораЗаписей(ОбъектМетаданных, Объект, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неожиданный объект метаданных: %1!'"),
			ОбъектМетаданных.ПолноеИмя);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередВыгрузкойКонстанты(Объект, Отказ)
	
	ОбработатьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Объект.Значение, Отказ);
	
КонецПроцедуры

Процедура ПередВыгрузкойСсылочногоОбъекта(Объект, Отказ, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки)
	
	Для Каждого ТекущийРеквизит Из РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки Цикл
		
		ИмяРеквизита = ТекущийРеквизит.ИмяРеквизита;

		Если ТекущийРеквизит.ИмяТабличнойЧасти = Неопределено Тогда
						
			ОбработатьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Объект[ИмяРеквизита], Отказ);		
			
		Иначе
			
			ИмяТабличнойЧасти = ТекущийРеквизит.ИмяТабличнойЧасти;
			
			Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл 
				
				ОбработатьСсылкуНаИсключаемыйИзВыгрузкиОбъект(СтрокаТабличнойЧасти[ИмяРеквизита], Отказ);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыгрузкойНабораЗаписей(ОбъектМетаданных, НаборЗаписей, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки)
	
	МассивВозможныхИзмерений = Новый Массив;
	МассивВозможныхИзмерений.Добавить("Регистратор");
	
	Если ОбщегоНазначенияБТС.ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		МассивВозможныхИзмерений.Добавить("СчетДт");
		МассивВозможныхИзмерений.Добавить("СчетКт");		
		МассивВозможныхИзмерений.Добавить("Счет");
	КонецЕсли;

	Для Каждого ОбъектМетаданныхИзмерение Из ОбъектМетаданных.Измерения Цикл
		МассивВозможныхИзмерений.Добавить(ИмяОбъектаМетаданных(ОбъектМетаданныхИзмерение));
	КонецЦикла;
		
	Для Каждого ТекущийРеквизит Из РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки Цикл
		
		ИмяСвойства = ТекущийРеквизит.ИмяРеквизита;
		НаборЗаписейВГраница = НаборЗаписей.Количество() - 1;
		
		Если НаборЗаписейВГраница < 0 Тогда
			Прервать;
		КонецЕсли;
		
		Для ИндексЗаписи = 0 по НаборЗаписейВГраница Цикл
			
			Запись = НаборЗаписей[НаборЗаписейВГраница - ИндексЗаписи];
			
			Отказ = Ложь;
			Если ОбработатьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Запись[ИмяСвойства], Отказ)  Тогда
				Если Отказ Или МассивВозможныхИзмерений.Найти(ИмяСвойства) <> Неопределено Тогда
					НаборЗаписей.Удалить(Запись);
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОбработатьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Ссылка, Отказ)
	
	Если Не ЗначениеЗаполнено(Ссылка) Или Не ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Ссылка)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДействияПриОбнаруженииСсылок = ОбработкаТиповИсключаемыхИзВыгрузкиПовтИсп.ДействияПриОбнаруженииСсылокНаТипыИсключаемыеИзВыгрузки();
	МетаданныеСсылки = Ссылка.Метаданные();
	
	Действие = ДействияПриОбнаруженииСсылок.Получить(МетаданныеСсылки);	
	Если Действие = Неопределено Или Действие = ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеИзменять() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Действие = ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиОчищать() Тогда
		Ссылка = Неопределено;		
	ИначеЕсли Действие = ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеВыгружатьОбъект() Тогда
		Отказ = Истина;
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Обнаружено неподдерживаемое действие ''%1'' при обнаружении ссылки на тип ''%2'' исключаемый из выгрузки'"),
			Действие,
			МетаданныеСсылки);
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

Функция РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки(Знач МетаданныеОбъекта)
	
	ПолноеИмяМетаданных = МетаданныеОбъекта.ПолноеИмя();
	
	СписокМетаданных = ОбработкаТиповИсключаемыхИзВыгрузкиПовтИсп.МетаданныеИмеющиеСсылкиНаТипыИсключаемыеИзВыгрузкиИТребующиеОбработки();
	
	Возврат СписокМетаданных.Получить(ПолноеИмяМетаданных);
	
КонецФункции

// Возвращает имя объекта метаданных.
// 
// Параметры:
// 	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
// Возвращаемое значение:
// 	Строка - имя объекта метаданных.
Функция ИмяОбъектаМетаданных(ОбъектМетаданных)
	
	Возврат ОбъектМетаданных.Имя;
	
КонецФункции

#КонецОбласти
