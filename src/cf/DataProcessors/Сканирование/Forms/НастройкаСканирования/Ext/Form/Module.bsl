﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПодключаемыйМодуль;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	НастройкиСканированияПользователя = РаботаСФайлами.ПолучитьНастройкиСканированияПользователя(ИдентификаторКлиента);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиСканированияПользователя);
	Если ИмяУстройства <> "" Тогда
		Элементы.ИмяУстройства.СписокВыбора.Добавить(ИмяУстройства);
	КонецЕсли;
	Элементы.КаталогЖурналаСканирования.Доступность = ИспользоватьКаталогЖурналаСканирования;
			
	СпособПреобразованияВPDF = ?(ИспользоватьImageMagickДляПреобразованияВPDF, 1, 0);
		
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ФорматМногостраничныйTIF = Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF;
	
	Элементы.ГруппаКачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
	Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	
	Элементы.ПутьКПрограммеКонвертации.Доступность = ИспользоватьImageMagickДляПреобразованияВPDF;
	
	УстановитьПодсказки();
	
	ПовторноеСканирование = Параметры.ПовторноеСканирование;
	
	Если Параметры.ПовторноеСканирование Тогда
		Элементы.ОК.Заголовок = НСтр("ru='Сканировать'");
	КонецЕсли;
	
	ПараметрыЗаданияСканирования = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("КомпонентаСканирования", "ПараметрыЗаданияСканирования", Неопределено);
	
	Элементы.ОшибкаСканирования.Видимость = ПараметрыЗаданияСканирования <> Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда
		АдаптироватьДляLinux();
		ПоказыватьДиалогСканера = Ложь;
	КонецЕсли;
	ОбновитьСостояние();
	ОбработатьИспользованиеДиалогаСканирования();
	Элементы.ОшибкаСканирования.Видимость = Элементы.ОшибкаСканирования.Видимость И Не ОткрытаФормаСканирования();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ПоказыватьДиалогСканера Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Разрешение"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Цветность"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененыНастройкиСканирования" Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметр);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяУстройстваПриИзменении(Элемент)
	ПрочитатьНастройкиСканера();
КонецПроцедуры

