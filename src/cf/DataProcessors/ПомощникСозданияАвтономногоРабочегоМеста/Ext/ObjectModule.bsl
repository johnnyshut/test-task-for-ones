﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Создает начальный образ для Автономного рабочего места в соответствии
// с переданными настройками и помещает во временное хранилище.
// 
// Параметры:
//  Настройки - Структура - настройки отборов на узле.
//  ВыбранныеПользователиСинхронизации - Массив из СправочникСсылка.Пользователи
//  АдресВременногоХранилищаНачальногоОбраза - Строка
//  АдресВременногоХранилищаИнформацииОПакетеУстановки - Строка
// 
Процедура СоздатьНачальныйОбразАвтономногоРабочегоМеста(
		Знач Настройки,
		Знач ВыбранныеПользователиСинхронизации,
		Знач АдресВременногоХранилищаНачальногоОбраза,
		Знач АдресВременногоХранилищаИнформацииОПакетеУстановки) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Назначаем права на синхронизацию выбранным пользователям
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			
			ОбщийМодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
			
			Для Каждого Пользователь Из ВыбранныеПользователиСинхронизации Цикл
				
				ОбщийМодульУправлениеДоступомСлужебный.ВключитьПользователяВГруппуДоступа(Пользователь,
					ОбменДаннымиСервер.ПрофильДоступаСинхронизацияДанныхСДругимиПрограммами());
			КонецЦикла;
			
		КонецЕсли;
		
		// Формируем префикс для нового автономного рабочего места
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ПрефиксПоследнегоАвтономногоРабочегоМеста");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ПоследнийПрефикс = Константы.ПрефиксПоследнегоАвтономногоРабочегоМеста.Получить();
		ПрефиксАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.СформироватьПрефиксАвтономногоРабочегоМеста(ПоследнийПрефикс);
		
		Константы.ПрефиксПоследнегоАвтономногоРабочегоМеста.Установить(ПрефиксАвтономногоРабочегоМеста);
		
		// Создаем узел автономного рабочего места
		АвтономноеРабочееМесто = СоздатьНовоеАвтономноеРабочееМесто(Настройки);
		
		ДатаСозданияНачальногоОбраза = ТекущаяДатаСеанса();
		
		// Выгружаем параметры настройки в начальный образ автономного рабочего места
		ВыгрузитьПараметрыВНачальныйОбраз(ПрефиксАвтономногоРабочегоМеста, ДатаСозданияНачальногоОбраза, АвтономноеРабочееМесто);
		
		// Устанавливаем дату создания начального образа, как дату первой успешной синхронизации данных.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", АвтономноеРабочееМесто);
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", АвтономноеРабочееМесто);
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		ОбменДаннымиСервер.ЗавершитьСозданиеНачальногоОбраза(АвтономноеРабочееМесто);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	ЗаписатьНачальныйОбразАвтономногоРабочегоМеста(
		АдресВременногоХранилищаНачальногоОбраза,
		АдресВременногоХранилищаИнформацииОПакетеУстановки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьНачальныйОбразАвтономногоРабочегоМеста(
		АдресВременногоХранилищаНачальногоОбраза,
		АдресВременногоХранилищаИнформацииОПакетеУстановки)
	
	КодУзлаАвтономногоРабочегоМеста = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АвтономноеРабочееМесто, "Код");
		
	КаталогНачальногоОбраза = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов(),
		СтрЗаменить("Replica_{GUID}", "GUID", КодУзлаАвтономногоРабочегоМеста));
	ИдентификаторКаталогаНачальногоОбраза = ОбменДаннымиСервер.ПоместитьФайлВХранилище(КаталогНачальногоОбраза);
	
	ИмяФайлаПакетаУстановки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов(),
		СтрЗаменить("Replica_{GUID}.zip", "GUID", КодУзлаАвтономногоРабочегоМеста));
	ИдентификаторФайлаПакетаУстановки = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ИмяФайлаПакетаУстановки);
	
	ПараметрыЗаписи = СтруктураПараметровЗаписиПакетаУстановки();
	ПараметрыЗаписи.АдресНачальногоОбраза = АдресВременногоХранилищаНачальногоОбраза;
	ПараметрыЗаписи.АдресИнформацииОПакетеУстановки = АдресВременногоХранилищаИнформацииОПакетеУстановки;
	ПараметрыЗаписи.КаталогНачальногоОбраза = КаталогНачальногоОбраза;
	ПараметрыЗаписи.ИдентификаторКаталогаНачальногоОбраза = ИдентификаторКаталогаНачальногоОбраза;
	ПараметрыЗаписи.ИмяФайлаПакетаУстановки = ИмяФайлаПакетаУстановки;
	ПараметрыЗаписи.ИдентификаторФайлаПакетаУстановки = ИдентификаторФайлаПакетаУстановки;
	
	Попытка
		
		ЗаписатьПакетУстановкиВоВременноеХранилище(ПараметрыЗаписи);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		УдаляемыеФайлы = Новый Массив();
		УдаляемыеФайлы.Добавить(
			СтруктураПараметровУдаленияФайла(КаталогНачальногоОбраза, ИдентификаторКаталогаНачальногоОбраза));
		УдаляемыеФайлы.Добавить(
			СтруктураПараметровУдаленияФайла(ИмяФайлаПакетаУстановки, ИдентификаторФайлаПакетаУстановки));
		
		Для Каждого ПараметрыУдаления Из УдаляемыеФайлы Цикл
			
			Попытка
				ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ПараметрыУдаления.Идентификатор);
				УдалитьФайлы(ПараметрыУдаления.ИмяФайла);
			Исключение
				ЗаписьЖурналаРегистрации(
					СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЦикла;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаписатьПакетУстановкиВоВременноеХранилище(ПараметрыЗаписи)
		
	КаталогУстановки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ПараметрыЗаписи.КаталогНачальногоОбраза, "1");
	КаталогАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогУстановки, "InfoBase");
	
	СоздатьКаталог(КаталогАрхива);
	
	// Создаем начальный образ автономного рабочего места.
	СтрокаСоединения = "File = ""&КаталогИнформационнойБазы""";
	СтрокаСоединения = СтрЗаменить(
		СтрокаСоединения, "&КаталогИнформационнойБазы", СокрЛП(ПараметрыЗаписи.КаталогНачальногоОбраза));
	
	ПараметрыВыгрузки = СтруктураПараметровВыгрузкиДанных();
	ПараметрыВыгрузки.КаталогАрхива = КаталогАрхива;
	
	АвтономноеРабочееМестоОбъект = АвтономноеРабочееМесто.ПолучитьОбъект();
	АвтономноеРабочееМестоОбъект.ДополнительныеСвойства.Вставить("РазмещатьФайлыВНачальномОбразе");
	АвтономноеРабочееМестоОбъект.ДополнительныеСвойства.Вставить("СвойстваМетаданных", Новый Соответствие);
	АвтономноеРабочееМестоОбъект.ДополнительныеСвойства.Вставить("ПараметрыВыгрузки", ПараметрыВыгрузки);
	
	// Обновляем повторно используемые значения Механизма регистрации объектов.
	ОбменДаннымиСлужебный.ПроверитьКэшМеханизмаРегистрацииОбъектов();
	
	Попытка
		ПланыОбмена.СоздатьНачальныйОбраз(АвтономноеРабочееМестоОбъект, СтрокаСоединения);
		// Хранить настройки для автономного рабочего места в ИБ небезопасно.
		Константы.НастройкиПодчиненногоУзлаРИБ.Установить("");
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		// Хранить настройки для автономного рабочего места в ИБ небезопасно.
		Константы.НастройкиПодчиненногоУзлаРИБ.Установить("");
		
		ПараметрыВыгрузки.ВыгруженныеДанные = Неопределено;
		ПараметрыВыгрузки.ПотокПриемник = Неопределено;
		
		// Удаляем автономное рабочее место
		АвтономнаяРаботаСлужебный.УдалитьАвтономноеРабочееМесто(Новый Структура("АвтономноеРабочееМесто", АвтономноеРабочееМесто), "");
		
		ВызватьИсключение;
	КонецПопытки;
	
	АвтономнаяРаботаСлужебный.ЗакрытьЗаписьДанныхНачальногоОбраза(АвтономноеРабочееМестоОбъект, Истина);
	
	ИмяФайлаНачальногоОбраза = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		ПараметрыЗаписи.КаталогНачальногоОбраза, "1Cv8.1CD");
	
	ИмяФайлаНачальногоОбразаВКаталогеАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогАрхива, "1Cv8.1CD");
	
	ИмяФайлаИнструкции = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогАрхива, "ReadMe.html");
	
	ТекстИнструкции = АвтономнаяРаботаСлужебный.ТекстИнструкцииИзМакета("ИнструкцияПоНастройкеАРМ");
	
	Текст = Новый ЗаписьТекста(ИмяФайлаИнструкции, КодировкаТекста.UTF8);
	Текст.Записать(ТекстИнструкции);
	Текст.Закрыть();
	
	ПереместитьФайл(ИмяФайлаНачальногоОбраза, ИмяФайлаНачальногоОбразаВКаталогеАрхива);
	
	Архиватор = Новый ЗаписьZipФайла(ПараметрыЗаписи.ИмяФайлаПакетаУстановки, , , , УровеньСжатияZIP.Максимальный);
	Архиватор.Добавить(
		ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогУстановки, "*.*"),
		РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
		РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архиватор.Записать();
	
	Попытка
		ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ПараметрыЗаписи.ИдентификаторКаталогаНачальногоОбраза);
		УдалитьФайлы(ПараметрыЗаписи.КаталогНачальногоОбраза);
	Исключение
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ФайлПакетаУстановки = Новый Файл(ПараметрыЗаписи.ИмяФайлаПакетаУстановки);
	
	ДанныеФайла = Неопределено;
	
	ИнформацияОПакетеУстановки = Новый Структура;
	ИнформацияОПакетеУстановки.Вставить("РазмерФайлаПакетаУстановки", ФайлПакетаУстановки.Размер());
	ИнформацияОПакетеУстановки.Вставить("ИмяФайлаПакетаУстановки", АвтономнаяРаботаСлужебный.ИмяФайлаПакетаУстановки());
	
	Если АвтономнаяРаботаСлужебный.ПоддерживаетсяПередачаБольшихФайлов() Тогда
		
		ДанныеФайла = Новый Структура;
		ДанныеФайла.Вставить("ИдентификаторФайлаПакетаУстановки", ПараметрыЗаписи.ИдентификаторФайлаПакетаУстановки);
		ДанныеФайла.Вставить("ИмяФайлаИлиАдрес", ФайлПакетаУстановки.Имя);
		ДанныеФайла.Вставить("ПутьФайлаWindows", Константы.КаталогСообщенийОбменаДаннымиДляWindows.Получить());
		ДанныеФайла.Вставить("ПутьФайлаLinux",   Константы.КаталогСообщенийОбменаДаннымиДляLinux.Получить());
		
	Иначе
		
		ДанныеФайла = Новый ДвоичныеДанные(ПараметрыЗаписи.ИмяФайлаПакетаУстановки);
		
		Попытка
			ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ПараметрыЗаписи.ИдентификаторФайлаПакетаУстановки);
			УдалитьФайлы(ПараметрыЗаписи.ИмяФайлаПакетаУстановки);
		Исключение
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
			
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ДанныеФайла, ПараметрыЗаписи.АдресНачальногоОбраза);
	ПоместитьВоВременноеХранилище(ИнформацияОПакетеУстановки, ПараметрыЗаписи.АдресИнформацииОПакетеУстановки);
	
