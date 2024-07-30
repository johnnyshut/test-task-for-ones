﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Настройки автоматического обновления.

// Сохраняет настройки обновления в хранилище общих настроек.
//
// Параметры:
//  Настройки - см. НастройкиОбновления
//
Процедура ЗаписатьНастройкиОбновления(Знач Настройки) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьНастройкиАвтоматическогоОбновления(Настройки);
	
КонецПроцедуры

// Возвращает расписание регламентного задания "ПолучениеИУстановкаИсправленийКонфигурации".
//
// Возвращаемое значение:
//  Неопределено - регламентное задание не найдено.
//  РасписаниеРегламентногоЗадания
//
Функция РасписаниеЗаданияУстановкиИсправлений() Экспорт
	
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(
		Метаданные.РегламентныеЗадания.ПолучениеИУстановкаИсправленийКонфигурации);
	Если Задание <> Неопределено Тогда
		Возврат Задание.Расписание;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Сохраняет расписание регламентного задания "ПолучениеИУстановкаИсправленийКонфигурации".
//
// Параметры:
//  Расписание - РасписаниеРегламентногоЗадания
//
Процедура УстановитьРасписаниеЗаданияУстановкиИсправлений(Знач Расписание) Экспорт
	
	ПериодПовтораВТечениеДня = Расписание.ПериодПовтораВТечениеДня;
	Если ПериодПовтораВТечениеДня > 0 И ПериодПовтораВТечениеДня < 3600 Тогда
		ВызватьИсключение НСтр("ru = 'Интервал автоматической установки не может быть чаще, чем один раз в час.'");
	КонецЕсли;
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ПолучениеИУстановкаИсправленийКонфигурации,
		Расписание);
	
КонецПроцедуры

// Выполняет установку нового значения в константу "ЗагружатьИУстанавливатьИсправленияАвтоматически".
//
// Параметры:
//  ЗначениеНастройки - Булево
//
Процедура ВключитьОтключитьАвтоматическуюУстановкуИсправлений(Знач ЗначениеНастройки) Экспорт
	
	ПолучениеОбновленийПрограммы.ВключитьОтключитьАвтоматическуюУстановкуИсправлений(
		ЗначениеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнформацияОДоступномОбновлении() Экспорт
	
	ИнформацияОбОбновлении = ПолучениеОбновленийПрограммы.ИнформацияОДоступномОбновлении();
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка"            , Не ПустаяСтрока(ИнформацияОбОбновлении.ИмяОшибки));
	Результат.Вставить("Сообщение"         , ИнформацияОбОбновлении.Сообщение);
	Результат.Вставить("ИнформацияОбОшибке", ИнформацияОбОбновлении.ИнформацияОбОшибке);
	Результат.Вставить("ДоступноОбновление", ИнформацияОбОбновлении.ДоступноОбновление);
	
	Конфигурация = Новый Структура;
	Конфигурация.Вставить("Версия"                    , "");
	Конфигурация.Вставить("МинимальнаяВерсияПлатформы", "");
	Конфигурация.Вставить("РазмерОбновления"          , 0);
	Конфигурация.Вставить("URLНовоеВВерсии"           , "");
	Конфигурация.Вставить("URLПорядокОбновления"      , "");
	Если ИнформацияОбОбновлении.Конфигурация <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Конфигурация, ИнформацияОбОбновлении.Конфигурация);
	КонецЕсли;
	Результат.Вставить("Конфигурация", Конфигурация);
	
	Платформа = Новый Структура;
	Платформа.Вставить("Версия"                 , "");
	Платформа.Вставить("РазмерОбновления"       , 0);
	Платформа.Вставить("URLОсобенностиПерехода" , "");
	Платформа.Вставить("URLСтраницыПлатформы"   , "");
	Платформа.Вставить("ОбязательностьУстановки", 0);
	ЗаполнитьЗначенияСвойств(Платформа, ИнформацияОбОбновлении.Платформа);
	Результат.Вставить("Платформа", Платформа);
	
	ИсправленияДляТекущейВерсии = 0;
	ИсправленияДляНовойВерсии   = 0;
	Если ИнформацияОбОбновлении.Исправления <> Неопределено Тогда
		ИсправленияДляНовойВерсии = ИнформацияОбОбновлении.Исправления.НайтиСтроки(
			Новый Структура(
				"ДляНовойВерсии",
				Истина)).Количество();
		ИсправленияДляТекущейВерсии = ИнформацияОбОбновлении.Исправления.НайтиСтроки(
			Новый Структура(
				"ДляТекущейВерсии",
				Истина)).Количество();
	КонецЕсли;
	
	Результат.Вставить("ИсправленияДляТекущейВерсии", ИсправленияДляТекущейВерсии);
	Результат.Вставить("ИсправленияДляНовойВерсии"  , ИсправленияДляНовойВерсии);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач СообщениеОбОшибке) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
		СообщениеОбОшибке);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки автоматического обновления.

