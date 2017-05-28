#Использовать v8runner
#Использовать logos

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

    Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

ПутьКРепозитарию = АргументыКоманднойСтроки[0];
ИмяРабочейБазы = АргументыКоманднойСтроки[1];
Пользователь = АргументыКоманднойСтроки[3];
Пароль = АргументыКоманднойСтроки[4];

ИмяФайлаЖурнала = ОбъединитьПути(ТекущийКаталог(), "Logs", ИмяБазы, "update.log");
Файл = Новый Файл(ИмяФайлаЖурнала);
СоздатьКаталог(Файл.Путь);
КаталогЖурналов = Файл.Путь;

Журнал = Логирование.ПолучитьЛог("update.app.production");
Журнал.УстановитьУровень(УровниЛога.Информация);
Журнал.УстановитьРаскладку(ЭтотОбъект);

КонсольЖурн = Новый ВыводЛогаВКонсоль;
ФайлЖурнала = Новый ВыводЛогаВФайл;
ФайлЖурнала.ОткрытьФайл(ИмяФайлаЖурнала);

Журнал.ДобавитьСпособВывода(ФайлЖурнала);
Журнал.ДобавитьСпособВывода(КонсольЖурн);

//Версия рабочего сервера отличается от версии сервера разработки
ПутьКПлатформе1С = УправлениеКонфигуратором.ПолучитьПутьКВерсииПлатформы("8.3.9");

//Проверяем флаг и если есть, обновляем
Файл Новый Файл(ОбъединитьПути(ПутьКРепозитарию, "Deploy\needupdate.flg"));

Если Файл.Существует() Тогда

	ЧТ = Новый ЧтениеТекста(Файл.ПолноеИмя);
	ИмяФайлаКонфигарции = ЧТ.Прочитать();
	ЧТ.Закрыть();
	
	Журнал.Информация("Начало обновления рабочей базы");
	ПроцессКонфигуратора = Создатьпроцесс("""" + ПутьКПлатформе1С + """ DESIGNER /UC 456654 /IBName """ + ИмяБазы + """ /N """ + Пользователь +""" /P """ + Пароль + """ /CreateDistributionFiles -cffile " + ПутьКРепозитарию + "\Deploy\1cv8.cf /out " + ЖурналВыгрузкиФайлапоставки
											,ПутьКРепозитарию
											,Истина
											,Ложь
											,КодировкаТекста.UTF8);
	ПроцессКонфигуратора.Запустить();										
	ПроцессКонфигуратора.ОжидатьЗавершения();
	

КонецЕсли;