КонецПроцедуры

Процедура ВыгрузитьПараметрыВНачальныйОбраз(ПрефиксАвтономногоРабочегоМеста, ДатаСозданияНачальногоОбраза, АвтономноеРабочееМесто)
	
	Константы.НастройкиПодчиненногоУзлаРИБ.Установить(ВыгрузитьПараметрыВСтрокуXML(ПрефиксАвтономногоРабочегоМеста, ДатаСозданияНачальногоОбраза, АвтономноеРабочееМесто));
	
КонецПроцедуры

Функция СоздатьНовоеАвтономноеРабочееМесто(Настройки)
	
	// Обновляем узел приложения в сервисе при необходимости
	Если ПустаяСтрока(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АвтономнаяРаботаСлужебный.ПриложениеВСервисе(), "Код")) Тогда
		
		ПриложениеВСервисеОбъект = СоздатьПриложениеВСервисе();
		ПриложениеВСервисеОбъект.ОбменДанными.Загрузка = Истина;
		ПриложениеВСервисеОбъект.Записать();
		
	КонецЕсли;
	
	// Создаем узел автономного рабочего места
	АвтономноеРабочееМестоОбъект = СоздатьАвтономноеРабочееМесто();
	АвтономноеРабочееМестоОбъект.Наименование = НаименованиеАвтономногоРабочегоМеста;
	АвтономноеРабочееМестоОбъект.РегистрироватьИзменения = Истина;
	АвтономноеРабочееМестоОбъект.ОбменДанными.Загрузка = Истина;
	
	// Устанавливаем значения отборов на узле
	ОбменДаннымиСобытия.УстановитьЗначенияОтборовНаУзле(АвтономноеРабочееМестоОбъект, Настройки);
	
	АвтономноеРабочееМестоОбъект.Записать();
	
	ОбменДаннымиСервер.ЗавершитьНастройкуСинхронизацииДанных(АвтономноеРабочееМестоОбъект.Ссылка);
	
	Возврат АвтономноеРабочееМестоОбъект.Ссылка;
	
