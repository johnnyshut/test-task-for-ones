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

	УстановитьУсловноеОформление();
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда
		Элементы.Список.Видимость = Ложь;
		Элементы.КоманднаяПанельСписка.Видимость = Ложь;
		Элементы.ДеревоЗадач.Видимость = Истина;
	Иначе	
		Элементы.Список.Видимость = Истина;
		Элементы.КоманднаяПанельСписка.Видимость = Истина;
		Элементы.ДеревоЗадач.Видимость = Ложь;
	КонецЕсли;	
		
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Задачи бизнес-процесса %1'"), Строка(Параметры.ЗначениеОтбора));
		
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
		Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,"БизнесПроцесс", Параметры.ЗначениеОтбора);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадач();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьВыполненные = Настройки["ПоказыватьВыполненные"];
	ОбновитьСписокЗадач();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьВыполненныеПриИзменении(Элемент)
	
	ОбновитьСписокЗадач();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоЗадач

&НаКлиенте
Процедура ДеревоЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДеревоЗадач();
	Для каждого Элемент Из ДеревоЗадач.ПолучитьЭлементы() Цикл
		Элементы.ДеревоЗадач.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадач.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЗадач.Просрочена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадач.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЗадач.Выполнена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗавершенныйБизнесПроцесс);

	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадач()
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Выполнена");
		Если НЕ ПоказыватьВыполненные Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Выполнена", Ложь);
		КонецЕсли;
		Элементы.Список.Обновить();
	КонецЕсли;
	// Цвет просроченных задач зависит от значения текущей даты,
	// поэтому нужно переинициализировать условное оформление.
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущуюСтрокуДереваЗадач()
	
	Если Элементы.ДеревоЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗадач()
	
	Дерево = РеквизитФормыВЗначение("ДеревоЗадач");
	Дерево.Строки.Очистить();
	
	ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, Параметры.ЗначениеОтбора);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоЗадач");
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, БизнесПроцессСсылка)
	
	Ветвь = Дерево.Строки.Найти(БизнесПроцессСсылка, "Ссылка", Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗадачиИсполнителя.Ссылка,
		|	ЗадачиИсполнителя.Наименование,
		|	ЗадачиИсполнителя.Исполнитель,
		|	ЗадачиИсполнителя.РольИсполнителя,
		|	ЗадачиИсполнителя.СрокИсполнения,
		|	ЗадачиИсполнителя.Выполнена,
		|	ВЫБОР
		|		КОГДА ЗадачиИсполнителя.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА ЗадачиИсполнителя.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА ЗадачиИсполнителя.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачиИсполнителя
		|ГДЕ
		|	ЗадачиИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И ЗадачиИсполнителя.ПометкаУдаления = ЛОЖЬ";
	Если Не ПоказыватьВыполненные Тогда	
		Запрос.Текст = Запрос.Текст + "
			|	И ЗадачиИсполнителя.Выполнена = &Выполнена"; // @query-part
		Запрос.УстановитьПараметр("Выполнена", Ложь);
	КонецЕсли;	
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);

	ЗадачиПоПредмету = БизнесПроцессыИЗадачиСервер.НовыеЗадачиПоПредмету();
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Строка = Неопределено;
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
		Иначе	
			Строка = Ветвь.Строки.Добавить();
		КонецЕсли;
		
		Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
		Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
		Строка.Тип = 1;
		Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
		Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
		Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
		Если ВыборкаДетальныеЗаписи.СрокИсполнения <> '00010101000000' 
			И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
			Строка.Просрочена = Истина;
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Исполнитель) Тогда
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
		Иначе
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
		КонецЕсли;
		
		НоваяСтрока = ЗадачиПоПредмету.Добавить();
		НоваяСтрока.ЗадачаСсылка = ВыборкаДетальныеЗаписи.Ссылка;
		
	КонецЦикла;
	
	ДобавитьПодчиненныеБизнесПроцессы(Дерево, ЗадачиПоПредмету);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеБизнесПроцессы(Дерево, ЗадачиПоПредмету)
	
	ЗапросТекст = 
		"ВЫБРАТЬ
		|	ЗадачиПоПредмету.ЗадачаСсылка КАК ЗадачаСсылка,
		|	БизнесПроцессы.Ссылка,
		|	БизнесПроцессы.Наименование,
		|	БизнесПроцессы.Завершен,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	ЗадачиПоПредмету КАК ЗадачиПоПредмету
		|	ЛЕВОЕ СОЕДИНЕНИЕ &БизнесПроцессы КАК БизнесПроцессы
		|	ПО БизнесПроцессы.ГлавнаяЗадача = ЗадачиПоПредмету.ЗадачаСсылка
		|ГДЕ
		|   БизнесПроцессы.ПометкаУдаления = ЛОЖЬ";
		
	НаборТекстовЗапросов = Новый Массив();
		
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		// У бизнес-процесса может и не быть главной задачи.
		РеквизитГлавнаяЗадача = МетаданныеБизнесПроцесса.Реквизиты.Найти("ГлавнаяЗадача");
		Если РеквизитГлавнаяЗадача = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстПодзапроса = СтрЗаменить(ЗапросТекст, "&БизнесПроцессы", МетаданныеБизнесПроцесса.ПолноеИмя());
		Если НаборТекстовЗапросов.Количество() = 0 Тогда
			ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса, "ВЫБРАТЬ", "ВЫБРАТЬ РАЗРЕШЕННЫЕ"); // @Query-part-1, @Query-part-2
		КонецЕсли; 
		НаборТекстовЗапросов.Добавить(ТекстПодзапроса);
		
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ЗадачиПоПредмету.ЗадачаСсылка КАК ЗадачаСсылка
	|ПОМЕСТИТЬ ЗадачиПоПредмету
	|ИЗ
	|	&ЗадачиПоПредмету КАК ЗадачиПоПредмету
	|;
	|" + СтрСоединить(НаборТекстовЗапросов, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗадачиПоПредмету", ЗадачиПоПредмету);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Ветвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.ЗадачаСсылка, "Ссылка", Истина);
		
		Строка              = Ветвь.Строки.Добавить();
		
		Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
		Строка.Важность     = ВыборкаДетальныеЗаписи.Важность;
		Строка.Остановлен   = ВыборкаДетальныеЗаписи.Остановлен;
		Строка.Ссылка       = ВыборкаДетальныеЗаписи.Ссылка;
		Строка.Выполнена    = ВыборкаДетальныеЗаписи.Завершен;
		Строка.Тип          = 0;
		
		// @skip-check query-in-loop - Рекурсивный алгоритм обработки дерева.
		ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
