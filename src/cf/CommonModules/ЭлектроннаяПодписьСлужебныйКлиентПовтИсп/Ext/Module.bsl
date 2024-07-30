﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция АккредитованныеУдостоверяющиеЦентры() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебныйВызовСервера.АккредитованныеУдостоверяющиеЦентры();
	
КонецФункции

Функция ДанныеУдостоверяющегоЦентра(ЗначенияПоиска) Экспорт
	
	АккредитованныеУдостоверяющиеЦентры = ЭлектроннаяПодписьСлужебныйКлиентПовтИсп.АккредитованныеУдостоверяющиеЦентры();
	Если АккредитованныеУдостоверяющиеЦентры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиентСерверЛокализация = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиентСерверЛокализация");
	Возврат МодульЭлектроннаяПодписьКлиентСерверЛокализация.ДанныеУдостоверяющегоЦентра(ЗначенияПоиска, АккредитованныеУдостоверяющиеЦентры);
	
КонецФункции

Функция ОшибкаПоКлассификатору(ТекстОшибки) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебныйВызовСервера.ОшибкаПоКлассификатору(ТекстОшибки);
	
КонецФункции

#КонецОбласти