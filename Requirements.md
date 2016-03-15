# Требования #

Данная страница посвящена системным и проектным требованиям.<br>
<i>Системные требования</i> - это требования, соблюдение которых необходимо для правильного функционирования системы.<br>
<i>Проектные требования</i> - это требования, которые касаются процесса разработки приложения.<br>
<br>
<br>

<h1>Системные требования</h1>

<ul><li>Операционная система Windows 2000 SP2 или выше<br>
</li><li>Установленная и запущенная служба <a href='http://msdn.microsoft.com/en-us/library/aa394582(VS.85).aspx'>WMI</a> (Windows Management Instrumentation)<br>
</li><li>Наличие учётной записи с правами локального администратора, от имени которой приложение будет запускаться и соединяться с рабочими станциями <code>*</code>
</li><li>СУБД - <a href='http://www.mysql.com/downloads/mysql/'>MySQL</a> 5.1.xx<br>
</li><li><a href='http://www.mysql.com/downloads/connector/c/'>MySQL Connector/C</a> <code>**</code></li></ul>

Данные требования касаются как сервера приложения, так и клиентских рабочих станций.<br>
<br>
<code>*</code> Иными словами, если на сервере приложения есть некая учётная запись А, входящая в группу локальных администраторов, то на инвентаризуемых рабочих станциях тоже должна быть такая же учётная запись А, входящая в эту группу, а приложение должно запускаться на сервере от имени А.<br>
<code>**</code> Библиотеку libmysql.dll поместить либо в системную папку (%WINDIR%), либо в папку с исполняемым файлом приложения.<br>
<br>
<br>

<h1>Проектные требования</h1>

<h2>Общие проектные требования</h2>

<ul><li>IDE - <a href='http://www.embarcadero.com/products/rad-studio'>Embarcadero® RAD Studio®</a> 2010 и выше<br>
</li><li>Основной язык программирования - Delphi®<br>
</li><li>СУБД - <a href='http://www.mysql.com/downloads/mysql/'>MySQL</a> 5.1.xx</li></ul>

<i>Основной язык программирования</i> - язык программирования, на котором пишется основная логика системы. Некоторые части продукта могут использовать другие языки программирования. Такое может наблюдаться в случаях, например, плагинов или XML/HTML/CSS/JS содержимого.<br>
<br>
<h2>Компоненты IDE</h2>

<ul><li><a href='http://www.alphaskins.com/'>AlphaControls</a>
</li><li><a href='http://code.google.com/p/delphi-spring-framework/'>Delphi Spring Framework</a>
</li><li><a href='http://code.google.com/p/delphilhlplib/'>DeHL (Delphi Help Lib)</a>
</li><li><a href='http://wiki.delphi-jedi.org/index.php?title=JEDI_Code_Library'>JEDI Code Library</a>
</li><li><a href='http://jvcl.delphi-jedi.org/'>JEDI VCL</a>
</li><li><a href='http://madshi.net/index.htm'>madExcept</a>
</li><li><a href='http://code.google.com/p/omnithreadlibrary/'>OmniThreadLibrary</a>
</li><li><a href='http://zeos.firmos.at/'>ZeosDBO (ZeosLib)</a>
</li><li><a href='http://tjabberclient.sourceforge.net/'>TJabberClient</a>
</li><li><a href='http://sourceforge.net/projects/glibwmi/'>GLibWMI</a>
</li><li><a href='http://lockbox.seanbdurkin.id.au/'>TurboPower LockBox</a></li></ul>

<h2>Руководство по стилю написания кода</h2>

Главным руководством по стилю написания кода является <a href='http://wiki.delphi-jedi.org/index.php?title=Style_Guide'>JCL Delphi Language Style Guide</a>. Это не означает полное и безоговорочное следование данному руководству, однако примерно на 90% оно совпадает с моими собственными кодовоззрениями :)<br>
И ещё один момент касательно кода: все файлы с исходными кодами должны быть в кодировке UTF-8.