﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	РежимОбновления = РежимОбновленияИзСервиса();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
		Элементы.ДекорацияОписаниеРезультата.Заголовок =
			НСтр("ru = 'Недостаточно прав доступа для обновления внешних компонент.'");
		Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
		Элементы.КнопкаНазад.Видимость                 = Ложь;
		Элементы.КнопкаДалее.Видимость                 = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
		Элементы.ДекорацияОписаниеРезультата.Заголовок =
			НСтр("ru = 'Использование обработки недоступно при работе в модели сервиса.'");
		Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
		Элементы.КнопкаНазад.Видимость                 = Ложь;
		Элементы.КнопкаДалее.Видимость                 = Ложь;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФормуПоПараметрам();
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		
		Если РежимОбновления = РежимОбновленияИзФайла() Тогда
			
			РежимОбновления = РежимОбновленияИзСервиса();
			Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
			Элементы.ДекорацияОписаниеРезультата.Заголовок =
				НСтр("ru = 'Загрузка из файла недоступна при работе в веб-клиенте.'");
			Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
			Элементы.КнопкаНазад.Видимость                 = Ложь;
			Элементы.КнопкаДалее.Видимость                 = Ложь;
			Возврат;
		КонецЕсли;
		
		ИнформацияОДоступныхОбновленияхИзСервиса();
		
	ИначеЕсли РежимОбновления = РежимОбновленияИзСервиса() Тогда
		
		Если ИдентификаторыВнешнихКомпонент.Количество() > 0 Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
			Возврат;
		КонецЕсли;
		
		РазрешенВыборРежимаОбновления = Истина;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		
	ИначеЕсли ЗначениеЗаполнено(АдресФайлаОбновления) Тогда
		ИнформацияОДоступныхОбновленияхИзФайлаНаСервере();
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
		Элементы.ИндикаторОбновления.Видимость  = Ложь;
		Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Обработка файла внешних компонент.'");
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если РежимОбновления = РежимОбновленияИзФайла()
			И Не ПустаяСтрока(ФайлОбновления) Тогда
		ПодключитьОбработчикОжидания("ИнформацияОДоступныхОбновленияхИзФайла", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОбновленияПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Архив'") + "(*.zip)|*.zip";
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ФайлОбновленияНачалоВыбораЗавершение",
		ЭтотОбъект);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(
		ОписаниеОповещения,
		ДиалогВыбораФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеРезультатаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openLog" Тогда
		
		СтандартнаяОбработка = Ложь;
		Отбор = Новый Структура;
		Отбор.Вставить("Уровень", "Ошибка");
		Отбор.Вставить("СобытиеЖурналаРегистрации", ПолучениеВнешнихКомпонентКлиент.ИмяСобытияЖурналаРегистрации());
		ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				,
				ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	ИнтернетПоддержкаПользователейКлиент.ПриИзмененииСекретныхДанных(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтернетПоддержкаПользователейКлиент.ОтобразитьСекретныеДанные(
		ЭтотОбъект,
		Элемент,
		"Пароль");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеВнешнихКомпонент

&НаКлиенте
Процедура ДанныеВнешнихКомпонентПередНачаломДобавления(
		Элемент,
		Отказ,
		Копирование,
		Родитель,
		Группа,
		Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВнешнихКомпонентПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		
		Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьДанныеАутентификации(
			Новый Структура("Логин, Пароль",
			Логин, Пароль));
		
		Если Результат.Отказ Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Результат.СообщениеОбОшибке,
				,
				Результат.Поле);
		КонецЕсли;
		
		Если Результат.Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьПодключениеКПорталу1СИТС();
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Если РежимОбновления = РежимОбновленияИзСервиса() Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
		Иначе
			ИнформацияОДоступныхОбновленияхИзФайла();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборВнешнихКомпонент Тогда
		Если РежимОбновления = РежимОбновленияИзСервиса() Тогда
			НачатьОбновлениеВнешнихКомпонентСервис();
		Иначе
			Если ПустаяСтрока(ФайлОбновления) Тогда
				НачатьОбновлениеВнешнихКомпонентИзФайлаПослеЗагрузки(
					АдресФайлаОбновления,
					Неопределено);
			Иначе
				НачатьОбновлениеВнешнихКомпонентИзФайла();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если РазрешенВыборРежимаОбновления Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Логин  = "";
		Пароль = "";
	Иначе
		Если РежимОбновления = РежимОбновленияИзСервиса() Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
		Иначе
			ИнформацияОДоступныхОбновленияхИзФайла();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоПараметрам()
	
	Если ТипЗнч(Параметры.Идентификаторы) = Тип("Массив") Тогда
		
		Для Каждого Идентификатор Из Параметры.Идентификаторы Цикл
			ИдентификаторыВнешнихКомпонент.Добавить(Идентификатор);
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ФайлОбновления) Тогда
		
		РежимОбновления = РежимОбновленияИзФайла();
		Если ЭтоАдресВременногоХранилища(Параметры.ФайлОбновления) Тогда
			Элементы.ФайлОбновления.Видимость = Ложь;
			АдресФайлаОбновления = Параметры.ФайлОбновления;
		Иначе
			ФайлОбновления = Параметры.ФайлОбновления;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() <> 0 Тогда
		ФайлОбновления = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеКПорталу1СИТС()
	
	ДанныеВнешнихКомпонент.Очистить();
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях(
		ИдентификаторыВнешнихКомпонент);
	
	Если ПараметрыПолучения.ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Отсутствуют внешние компоненты доступные для обновления.'"));
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	// Получение информации из сервиса внешних компонент.
	РезультатОперации = ПолучениеВнешнихКомпонент.СлужебнаяДоступныеОбновленияВнешнихКомпонент(
		ПараметрыПолучения.ВерсииВнешнихКомпонент,
		Новый Структура("Логин, Пароль",
			Логин, Пароль));
	
	Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ОбщегоНазначения.СообщитьПользователю(
			РезультатОперации.СообщениеОбОшибке,
			,
			"Логин");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииВнешнихКомпонент);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзСервиса()
	
	Если Не ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		СохранитьДанныеАутентификации = Истина;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ДанныеВнешнихКомпонент.Очистить();
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях(ИдентификаторыВнешнихКомпонент);
	
	Если ПараметрыПолучения.ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Отсутствуют внешние компоненты доступные для обновления.'"));
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	// Получение информации из сервиса внешних компонент.
	РезультатОперации = ПолучениеВнешнихКомпонент.СлужебнаяДоступныеОбновленияВнешнихКомпонент(
		ПараметрыПолучения.ВерсииВнешнихКомпонент);
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииВнешнихКомпонент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации, ВерсииВнешнихКомпонент)
	
	// Обработка ошибок операции.
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			СохранитьДанныеАутентификации = Истина;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Иначе
			// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
			Если СохранитьДанныеАутентификации Тогда
				Логин  = "";
				Пароль = "";
				СохранитьДанныеАутентификации = Ложь;
			КонецЕсли;
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				РезультатОперации.СообщениеОбОшибке,
				Истина);
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
	Если СохранитьДанныеАутентификации Тогда
		
		// Запись данных.
		УстановитьПривилегированныйРежим(Истина);
		ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(
			Новый Структура(
				"Логин, Пароль",
				Логин,
				Пароль));
		УстановитьПривилегированныйРежим(Ложь);
		
		Логин  = "";
		Пароль = "";
		СохранитьДанныеАутентификации = Ложь;
		
	КонецЕсли;
	
	// Заполнение таблицы с обновлениями.
	Для Каждого ОписаниеВнешнейКомпоненты Из ВерсииВнешнихКомпонент Цикл
		
		Для Каждого ОписаниеВерсии Из РезультатОперации.ДоступныеВерсии Цикл
			Если ОписаниеВерсии.Идентификатор = ОписаниеВнешнейКомпоненты.Идентификатор Тогда
				
				СтрокаВнешнейКомпоненты = ДанныеВнешнихКомпонент.Добавить();
				ЗаполнитьЗначенияСвойств(
					СтрокаВнешнейКомпоненты,
					ОписаниеВнешнейКомпоненты,
					"Идентификатор");
				
				СтрокаВнешнейКомпоненты.КонтрольнаяСумма   = ОписаниеВерсии.ИдентификаторФайла.КонтрольнаяСумма;
				СтрокаВнешнейКомпоненты.ИдентификаторФайла = ОписаниеВерсии.ИдентификаторФайла.ИдентификаторФайла;
				СтрокаВнешнейКомпоненты.Наименование       = ОписаниеВерсии.Наименование;
				СтрокаВнешнейКомпоненты.Версия             = ОписаниеВерсии.Версия;
				СтрокаВнешнейКомпоненты.ДатаВерсии         = ОписаниеВерсии.ДатаВерсии;
				СтрокаВнешнейКомпоненты.ОписаниеВерсии     = ОписаниеВерсии.ОписаниеВерсии;
				СтрокаВнешнейКомпоненты.Размер             = ОписаниеВерсии.Размер;
				СтрокаВнешнейКомпоненты.Используется       = Истина;
				
				Если ОписаниеВнешнейКомпоненты.ДатаВерсии >= ОписаниеВерсии.ДатаВерсии Тогда
					СтрокаВнешнейКомпоненты.Версия        = ОписаниеВнешнейКомпоненты.Версия;
					СтрокаВнешнейКомпоненты.Представление = ОбновлениеНеТребуется(СтрокаВнешнейКомпоненты.Наименование);
				Иначе
					СтрокаВнешнейКомпоненты.ТребуетсяОбновление = Истина;
					СтрокаВнешнейКомпоненты.Отметка             = Истина;
					СтрокаВнешнейКомпоненты.Представление = СтрокаВнешнейКомпоненты.Наименование;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ДанныеВнешнихКомпонент.Количество() <> 0 Тогда
		ДанныеВнешнихКомпонент.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборВнешнихКомпонент;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Не найдены доступные обновления внешних компонент.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзФайлаНаСервере()
	
	ДанныеВнешнихКомпонент.Очистить();
	
	ИмяФайлОбновления = ПолучитьИмяВременногоФайла(".zip");
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайлаОбновления);
	ДанныеФайла.Записать(ИмяФайлОбновления);
	ДанныеФайла = Неопределено;
	
	ВерсииВнешнихКомпонент = ПолучениеВнешнихКомпонент.ВерсииВнешнихКомпонентИзФайла(
		ИмяФайлОбновления);
	ФайловаяСистема.УдалитьВременныйФайл(ИмяФайлОбновления);
	
	ВерсииВнешнихКомпонент = ВерсииВнешнихКомпонент.ДанныеВнешнихКомпонент;
	Если ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не удалось получить описание внешних компонент из файла (подробнее см. Журнал регистрации).'"));
		Возврат;
	КонецЕсли;
	
	УдалитьНедоступныеВерсииКомпонентНаСервере(
		ВерсииВнешнихКомпонент,
		ИдентификаторыВнешнихКомпонент);
	
	Если ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не найдены доступные обновления указанных внешних компонент.'"));
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформацияОДоступныхОбновленияхНаСервере(ВерсииВнешнихКомпонент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьНедоступныеВерсииКомпонентНаСервере(
		ВерсииКомпонент,
		Идентификаторы)
	
	Если Идентификаторы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиУдалить = Новый Массив;
	Для Каждого ВерсияКомпоненты Из ВерсииКомпонент Цикл
		Если Идентификаторы.НайтиПоЗначению(ВерсияКомпоненты.Идентификатор) = Неопределено Тогда
			СтрокиУдалить.Добавить(ВерсияКомпоненты);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ВерсияКомпоненты Из СтрокиУдалить Цикл
		ВерсииКомпонент.Удалить(ВерсияКомпоненты);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДоступныхОбновленияхИзФайла()
	
	ДанныеВнешнихКомпонент.Очистить();
	
	Если Не ЗначениеЗаполнено(ФайлОбновления) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбран файл обновления.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	КомпонентыПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ФайлОбновления);
	Если КомпонентыПути.Расширение <> ".zip" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Неверный формат файла.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	ВерсииВнешнихКомпонент = ПолучениеВнешнихКомпонентКлиент.ВерсииВнешнихКомпонентВФайле(
		ФайлОбновления);
	Если ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не удалось получить описание внешних компонент из файла (подробнее см. Журнал регистрации).'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	УдалитьНедоступныеВерсииКомпонент(ВерсииВнешнихКомпонент, ИдентификаторыВнешнихКомпонент);
	Если ВерсииВнешнихКомпонент.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не найдены доступные обновления указанных внешних компонент.'"));
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформацияОДоступныхОбновленияхНаСервере(ВерсииВнешнихКомпонент);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНедоступныеВерсииКомпонент(ВерсииКомпонент, Идентификаторы)
	
	Если Идентификаторы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Массив;
	
	Для Каждого ВерсияКомпоненты Из ВерсииКомпонент Цикл
		Если Идентификаторы.НайтиПоЗначению(ВерсияКомпоненты.Идентификатор) <> Неопределено Тогда
			Результат.Добавить(ВерсияКомпоненты);
		КонецЕсли;
	КонецЦикла;
	
	ВерсииКомпонент = Результат;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформацияОДоступныхОбновленияхНаСервере(Знач ВерсииВнешнихКомпонент)
	
	ВерсииВнешнихКомпонентИБ = ПолучениеВнешнихКомпонент.ДанныеВнешнихКомпонентДляИнтерактивногоОбновления(
		ИдентификаторыВнешнихКомпонент);
	
	Для Каждого ВерсияВнешнейКомпоненты Из ВерсииВнешнихКомпонент Цикл
		
		ТребуетсяОбновление = Истина;
		ВнешняяКомпонентаИспользуется = Ложь;
		Для Каждого ВерсияВнешнейКомпонентыИБ Из ВерсииВнешнихКомпонентИБ Цикл
			Если ВерсияВнешнейКомпонентыИБ.Идентификатор = ВерсияВнешнейКомпоненты.Идентификатор Тогда
				ВнешняяКомпонентаИспользуется = Истина;
				Если ВерсияВнешнейКомпонентыИБ.ДатаВерсии >= ВерсияВнешнейКомпоненты.ДатаВерсии Тогда
					ТребуетсяОбновление = Ложь;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ОписаниеВнешнейКомпоненты = ДанныеВнешнихКомпонент.Добавить();
		ОписаниеВнешнейКомпоненты.Отметка      = ВнешняяКомпонентаИспользуется И ТребуетсяОбновление;
		ОписаниеВнешнейКомпоненты.Наименование = ВерсияВнешнейКомпоненты.Наименование;
		Если Не ВнешняяКомпонентаИспользуется Тогда
			ОписаниеВнешнейКомпоненты.Представление = КомпонентаНеИспользуется(ВерсияВнешнейКомпоненты.Наименование);
		ИначеЕсли ТребуетсяОбновление Тогда
			ОписаниеВнешнейКомпоненты.Представление = ВерсияВнешнейКомпоненты.Наименование;
		Иначе
			ОписаниеВнешнейКомпоненты.Представление = ОбновлениеНеТребуется(ВерсияВнешнейКомпоненты.Наименование);
		КонецЕсли;
		
		ОписаниеВнешнейКомпоненты.Версия              = ВерсияВнешнейКомпоненты.Версия;
		ОписаниеВнешнейКомпоненты.ДатаВерсии          = ВерсияВнешнейКомпоненты.ДатаВерсии;
		ОписаниеВнешнейКомпоненты.ТребуетсяОбновление = ТребуетсяОбновление;
		ОписаниеВнешнейКомпоненты.Используется        = ВнешняяКомпонентаИспользуется;
		ОписаниеВнешнейКомпоненты.Идентификатор       = ВерсияВнешнейКомпоненты.Идентификатор;
		ОписаниеВнешнейКомпоненты.ИдентификаторФайла  = ВерсияВнешнейКомпоненты.ИмяФайла;
		
	КонецЦикла;
	
	Если ДанныеВнешнихКомпонент.Количество() <> 0 Тогда
		ДанныеВнешнихКомпонент.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборВнешнихКомпонент;
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Не найдены доступные обновления внешних компонент.'"));
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеВнешнихКомпонентИзФайлаПослеЗагрузки(
		ПомещенныеФайлы,
		ДополнительныеПараметры) Экспорт
	
	Если ЭтоАдресВременногоХранилища(ПомещенныеФайлы) Тогда
		АдресФайла = ПомещенныеФайлы;
	ИначеЕсли ПомещенныеФайлы = Неопределено
		Или ПомещенныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Файл с обновлениями не загружен.'"));
		Возврат;
	Иначе
		АдресФайла = ПомещенныеФайлы[0].Хранение
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеВнешнихКомпонентИзФайла(
		АдресФайла);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеВнешнихКомпонентЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено"
		Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеВнешнихКомпонентЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость  = Ложь;
	Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Обработка файлов внешней компоненты на сервере.'");
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеВнешнихКомпонентИзФайла(Знач АдресФайла)
	
	Отбор = Новый Структура("Отметка", Истина);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(АдресФайла));
	ПараметрыПроцедуры.Вставить("ДанныеВнешнихКомпонент", ДанныеВнешнихКомпонент.Выгрузить(Отбор));
	УдалитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обработка файлов внешней компоненты на сервере.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПолучениеВнешнихКомпонент.ИнтерактивноеОбновлениеВнешнихКомпонентИзФайла",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеВнешнихКомпонентСервис()
	
	ИндикаторОбновления = 0;
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения(
		"ОбновитьИндикаторЗагрузки",
		ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеВнешнихКомпонентИзСервиса();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеВнешнихКомпонентЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено"
		Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеВнешнихКомпонентЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость = Истина;
	Элементы.ДекорацияСостояние.Заголовок  = НСтр("ru = 'Выполняется обновление внешних компонент. Обновление может занять от
		|нескольких минут до нескольких часов в зависимости от размера обновления.'");
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеВнешнихКомпонентИзСервиса()
	
	ДанныеВнешнихКомпонентПодготовка = ДанныеВнешнихКомпонент.Выгрузить();
	ДанныеВнешнихКомпонентПодготовка.Колонки.Добавить("ДанныеФайла");
	СтрокиУдалить = Новый Массив;
	Для Каждого ОписаниеВнешнейКомпоненты Из ДанныеВнешнихКомпонентПодготовка Цикл
		Если Не ОписаниеВнешнейКомпоненты.Отметка Тогда
			СтрокиУдалить.Добавить(ОписаниеВнешнейКомпоненты);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ОписаниеВнешнейКомпоненты Из СтрокиУдалить Цикл
		ДанныеВнешнихКомпонентПодготовка.Удалить(ОписаниеВнешнейКомпоненты);
	КонецЦикла;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеВнешнихКомпонент", ДанныеВнешнихКомпонентПодготовка);
	ПараметрыПроцедуры.Вставить("РежимОбновления",        РежимОбновления);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление данных внешних компонент.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПолучениеВнешнихКомпонент.ИнтерактивноеОбновлениеВнешнихКомпонентИзСервиса",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеВнешнихКомпонентИзФайла()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьОбновлениеВнешнихКомпонентИзФайлаПослеЗагрузки",
		ЭтотОбъект);
	
	ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(ФайлОбновления);
	
	ФайлыОбновлений = Новый Массив;
	ФайлыОбновлений.Добавить(ОписаниеПередаваемогоФайла);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Интерактивно = Ложь;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(
		ОписаниеОповещения,
		ПараметрыЗагрузки,
		ФайлыОбновлений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндикаторЗагрузки(СтатусВыполнения, ДополнительныеПараметры) Экспорт
	
	Результат = ПрочитатьПрогресс(СтатусВыполнения.ИдентификаторЗадания);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндикаторОбновления = Результат.Процент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеВнешнихКомпонентЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = РезультатОбновления(Результат.АдресРезультата);
		Если ЕстьОшибкаОбновленияВнешнихКомпонент(РезультатОперации) Тогда
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				СообщениеОбОшибкеОбновленияВнешнихКомпонент(РезультатОперации));
		Иначе
			УстановитьОтображениеУспешногоЗавершения(ЭтотОбъект);
		КонецЕсли;
		
		// Обновление открытых форм внешних компонент.
		Идентификаторы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ДанныеВнешнихКомпонент Цикл
			Если СтрокаТаблицы.Отметка Тогда
				Идентификаторы.Добавить(СтрокаТаблицы.Идентификатор);
			КонецЕсли;
		КонецЦикла;
		
		Оповестить(
			ПолучениеВнешнихКомпонентКлиент.ИмяСобытияОповещенияОЗагрузки(),
			Идентификаторы,
			ЭтотОбъект);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			ИнформацияОбОшибке,
			Истина);
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатОбновления(Адрес)
	
	РезультатОперации = ПолучитьИзВременногоХранилища(Адрес);
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибки", Новый Соответствие);
	Результат.Вставить("КодОшибки", "");
	Результат.Вставить("СообщениеОбОшибке", "");
	
	ЗаполнитьЗначенияСвойств(Результат, РезультатОперации);
	
	Возврат Результат
	