// См. ПолучениеОбновленийПрограммы.НастройкиАвтоматическогоОбновления
//
Функция НастройкиОбновления() Экспорт
	
	Возврат ПолучениеОбновленийПрограммы.НастройкиАвтоматическогоОбновления();
	
КонецФункции

Процедура АвтоматическаяПроверкаОбновленийПриИзменении(Знач НастройкиОбновления) Экспорт
	
	ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
	// Если пользовать имеет право на настройку в панели администрирования,
	// ему должны быть доступны все действия.
	УстановитьПривилегированныйРежим(Истина);
	
	// Очистка пользовательских настроек.
	Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 0 Тогда
		СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
		Для Каждого ТекПользователь Из СписокПользователей Цикл
			ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
				ПолучениеОбновленийПрограммыКлиентСервер.ИдентификаторОбщихНастроек(),
				ПолучениеОбновленийПрограммы.КлючНастройкиИнформацияОДоступномОбновлении(),
				ТекПользователь.Имя);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка версии платформы 1С:Предприятие при начале работы программы.

Функция ПараметрыПроверкиВерсииПлатформыПриЗапуске() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Продолжить"             , Ложь);
	Результат.Вставить("ЭтоАдминистраторСистемы", Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь));
	
	ПараметрыБазовойФункциональности = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности();
	
	ТекущаяВерсияПлатформы       = ИнтернетПоддержкаПользователей.ТекущаяВерсияПлатформы1СПредприятие();
	МинимальнаяВерсияПлатформы   = ПараметрыБазовойФункциональности.МинимальнаяВерсияПлатформы;
	РекомендуемаяВерсияПлатформы = ПараметрыБазовойФункциональности.РекомендуемаяВерсияПлатформы;
	
	РаботаВПрограммеЗапрещена = (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(
		ТекущаяВерсияПлатформы,
		МинимальнаяВерсияПлатформы) < 0);
	
	// Определение необходимости отображения сообщения.
	Если Не РаботаВПрограммеЗапрещена Тогда
		
		Если Не Результат.ЭтоАдминистраторСистемы Тогда
			
			// Если работа в программе разрешена, тогда не показывать
			// сообщение обычному пользователю.
			Результат.Продолжить = Истина;
			Возврат Результат;
			
		Иначе
			
			// Проверить необходимость показа оповещения администратору.
			НастройкиОповещения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
				ПолучениеОбновленийПрограммы.КлючНастройкиСообщениеОНерекомендуемойВерсииПлатформы());
			
			Если ТипЗнч(НастройкиОповещения) = Тип("Структура") Тогда
				
				СвойстваПроверки = Новый Структура("МетаданныеИмя,МетаданныеВерсия,РекомендуемаяВерсияПлатформы");
				ЗаполнитьЗначенияСвойств(СвойстваПроверки, НастройкиОповещения);
				
				Если ИнтернетПоддержкаПользователей.ИмяКонфигурации() = СвойстваПроверки.МетаданныеИмя
					И ИнтернетПоддержкаПользователей.ВерсияКонфигурации() = СвойстваПроверки.МетаданныеВерсия
					И РекомендуемаяВерсияПлатформы = СвойстваПроверки.РекомендуемаяВерсияПлатформы Тогда
					
					// Если сообщение уже отображалось для текущего набора
					// свойств метаданных, тогда пропустить отображение сообщения.
					Результат.Продолжить = Истина;
					Возврат Результат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Определение параметров отображения оповещения.
	Результат.Вставить("РаботаВПрограммеЗапрещена",
		ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена);
	
	ТекстСообщения = "<body>" + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для работы с программой %1 использовать версию платформы &quot;1С:Предприятие 8&quot; не ниже: <b>%2</b>
			|<br />Используемая сейчас версия: %3'"),
		?(ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена,
			НСтр("ru = 'необходимо'"),
			НСтр("ru = 'рекомендуется'")),
		?(РаботаВПрограммеЗапрещена, МинимальнаяВерсияПлатформы, РекомендуемаяВерсияПлатформы),
		ТекущаяВерсияПлатформы);
	
	Если Не Результат.ЭтоАдминистраторСистемы Тогда
		
		// В этой ветви работа в программе запрещена.
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в приложение невозможен.<br />
				|Необходимо обратиться к администратору для обновления версии платформы 1С:Предприятие.'");
		
	ИначеЕсли ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена Тогда
		
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в приложение невозможен.<br />
				|Необходимо предварительно обновить версию платформы 1С:Предприятие.'");
		
	Иначе
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<br /><br />"
			+ НСтр("ru='Рекомендуется обновить версию платформы 1С:Предприятия. Новая версия платформы содержит исправления ошибок,
				|которые позволят программе работать более стабильно.
				|<br />
				|<br />
				|Вы также можете продолжить работу на текущей версии платформы %1
				|<br />
				|<br />
				|<i>Версия платформы, необходимая для работы в программе: %2, рекомендуемая: %3 или выше, текущая: %4.</i>'"),
			ТекущаяВерсияПлатформы,
			МинимальнаяВерсияПлатформы,
			РекомендуемаяВерсияПлатформы,
			ТекущаяВерсияПлатформы);
		
	КонецЕсли;
	
	ТекстСообщения = ТекстСообщения + "</body>";
	Результат.Вставить("ТекстСообщения",
		ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(ТекстСообщения));
	
	Возврат Результат;
	