КонецФункции

Функция ВыгрузитьПараметрыВСтрокуXML(ПрефиксАвтономногоРабочегоМеста, Знач ДатаСозданияНачальногоОбраза, АвтономноеРабочееМесто)
	
	ПараметрыАвтономногоРабочегоМеста = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвтономноеРабочееМесто, "Код, Наименование");
	ПараметрыПриложенияВСервисе = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвтономнаяРаботаСлужебный.ПриложениеВСервисе(), "Код, Наименование");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Параметры");
	ЗаписьXML.ЗаписатьАтрибут("ВерсияФормата", ВерсияФорматаФайлаНастроекОбменаДанными());
	
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsd", "http://www.w3.org/2001/XMLSchema");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("v8", "http://v8.1c.ru/data");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ПараметрыАвтономногоРабочегоМеста");
	
	ЗаписатьXML(ЗаписьXML, ДатаСозданияНачальногоОбраза,    "ДатаСозданияНачальногоОбраза", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ПрефиксАвтономногоРабочегоМеста, "Префикс", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ЗаголовокСистемы(),              "ЗаголовокСистемы", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, URLВебСервиса,                   "URL", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ПользователиИнформационнойБазы.ТекущийПользователь().Имя, "ИмяВладельца", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, Строка(Пользователи.АвторизованныйПользователь().УникальныйИдентификатор()), "Владелец", НазначениеТипаXML.Явное);
	
	ЗаписатьXML(ЗаписьXML, ПараметрыАвтономногоРабочегоМеста.Код,          "КодАвтономногоРабочегоМеста", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ПараметрыАвтономногоРабочегоМеста.Наименование, "НаименованиеАвтономногоРабочегоМеста", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ПараметрыПриложенияВСервисе.Код,                "КодПриложенияВСервисе", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ПараметрыПриложенияВСервисе.Наименование,       "НаименованиеПриложенияВСервисе", НазначениеТипаXML.Явное);
	ЗаписатьXML(ЗаписьXML, ОбменДаннымиСервер.ПрефиксИнформационнойБазы(), "ПрефиксПриложенияВСервисе", НазначениеТипаXML.Явное);
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЗаписатьXML(ЗаписьXML, МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ОбластьДанных", НазначениеТипаXML.Явное);
	Иначе
		ЗаписатьXML(ЗаписьXML, 0, "ОбластьДанных", НазначениеТипаXML.Явное);
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); // ПараметрыАвтономногоРабочегоМеста
	ЗаписьXML.ЗаписатьКонецЭлемента(); // Параметры
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