КонецФункции

&НаКлиенте
Функция ЕстьОшибкаОбновленияВнешнихКомпонент(РезультатОперации)
	
	Возврат РезультатОперации.Ошибки.Количество() = 0
		И Не ПустаяСтрока(РезультатОперации.КодОшибки);
	
КонецФункции

&НаКлиенте
Функция СообщениеОбОшибкеОбновленияВнешнихКомпонент(РезультатОперации)
	
	Результат = "";
	Если РезультатОперации.Ошибки.Количество() > 0 Тогда
		
		ОшибкиОперации = Новый Массив;
		ОшибкиОперации.Добавить(НСтр("ru = 'При обновлении внешних компонент возникли ошибки:'"));
		Для Каждого ОшибкаОперации Из РезультатОперации.Ошибки Цикл
			ОшибкиОперации.Добавить(ОшибкаОперации.Значение);
		КонецЦикла;
		Результат = СтрСоединить(ОшибкиОперации, Символы.ПС);
		
	ИначеЕсли Не ПустаяСтрока(РезультатОперации.СообщениеОбОшибке) Тогда
		Результат = РезультатОперации.СообщениеОбОшибке;
	Иначе
		ВызватьИсключение НСтр("ru = 'Неизвестный результат операции обновления внешних компонент.'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		Элементы.КнопкаНазад.Видимость = Форма.РазрешенВыборРежимаОбновления;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборВнешнихКомпонент Тогда
		Элементы.КнопкаНазад.Видимость = Форма.РазрешенВыборРежимаОбновления;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультатыОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Форма.РазрешенВыборРежимаОбновления;
		Элементы.КнопкаДалее.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.РежимОбновления = РежимОбновленияИзСервиса() Тогда
		Элементы.ФайлОбновления.Доступность = Ложь;
	Иначе
		Элементы.ФайлОбновления.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеИнформацииОбОшибке(
		Форма,
		ИнформацияОбОшибке,
		Ошибка = Ложь)
	
	ПредставлениеОшибки = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
				|
				|Подробную информацию см. в <a href = ""action:openLog"">Журнале регистрации</a>.'"),
			ИнформацияОбОшибке));
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = ?(
		Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеУспешногоЗавершения(Форма)
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Успешно32;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Обновление внешних компонент успешно завершено.'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентВерсия.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентПредставление.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентОтметка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеВнешнихКомпонент.ТребуетсяОбновление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентВерсия.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентПредставление.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеВнешнихКомпонентОтметка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеВнешнихКомпонент.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметку(Значение)
	
	Для Каждого СтрокаВнешнейКомпоненты Из ДанныеВнешнихКомпонент Цикл
		СтрокаВнешнейКомпоненты.Отметка = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияИзСервиса()
	
	Возврат 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияИзФайла()
	
	Возврат 2;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбновлениеНеТребуется(Наименование)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (обновление не требуется)'"),
		Наименование);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КомпонентаНеИспользуется(Наименование)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (не используется)'"),
		Наименование);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьПараметрыПолученияИнформацииОбОбновлениях(Знач ФильтрВнешнихКомпонент)
	
	ВерсииВнешнихКомпонент = ПолучениеВнешнихКомпонент.ДанныеВнешнихКомпонентДляИнтерактивногоОбновления(
		ФильтрВнешнихКомпонент);
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ВерсииВнешнихКомпонент", ВерсииВнешнихКомпонент);
	
	Возврат ПараметрыПолучения;
	
КонецФункции

#КонецОбласти