&НаКлиенте
Процедура ИмяУстройстваОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ИмяУстройства = ВыбранноеЗначение Тогда // Ничего не изменилось - ничего не делаем.
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ФорматСканированногоИзображенияПриИзменении(Элемент)
	
	Элементы.ГруппаКачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
	Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	УстановитьПодсказки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеКонвертацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
		
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = ПутьКПрограммеКонвертации;
	Фильтр = НСтр("ru = 'Исполняемые файлы(*.exe)|*.exe'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл для преобразования в PDF'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПутьКПрограммеКонвертации = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПреобразованияВPDFПриИзменении(Элемент)
	
	ИспользоватьImageMagickДляПреобразованияВPDF = СпособПреобразованияВPDF = 1;
	ОтработатьИзмененияИспользоватьImageMagick();
	
КонецПроцедуры

&НаКлиенте
Процедура КачествоJPGПриИзменении(Элемент)
	Элементы.КачествоJPG.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Качество (%1)'"), КачествоJPG);
КонецПроцедуры

&НаКлиенте
Процедура ИмяУстройстваНачалоВыбора(Элемент, СтандартнаяОбработка)
	Попытка
		МассивУстройств = РаботаСФайламиСлужебныйКлиент.ПолучитьУстройства(ЭтотОбъект, ПодключаемыйМодуль);
	Исключение
		МассивУстройств = Новый Массив;
	КонецПопытки;  
	
	Если МассивУстройств.Количество() > 0 Тогда
		Элемент.СписокВыбора.ЗагрузитьЗначения(МассивУстройств);
	Иначе
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,НСтр("ru = 'Не обнаружено подключенных сканеров. Проверьте подключение сканера.'"));
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ПоказыватьДиалогСканераПриИзменении(Элемент)
	
	ОбработатьИспользованиеДиалогаСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиСканированияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ТехническаяИнформация" Тогда
		ПослеПолученияТехническойИнформации = Новый ОписаниеОповещения("ПослеПолученияТехническойИнформации", ЭтотОбъект);
		РаботаСФайламиСлужебныйКлиент.ПолучитьТехническуюИнформацию(НСтр("ru='Последняя попытка сканирования завершилась неудачно.'"), 
			ПослеПолученияТехническойИнформации);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогЖурналаСканированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Если НЕ РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.ПолноеИмяФайла = КаталогЖурналаСканирования;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь для сохранения журнала сканирования'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		КаталогЖурналаСканирования = ДиалогОткрытияФайла.Каталог;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКаталогЖурналаСканированияПриИзменении(Элемент)
	Элементы.КаталогЖурналаСканирования.Доступность = ИспользоватьКаталогЖурналаСканирования;
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияДляТехническойПоддержкиНажатие(Элемент)
	ПослеПолученияТехническойИнформации = Новый ОписаниеОповещения("ПослеПолученияТехническойИнформации", ЭтотОбъект);
		РаботаСФайламиСлужебныйКлиент.ПолучитьТехническуюИнформацию(НСтр("ru='Отправка технической информации из формы настроек.'"), 
			ПослеПолученияТехническойИнформации);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
		
	НастройкиСканированияПользователя = РаботаСФайламиКлиентСервер.НастройкиСканированияПользователя();
	ЗаполнитьЗначенияСвойств(НастройкиСканированияПользователя, ЭтотОбъект);
	
	Если ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда
		НастройкиСканированияПользователя.ПутьКПрограммеКонвертации = "convert";
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("НастройкиСканированияПользователя", НастройкиСканированияПользователя);
	Контекст.Вставить("ОшибкаПроверкиЗаполнения", Ложь);
	
	Если НастройкиСканированияПользователя.ИспользоватьКаталогЖурналаСканирования Тогда
		Если НастройкиСканированияПользователя.КаталогЖурналаСканирования = "" Тогда
			ТекстОшибки = НСтр("ru='Не заполнен путь к журналу сканирования.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "КаталогЖурналаСканирования");
			Контекст.ОшибкаПроверкиЗаполнения = Истина;
			Результат = Новый Структура("Успешно", Истина);
			ПослеПроверкиДоступностиКаталогаСканирования(Результат, Контекст)
		Иначе
			Оповещение = Новый ОписаниеОповещения("ПослеПроверкиДоступностиКаталогаСканирования", ЭтотОбъект, Контекст);
			РаботаСФайламиСлужебныйКлиент.ПроверитьДоступностьКаталога(Оповещение, НастройкиСканированияПользователя.КаталогЖурналаСканирования);
		КонецЕсли;
	Иначе
		Результат = Новый Структура("Успешно", Истина);
		ПослеПроверкиДоступностиКаталогаСканирования(Результат, Контекст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	ПрочитатьНастройкиСканера();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНомераОтсканированныхФайлов(Команда)
	ОткрытьФорму("РегистрСведений.НомераОтсканированныхФайлов.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСостояние()
	
	Элементы.КачествоJPG.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Качество (%1)'"), КачествоJPG);
	Элементы.ФорматСканированногоИзображения.Доступность = Ложь;
	Элементы.Разрешение.Доступность = Ложь;
	Элементы.Цветность.Доступность = Ложь;
	Элементы.Поворот.Доступность = Ложь;
	Элементы.РазмерБумаги.Доступность = Ложь;
	Элементы.ДвустороннееСканирование.Доступность = Ложь;
	Элементы.УстановитьСтандартныеНастройки.Доступность = Ложь;
	Элементы.ПреобразоватьВPDF.Доступность = Ложь;
	Элементы.КачествоJPG.Доступность = Ложь;
	Элементы.СжатиеTIFF.Доступность = Ложь;
	Элементы.ФорматХраненияМногостраничный.Доступность = Ложь;
	Элементы.СпособПреобразованияВPDF.Доступность = Ложь;
	Элементы.ПоказыватьДиалогСканера.Доступность = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьСостояниеПослеИнициализации", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту(ОписаниеОповещения, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеПослеИнициализации(РезультатПроверкиИнициализации, Контекст) Экспорт
	ПодключаемыйМодуль = РезультатПроверкиИнициализации.Подключено;
	
	Если Не ПодключаемыйМодуль Тогда
		Элементы.ИмяУстройства.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	ПодключаемыйМодуль = РезультатПроверкиИнициализации.ПодключаемыйМодуль;
		
	Если Не РаботаСФайламиСлужебныйКлиент.ГотовностьКСканированию(ЭтотОбъект, ПодключаемыйМодуль) Тогда
		Элементы.ИмяУстройства.ПодсказкаВвода = НСтр("ru='Проверьте подключение сканера'");
		Возврат;
	Иначе
		Элементы.ИмяУстройства.ПодсказкаВвода = "";
	КонецЕсли;
		
	Если ПустаяСтрока(ИмяУстройства) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФорматСканированногоИзображения.Доступность = Истина;
	Элементы.Разрешение.Доступность = Истина;
	Элементы.Цветность.Доступность = Истина;
	Элементы.УстановитьСтандартныеНастройки.Доступность = Истина;
	Элементы.ПреобразоватьВPDF.Доступность = Истина;
	Элементы.КачествоJPG.Доступность = Истина;
	Элементы.СжатиеTIFF.Доступность = Истина;
	Элементы.ФорматХраненияМногостраничный.Доступность = Истина;
	Элементы.СпособПреобразованияВPDF.Доступность = Истина;
	Элементы.ПоказыватьДиалогСканера.Доступность = Истина;
	
	ДвустороннееСканированиеЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль, 
		ИмяУстройства, "DUPLEX");
	РазрешениеЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль, 
		ИмяУстройства, "XRESOLUTION");
	ПоворотЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль, 
		ИмяУстройства, "ROTATION");
	РазмерБумагиЧисло  = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль, 
		ИмяУстройства, "SUPPORTEDSIZES");
	
	Элементы.ДвустороннееСканирование.Доступность = (ДвустороннееСканированиеЧисло <> -1);
	Элементы.Поворот.Доступность = (ПоворотЧисло <> -1);
	Элементы.РазмерБумаги.Доступность = (РазмерБумагиЧисло <> -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНастройкиСканера()
	Модифицированность = Истина;
	Элементы.ДвустороннееСканирование.Доступность = Ложь;
	
	Если ПустаяСтрока(ИмяУстройства) Тогда
		Элементы.Поворот.Доступность = Ложь;
		Элементы.РазмерБумаги.Доступность = Ложь;
		Возврат;
	Иначе
		Элементы.ФорматСканированногоИзображения.Доступность = Истина;
		Элементы.Разрешение.Доступность = Истина;
		Элементы.Цветность.Доступность = Истина;
		Элементы.УстановитьСтандартныеНастройки.Доступность = Истина;
		Элементы.ПреобразоватьВPDF.Доступность = Истина;
		Элементы.КачествоJPG.Доступность = Истина;
		Элементы.СжатиеTIFF.Доступность = Истина;
		Элементы.ФорматХраненияМногостраничный.Доступность = Истина;
		Элементы.СпособПреобразованияВPDF.Доступность = Истина;
		Элементы.ПоказыватьДиалогСканера.Доступность = Истина;
	КонецЕсли;
	
	РазрешениеЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль,
		ИмяУстройства, "XRESOLUTION");
	ЦветностьЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль,
		ИмяУстройства, "PIXELTYPE");
	ПоворотЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль,
		ИмяУстройства, "ROTATION");
	РазмерБумагиЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль,
		ИмяУстройства, "SUPPORTEDSIZES");
	ДвустороннееСканированиеЧисло = РаботаСФайламиСлужебныйКлиент.НастройкаСканера(ЭтотОбъект, ПодключаемыйМодуль,
		ИмяУстройства, "DUPLEX");
	
	Элементы.Поворот.Доступность = (ПоворотЧисло <> -1);
	Элементы.РазмерБумаги.Доступность = (РазмерБумагиЧисло <> -1);
	
	Элементы.ДвустороннееСканирование.Доступность = (ДвустороннееСканированиеЧисло <> -1);
	ОбновитьЗначение(ДвустороннееСканирование, ?((ДвустороннееСканированиеЧисло = 1), Истина, Ложь), Модифицированность);
	
	ПреобразоватьПараметрыСканераВПеречисления(
		РазрешениеЧисло, ЦветностьЧисло, ПоворотЧисло, РазмерБумагиЧисло);
		
	ОбработатьИспользованиеДиалогаСканирования();
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьПараметрыСканераВПеречисления(РазрешениеЧисло, ЦветностьЧисло, ПоворотЧисло, РазмерБумагиЧисло) 
	
	Результат = РаботаСФайламиСлужебный.ПараметрыСканераВПеречисления(РазрешениеЧисло, ЦветностьЧисло, 
		ПоворотЧисло, РазмерБумагиЧисло);
	ОбновитьЗначение(Разрешение, Результат.Разрешение, Модифицированность);
	ОбновитьЗначение(Цветность, Результат.Цветность, Модифицированность);
	ОбновитьЗначение(Поворот, Результат.Поворот, Модифицированность);
	ОбновитьЗначение(РазмерБумаги, Результат.РазмерБумаги, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтработатьИзмененияИспользоватьImageMagick()
	
	Элементы.ПутьКПрограммеКонвертации.Доступность = ИспользоватьImageMagickДляПреобразованияВPDF;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказки()
	
	ПодсказкаФормата = "";
	РасширеннаяПодсказка = Строка(Элементы.ПреобразоватьВPDF.РасширеннаяПодсказка.Заголовок); 
	Подсказки = СтрРазделить(РасширеннаяПодсказка, Символы.ПС);
	ТекущийФормат = Строка(ФорматСканированногоИзображения);
	Для Каждого Подсказка Из Подсказки Цикл
		Если СтрНачинаетсяС(Подсказка, ТекущийФормат) Тогда
			 ПодсказкаФормата = Подсказка;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ОписаниеФорматаОдностраничногоДокумента.Заголовок = ПодсказкаФормата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(НастройкиСканированияПользователя)
	РаботаСФайламиКлиент.СохранитьНастройкиСканированияПользователя(НастройкиСканированияПользователя);
	Результат = Новый Структура("ПовторноеСканирование", ПовторноеСканирование);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиУстановленнойПрограммыКонвертации(РезультатЗапуска, ВнешнийКонтекст) Экспорт
	Если СтрНайти(РезультатЗапуска.ПотокВывода, "ImageMagick") = 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибочно указан путь к приложению %1.'"), "ImageMagick"); 
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ПутьКПрограммеКонвертации");
	ИначеЕсли Не ВнешнийКонтекст.ОшибкаПроверкиЗаполнения Тогда
		ОКЗавершение(ВнешнийКонтекст.НастройкиСканированияПользователя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИспользованиеДиалогаСканирования()
	
	Элементы.ГруппаПараметрыСканирования.Доступность = Не ПоказыватьДиалогСканера;
	Элементы.ФорматСканированногоИзображения.Доступность = Не ПоказыватьДиалогСканера;
	Элементы.КачествоJPG.Доступность = Не ПоказыватьДиалогСканера;
	Элементы.СжатиеTIFF.Доступность = Не ПоказыватьДиалогСканера;
	Элементы.Разрешение.ОтметкаНезаполненного = Не ПоказыватьДиалогСканера;
	Элементы.Цветность.ОтметкаНезаполненного = Не ПоказыватьДиалогСканера;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначение(Приемник, Источник, Модифицированность)
	Модифицированность = Модифицированность Или Приемник <> Источник;
	Приемник = ?(ЗначениеЗаполнено(Источник), Источник, Приемник);
КонецПроцедуры

&НаКлиенте
Функция ОткрытаФормаСканирования()
	Для Каждого ОкноКлиентскогоПриложения Из ПолучитьОкна() Цикл
		Для Каждого СодержимоеОкна Из ОкноКлиентскогоПриложения.Содержимое Цикл
			Если СодержимоеОкна.ИмяФормы = "Обработка.Сканирование.Форма.РезультатСканирования" Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПослеПолученияТехническойИнформации(Результат, Контекст) Экспорт
	Элементы.ОшибкаСканирования.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура АдаптироватьДляLinux()
	Элементы.ПоказыватьДиалогСканера.Видимость = Ложь;
	Элементы.Поворот.Видимость = Ложь;
	ДоступныеФорматы = Новый Массив;
	ДоступныеФорматы.Добавить(Перечисления.ФорматыСканированногоИзображения.PNG);
	ДоступныеФорматы.Добавить(Перечисления.ФорматыСканированногоИзображения.JPG);
	Элементы.ФорматСканированногоИзображения.СписокВыбора.ЗагрузитьЗначения(ДоступныеФорматы);
	Элементы.ФорматСканированногоИзображения.РежимВыбораИзСписка = Истина;
	Если ДоступныеФорматы.Найти(ФорматСканированногоИзображения) = Неопределено Тогда
		ФорматСканированногоИзображения = Перечисления.ФорматыСканированногоИзображения.PNG;
		Модифицированность = Истина;
	КонецЕсли;
	Элементы.ПутьКПрограммеКонвертации.Видимость = Ложь; 
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиДоступностиКаталогаСканирования(Результат, ВнешнийКонтекст) Экспорт
	
	НастройкиСканированияПользователя = ВнешнийКонтекст.НастройкиСканированияПользователя;
	ОшибкаПроверкиЗаполнения = ВнешнийКонтекст.ОшибкаПроверкиЗаполнения;
	
	Если Не Результат.Успешно Тогда
		ТекстОшибки = НСтр("ru='Каталог журнала сканирования недоступен для записи. Выберите другой каталог.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "КаталогЖурналаСканирования");
		ОшибкаПроверкиЗаполнения = Истина;
	КонецЕсли;
	
	Если НастройкиСканированияПользователя.ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если Не ЗначениеЗаполнено(НастройкиСканированияПользователя.ПутьКПрограммеКонвертации) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнен путь к программе %1.'"), 
			"ImageMagick");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "ПутьКПрограммеКонвертации");
			ОшибкаПроверкиЗаполнения = Истина;
		Иначе
			Контекст = Новый Структура;
			Контекст.Вставить("Контекст", НастройкиСканированияПользователя);
			Контекст.Вставить("ОшибкаПроверкиЗаполнения", ОшибкаПроверкиЗаполнения);
			Контекст.Вставить("НастройкиСканированияПользователя", НастройкиСканированияПользователя);
			ОбработчикРезультатаПроверки = Новый ОписаниеОповещения("ПослеПроверкиУстановленнойПрограммыКонвертации", ЭтотОбъект, 
				Контекст);
			РаботаСФайламиКлиент.НачатьПроверкуНаличияПрограммыКонвертации(НастройкиСканированияПользователя.ПутьКПрограммеКонвертации, 
				ОбработчикРезультатаПроверки);
		КонецЕсли;
	ИначеЕсли Не ОшибкаПроверкиЗаполнения Тогда
		ОКЗавершение(НастройкиСканированияПользователя); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