Функция ВерсияФорматаФайлаНастроекОбменаДанными()
	
	Возврат "1.0";
	
КонецФункции

Функция СобытиеЖурналаРегистрации()
	
	Возврат АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста();
	
КонецФункции

Функция СоздатьПриложениеВСервисе()
	
	Результат = ПланыОбмена[АвтономнаяРаботаСлужебный.ПланОбменаАвтономнойРаботы()].ЭтотУзел().ПолучитьОбъект();
	Результат.Код = Строка(Новый УникальныйИдентификатор);
	Результат.Наименование = СформироватьНаименованиеПриложенияВСервисе();
	
	Возврат Результат;
КонецФункции

Функция СоздатьАвтономноеРабочееМесто()
	
	ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
	ФоновоеЗадание = ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
	ИдентификаторУзла = ?(ФоновоеЗадание = Неопределено,
		Новый УникальныйИдентификатор,
		ФоновоеЗадание.УникальныйИдентификатор);
	
	Результат = ПланыОбмена[АвтономнаяРаботаСлужебный.ПланОбменаАвтономнойРаботы()].СоздатьУзел();
	Результат.Код = Строка(ИдентификаторУзла);
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьНаименованиеПриложенияВСервисе()
	
	НаименованиеПриложения = ОбменДаннымиВМоделиСервиса.СформироватьНаименованиеПредопределенногоУзла();
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (приложение в Интернете)'"), НаименованиеПриложения);
	