КонецФункции

// Сохраняет информацию об отключении сообщения о использовании нерекомендуемой версии платформы.
// В сохраняемые параметры входит имя и текущая версия конфигурации, а также рекомендуемая версия платформы, полученная
// из сервиса. Если хотя бы один сохраненный параметр будет изменен, то сообщение о использовании не рекомендуемой
// версии платформы снова будет отображаться.
//
Процедура СохранитьНастройкиОповещенияОНерекомендуемойВерсииПлатформы() Экспорт
	
	ПараметрыБазовойФункциональности = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности();
	РекомендуемаяВерсияПлатформы     = ПараметрыБазовойФункциональности.РекомендуемаяВерсияПлатформы;
	
	ДанныеСохранения = Новый Структура();
	ДанныеСохранения.Вставить("МетаданныеИмя"               , ИнтернетПоддержкаПользователей.ИмяКонфигурации());
	ДанныеСохранения.Вставить("МетаданныеВерсия"            , ИнтернетПоддержкаПользователей.ВерсияКонфигурации());
	ДанныеСохранения.Вставить("РекомендуемаяВерсияПлатформы", РекомендуемаяВерсияПлатформы);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
		ПолучениеОбновленийПрограммы.КлючНастройкиСообщениеОНерекомендуемойВерсииПлатформы(),
		ДанныеСохранения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка наличия обновлений в фоновом режиме.

// Выполняет сохранение переданной настройки и запускает длительную операцию по проверке наличия обновлений.
// Если длительная операция проверки наличия будет выполнена синхронно, то в возвращаемом значении будут сформированы
// параметры оповещения.
//
// Параметры:
//  НастройкиОбновления - Неопределено - если настройки обновления сохранять не требуется.
//                      - Структура - сохраняет переданные настройки в хранилище общих настроек.
//    Формат: см. ПолучениеОбновленийПрограммыКлиент.ГлобальныеНастройкиОбновления.
//
// Возвращаемое значение:
//  Структура:
//    * ОписаниеЗадания - см. ПолучениеОбновленийПрограммы.НачатьПроверкуНаличияОбновления
//    * ПараметрыОповещения - см. ПолучениеОбновленийПрограммы.ОпределитьПараметрыОповещенияОДоступномОбновлении
//
Функция СохранитьНастройкиОбновленияИНачатьПроверкуНаличияОбновления(Знач НастройкиОбновления = Неопределено) Экспорт
	Перем ПараметрыОповещения;
	
	Если НастройкиОбновления <> Неопределено Тогда
		ПолучениеОбновленийПрограммы.ЗаписатьНастройкиАвтоматическогоОбновления(НастройкиОбновления);
	КонецЕсли;
	
	ОписаниеЗадания = ПолучениеОбновленийПрограммы.НачатьПроверкуНаличияОбновления();
	Если ОписаниеЗадания.Статус = "Выполнено" Тогда
		ПараметрыОповещения = ПолучениеОбновленийПрограммы.ОпределитьПараметрыОповещенияОДоступномОбновлении(
			ОписаниеЗадания.АдресРезультата);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеЗадания"    , ОписаниеЗадания);
	Результат.Вставить("ПараметрыОповещения", ПараметрыОповещения);
	
	Возврат Результат;
	
КонецФункции

Функция ОпределитьПараметрыОповещенияОДоступномОбновлении(Знач АдресРезультата) Экспорт
	
	Возврат ПолучениеОбновленийПрограммы.ОпределитьПараметрыОповещенияОДоступномОбновлении(АдресРезультата);
	
КонецФункции

#КонецОбласти
