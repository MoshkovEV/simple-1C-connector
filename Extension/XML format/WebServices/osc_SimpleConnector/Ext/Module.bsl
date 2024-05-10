﻿//Выполняет произвольный запрос в БД. Помещает результат выполнения запроса в параметр queryResult. 
//Запрос должен быть одиночным. Для выполнения пакета запросов должна использоваться операция "executeQuryPackage"
//Возвращаемый результат сериализуется в соответствии с параметром queryParametrsSerializationType (если = 0 то возвращается без сериализации)
//
// Параметры:
//  <queryText>  - <Строка> - Текст запроса
//  <qureyParameters>  - <Произвольный> - Одиночный параметр произвольного типа или сериализованная структура параметров запроса
//  <queryParametrsSerializationType> - <Число> - Код вида сериализации параметров запроса: 0 - без сериализации(одиночный строковый параметр), 1 - XML
//  <queryResult> - <Произвольный> - Параметр, в котрый будет помещён результат выполнения запроса.  
//  <querySingleParametrName> - <Строка> - Имя одиночного параметра. Должен быть заполнен при queryParametrsSerializationType = 0 
//  <errorReport> - <Строка> - Переменная, в которую будет помещено описание ошибки при возникновении исключения при выполнении запроса;
//
// Возвращаемое значение:
//   <Integer> - Не обязательный, Код результата выполнения запроса: 0 - запрос выполнен без ошибок, 
//                                                                   1 - При выполнении функции возникло исключение, 
//                                                                   2 - Запрос выполнен без ошибок, но получен пустой результат
//
Функция executeQuery(queryText, qureyParameters, queryParametrsSerializationType, queryResult, querySingleParametrName = "", errorReport = "")
	
	Запрос = Новый Запрос;
	Запрос.Текст = queryText;
	
	queryResult = "";
	result = 2;
	
	Попытка
		
		Если queryParametrsSerializationType = 0 Тогда
			Запрос.УстановитьПараметр(querySingleParametrName, qureyParameters);
		ИначеЕсли queryParametrsSerializationType = 1 Тогда
			СтруктураПараметров = osc_СериализацияКлиентСервер.ДесериализоватьXML(qureyParameters);
			Для Каждого Элемент Из СтруктураПараметров Цикл 
				Запрос.УстановитьПараметр(Элемент.Ключ, Элемент.Значение);    
			КонецЦикла;
		Иначе
			errorReport = "Invalid value of the query parameters serialization type";
			result = 1;
		КонецЕсли;
		
		Если result <> 1 Тогда
			Результат = Запрос.Выполнить();	  //Запрос может быть пакетом, этот вариант будет реализован в следующем релизе.
			Если Результат.Пустой() Тогда	
				result = 2;		
			Иначе
				queryResult = osc_СериализацияКлиентСервер.СериализоватьXML(Результат.Выгрузить());
				result = 0;
			КонецЕсли;
		КонецЕсли;
		
	Исключение
		errorReport = ОписаниеОшибки();
		result = 1;
	КонецПопытки;
	
	Возврат result;
	
КонецФункции