КонецФункции

Функция ЗаголовокСистемы()
	
	Результат = "";
	
	Если Не ОбщегоНазначения.РазделениеВключено()
		Или ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Результат = Константы.ЗаголовокСистемы.Получить();
	КонецЕсли;
	
	Если ПустаяСтрока(Результат) Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			Результат = МодульРаботаВМоделиСервиса.ПолучитьИмяПриложения();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ?(ПустаяСтрока(Результат),
		НСтр("ru = 'Автономное рабочее место'"),
		Результат);
	
КонецФункции

Функция СтруктураПараметровЗаписиПакетаУстановки()
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("АдресНачальногоОбраза", Неопределено);
	ПараметрыЗаписи.Вставить("АдресИнформацииОПакетеУстановки", Неопределено);
	ПараметрыЗаписи.Вставить("КаталогНачальногоОбраза", Неопределено);
	ПараметрыЗаписи.Вставить("ИдентификаторКаталогаНачальногоОбраза", Неопределено);
	ПараметрыЗаписи.Вставить("ИмяФайлаПакетаУстановки", Неопределено);
	ПараметрыЗаписи.Вставить("ИдентификаторФайлаПакетаУстановки", Неопределено);
	
	Возврат ПараметрыЗаписи;
	
КонецФункции

Функция СтруктураПараметровВыгрузкиДанных()
	
	ПараметрыВыгрузки = Новый Структура();
	ПараметрыВыгрузки.Вставить("ИспользоватьОптимизированнуюЗапись",
		АвтономнаяРаботаСлужебный.ИспользоватьОптимизированнуюЗаписьСозданияАвтономногоРабочегоМеста());
	ПараметрыВыгрузки.Вставить("ВыгруженныеДанные", Неопределено);
	ПараметрыВыгрузки.Вставить("ПотокПриемник", Неопределено);
	ПараметрыВыгрузки.Вставить("КаталогАрхива", Неопределено);
	ПараметрыВыгрузки.Вставить("ИмяФайлаДанных", Неопределено);
	ПараметрыВыгрузки.Вставить("НомерФайла", 0);
	ПараметрыВыгрузки.Вставить("ЗаписаноЭлементов", 0);
	ПараметрыВыгрузки.Вставить("ЗаписаноЭлементовПослеПроверкиРазмераФайла", 0);
	ПараметрыВыгрузки.Вставить("МаксимальноеКоличествоЭлементов", 50000);
	ПараметрыВыгрузки.Вставить("КоличествоЭлементовПроверкиРазмераФайла", 1000);
	ПараметрыВыгрузки.Вставить("МаксимальныйРазмерФайла", 1024 * 1024 * 100); // 100 Мб
	
	Возврат ПараметрыВыгрузки;
	
КонецФункции

Функция СтруктураПараметровУдаленияФайла(ИмяФайла, Идентификатор)
	
	Возврат Новый ФиксированнаяСтруктура(
		"ИмяФайла, Идентификатор", ИмяФайла, Идентификатор);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли