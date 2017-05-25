
Функция ОбработатьФайлИзменений(ПутьКРепозитарию, ИмяФайлаСпискаФайлов, Журнал) Экспорт
	
	ИмяВрФайла = ПолучитьИмяВременногоФайла ();

	// Добавить путь к репозитарию
	ЧТ = Новый ЧтениеТекста(ИмяФайлаСпискаФайлов, КодировкаТекста.UTF8);
	ЗТ = Новый ЗаписьТекста(ИмяВрФайла, КодировкаТекста.UTF8);

	Стр = ЧТ.ПрочитатьСтроку();
	СтрЗТ = "";

	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Новый");
	ТЗ.Колонки.Добавить("Путь");
	ТЗ.Колонки.Добавить("Уровень");

	Пока не Стр = неопределено Цикл

		Журнал.Отладка("Обрабатываю " + Стр);
		
		Если Не СокрЛП(Стр) = "" И СтрНайти(Стр, "ConfigDumpInfo.xml") = 0 Тогда

			Стр = СтрРазделить(Стр, Символы.Таб);
		
			СтрЗТ = "" + ПутьКРепозитарию + "\" + СтрЗаменить(Стр[1],"/","\");
			
		Иначе

			СтрЗТ = "";
		
		КонецЕсли;
		
		// ПозФормы = СтрНайти(СтрЗТ, "\Ext\Form");
		// Если ПозФормы > 0 Тогда
		
			// СтрЗТ = Сред(СтрЗТ, 1, ПозФормы - 1) + ".xml";
			
		// КонецЕсли;	

		// ПозМакета = СтрНайти(СтрЗТ, "\Ext\Template");

		// Если ПозМакета > 0 Тогда
		
			// СтрЗТ = Сред(СтрЗТ, 1, ПозМакета - 1) + ".xml";
			
		// КонецЕсли;	
		
		// ПозПрава = СтрНайти(СтрЗТ, "\Ext\Rights");
		
		// Если ПозПрава > 0 Тогда
		
			// СтрЗТ = Сред(СтрЗТ, 1, ПозПрава - 1) + ".xml";
			
		// КонецЕсли;	
		
		// ПозСправка = СтрНайти(СтрЗТ, "\Ext\Help");

		// Если ПозСправка > 0 Тогда
		
			// СтрЗТ = Сред(СтрЗТ, 1, ПозСправка - 1) + ".xml";
			
		// КонецЕсли;	

		Если СтрНайти(СтрЗТ, "\Config") > 0 НЕ СокрЛП(СтрЗТ) = "" Тогда
		
			Если (Стр[0] = "A" //или СтрНайти(СтрЗТ, "Forms") > 0
			) и СтрЗаканчиваетсяНа(СтрЗТ, "xml") Тогда
		
				МасСтр = СтрРазделить(СтрЗТ, "\");
				МасСтр.Удалить(МасСтр.Количество() - 1);
				МасСтр.Удалить(МасСтр.Количество() - 1);
				
				СтрРодитель = СтрСоединить(МасСтр, "\") + ".xml";
				СтрРодитель = СтрЗаменить(СтрРодитель, "Config.xml","Config\Configuration.xml");
	
				СтрТз= ТЗ.Добавить();
				СтрТз.Путь = СтрРодитель;
				СтрТз.Уровень = СтрЧислоВхождений(СтрРодитель, "\");
			
				Журнал.Информация(СтрЗТ + " -> " + СтрРодитель);
			
			КонецЕсли;
		
			СтрТз= ТЗ.Добавить();
			СтрТз.Путь = СтрЗТ;
			СтрТз.Уровень = СтрЧислоВхождений(СтрЗТ, "\");
		
		КонецЕсли;
		
		Стр = ЧТ.ПрочитатьСтроку();
		
	КонецЦикла; 

	ТЗ.Сортировать("Уровень, Путь");
	ТЗ.Свернуть("Путь");

	Для каждого СтрТз из ТЗ Цикл
		
		ЗТ.ЗаписатьСтроку(СтрТз.Путь);

	КонецЦикла;

	ЗТ.Закрыть();
	ЧТ.Закрыть();

	УдалитьФайлы(ИмяФайлаСпискаФайлов);
	ПереместитьФайл(ИмяВрФайла, ИмяФайлаСпискаФайлов);

	Возврат ТЗ.Количество();
	
КонецФункции

Процедура ПерейтиНаВетку(ПутьКРепозитарию, ИмяВетки) Экспорт

	ЗапуститьПриложение("git checkout " + ИмяВетки, ПутьКРепозитарию, Истина);

КонецПроцедуры

Процедура ПолучитьСписокИзмененийВФайл(Знач ПутьКРепозитарию, Знач ИмяФайлаСпискаФайлов, Журнал) Экспорт
	
	//cmd /C 
	//ИмяФайлаСпискаФайлов = СтрЗаменить(ИмяФайлаСпискаФайлов, "\", "/");
	//ИмяФайлаСпискаФайлов = СтрЗаменить(ИмяФайлаСпискаФайлов, ":", "");
	ЗапуститьПриложение("cmd /C git diff HEAD^^..HEAD --name-status > " + ИмяФайлаСпискаФайлов, ПутьКРепозитарию, Истина);
	
КонецПроцедуры
